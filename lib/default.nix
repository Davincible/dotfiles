{ lib, pkgs }:

{
  # import = [
  #   ./makeScriptsPackage.nix
  # ];
  # Function to handle scripts in a directory
  scriptsDirPath = import ./makeScriptsPackage.nix { inherit lib pkgs; };
  # scriptsDirPath = (import ./make.nix { inherit lib pkgs; });

  testFunc = myPath: let 
    files = builtins.filter (name: builtins.match ".*\\.sh" name != null) (builtins.attrNames (builtins.readDir myPath));
    named = "${myPath}/yay";
  in {
   files = files;
   named = named;
  };

  # use path relative to the root of the project
  relativeToRoot = lib.path.append ../.;

  scanPaths = path:
    builtins.map
      (f: (path + "/${f}"))
      (builtins.attrNames
        (lib.attrsets.filterAttrs
          (
            path: _type:
              (_type == "directory") # include directories
              || (
                (path != "default.nix") # ignore default.nix
                && (lib.strings.hasSuffix ".nix" path) # include .nix files
              )
          )
          (builtins.readDir path)));
}
