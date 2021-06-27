{ pkgs ? import <nixpkgs> { }}:

pkgs.mkShell {
    name = "strace-shell";
    buildInputs = with pkgs; [ ffmpeg ];
    shellHook = ''
        echo "Getting your credentials from XYZ"
        echo "Done! your creds have been downloaded"
    '';
}