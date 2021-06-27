{ input ? "default", pkgs ? import <nixpkgs> { } }:

let 
    callPackage = pkgs.newScope { inherit input; };
    aString = "something-${input}";
    aList = callPackage ./list.nix { };
in {
    inherit aString aList;
}
