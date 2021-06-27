Different notes based on [nix-fundamentals](https://www.youtube.com/watch?v=m4sv2M9jRLg) video.

Everything is a function or some type.

`arg.nix` has a function which takes a map with an "input" field and default value equal to default. You can run it like this:

```
kenota@marcus nixstuff % nix-instantiate --eval --strict --arg x 1 arg.nix     
{ aString = "something-default"; }
```

You need to pass at least one bogus arg, otherwise the unevaluated lambda will be returned. The string should be passed using an `--argstr input value` syntax.

A bit of evolution, this piece of code 
```
{ input ? "default" }:

let 
    aString = "something-${input}";
    aList = [1 2 3 input];
in {
    inherit aString aList;
}
```

Means that we are:

1. Defining a function which takes map which should have an "input" key. If it is not provided, a "default" value will be used
2. Defining local variables `aString` and `aList`
3. Returning a map which has inherited key and value for `aString` and `aList` from defined in a let block.


## Creating shells

Everything is a function which defines what would happen. `mkDeriviation` is about building packages, but `mkShell`, for example can help you create an environment with specific tools:

```
{ pkgs ? import <nixpkgs> { }}:

pkgs.mkShell {
    name = "strace-shell";
    buildInputs = with pkgs; [ ffmpeg ];
}
```

And then run `nix-shell shell.nix` and you have access to `ffmpeg`. Note that the version would not be pinned currently, because we are not pinning it in the `shell.nix` file.