{ stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation {
  pname = "departure-mono";
  version = "1.346";

  src = fetchzip {
    url = "https://departuremono.com/assets/DepartureMono-1.346.zip";
    hash = "sha256-xJVVtLnukcWQKVC3QiHvrfIA3W9EYt/iiphbLYT1iMg=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 DepartureMono* -t $out/share/fonts/departure-mono

    runHook postInstall
  '';
}