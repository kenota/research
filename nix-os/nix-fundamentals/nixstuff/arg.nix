{ input ? "default" }:

let 
    aString = "something-${input}";
    aList = [1 2 3 input];
in {
    inherit aString aList;
}
