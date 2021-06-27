{ input ? "default" }:

let 
    aString = "something-${input}";
    aList = import ./list.nix { inherit input;};
in {
    inherit aString aList;
}
