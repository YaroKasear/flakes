{ lib, inputs, snowfall-inputs }:

let
  inherit (inputs.nixpkgs.lib) assertMsg last;
in
{
  network = {
    ip4 = rec {
      ip = a: b: c: d: prefixLength: {
        inherit a b c d prefixLength;
        address = "${toString a}.${toString b}.${toString c}.${toString d}";
      };

      toCIDR = addr: "${addr.address}/${toString addr.prefixLength}";
      toNetworkAddress = addr: with addr; { inherit address prefixLength; };
      toNumber = addr: with addr; a * 16777216 + b * 65536 + c * 256 + d;
      fromNumber = addr: prefixLength:
        let
          aBlock = a * 16777216;
          bBlock = b * 65536;
          cBlock = c * 256;
          a = addr / 16777216;
          b = (addr - aBlock) / 65536;
          c = (addr - aBlock - bBlock) / 256;
          d = addr - aBlock - bBlock - cBlock;
        in
        ip a b c d prefixLength;

      fromString = with lib; str:
        let
          splits1 = splitString "." str;
          splits2 = flatten (map (x: splitString "/" x) splits1);

          e = i: toInt (builtins.elemAt splits2 i);
        in
        ip (e 0) (e 1) (e 2) (e 3) (e 4);

      fromIPString = str: prefixLength:
        fromString "${str}/${toString prefixLength}";

      network = addr:
        let
          pfl = addr.prefixLength;
          pow = n: i:
            if i == 1 then
              n
            else
              if i == 0 then
                1
              else
                n * pow n (i - 1);

          shiftAmount = pow 2 (32 - pfl);
        in
        fromNumber ((toNumber addr) / shiftAmount * shiftAmount) pfl;
    };

    # Split an address to get its host name or ip and its port.
    # Type: String -> Attrs
    # Usage: get-address-parts "bismuth:3000"
    #   result: { host = "bismuth"; port = "3000"; }
    get-address-parts = address:
      let
        address-parts = builtins.split ":" address;
        ip = builtins.head address-parts;
        host = if ip == "" then "127.0.0.1" else ip;
        port = if builtins.length address-parts != 3 then "" else last address-parts;
      in
      { inherit host port; };

    ## Create proxy configuration for NGINX virtual hosts.
    ##
    ## ```nix
    ## services.nginx.virtualHosts."example.com" = lib.network.create-proxy {
    ##   port = 3000;
    ##   host = "0.0.0.0";
    ##   proxy-web-sockets = true;
    ##   extra-config = {
    ##     forceSSL = true;
    ##   };
    ## }
    ## ``
    ##
    #@ { port: Int ? null, host: String ? "127.0.0.1", proxy-web-sockets: Bool ? false, extra-config: Attrs ? { } } -> Attrs
    create-proxy =
      { port ? null
      , host ? "127.0.0.1"
      , proxy-web-sockets ? false
      , extra-config ? { }
      }:
        assert assertMsg (port != "" && port != null) "port cannot be empty";
        assert assertMsg (host != "") "host cannot be empty";
        extra-config // {
          locations = (extra-config.locations or { }) // {
            "/" = (extra-config.locations."/" or { }) // {
              proxyPass =
                "http://${host}${if port != null then ":${builtins.toString port}" else ""}";

              proxyWebsockets = proxy-web-sockets;
            };
            "~* \.(js|css)$" = {
              proxyPass =
                "http://${host}${if port != null then ":${builtins.toString port}" else ""}";

              extraConfig = ''
                proxy_hide_header Cache-Control;
                add_header Cache-Control "public, max-age=21600" always;
              '';

              recommendedProxySettings = true;
            };
          };
        };
  };
}
