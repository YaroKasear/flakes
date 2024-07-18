{ pkgs, ... }:

{
  services.node-red = {
    enable = true;
    openFirewall = true;
    package = pkgs.nodePackages_latest.node-red.overrideAttrs (oldAttrs: {
      nativeBuildInputs = oldAttrs.nativeBuildInputs or [] ++ [ pkgs.makeWrapper ];
      postInstall = oldAttrs.postInstall or "" + ''
        mkdir -p $out/bin
        wrapProgram $out/bin/node-red \
          --prefix PATH : "${pkgs.lib.makeBinPath [
            # module installation
            pkgs.nodejs
            pkgs.nodePackages.npm
            pkgs.bash
            pkgs.gcc
            # projects
            pkgs.git
            pkgs.openssl
            pkgs.openssh ]}"
      '';
    });
  };

  environment.systemPackages = with pkgs; [
    nodejs_20
  ];

  system.stateVersion = "24.05";
}