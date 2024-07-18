{ channels, namespace, inputs, ... }:

final: prev: {
 node-red = prev.nodePackages.node-red.overrideAttrs (oldAttrs: {
    nativeBuildInputs = oldAttrs.nativeBuildInputs or [] ++ [ prev.makeWrapper ];
    postInstall = oldAttrs.postInstall or "" + ''
      mkdir -p $out/bin
      wrapProgram $out/bin/node-red \
        --prefix PATH : "${prev.lib.makeBinPath [
          # module installation
          final.nodejs
          final.nodePackages.npm
          final.bash
          final.gcc
          # projects
          final.git
          final.openssl
          final.openssh ]}"
    '';
  });
}