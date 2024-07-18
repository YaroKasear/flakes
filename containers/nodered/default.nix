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
            pkgs.python3
            # projects
            pkgs.git
            pkgs.openssl
            pkgs.openssh ]}"
      '';
    });
  };

  system.stateVersion = "24.05";
}