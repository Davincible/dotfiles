{ lib, pkgs }:

let
  # Utility to read and extract content from a script
  readScript = scriptPath: lib.readFile scriptPath;

  # Extract lines matching a specific pattern
  extractLineWith = { pattern, scriptContent }:
    let
      matchedLines = builtins.match pattern scriptContent;
      extracted =
        if matchedLines != null && builtins.length matchedLines > 0
        then
          lib.splitString " " (builtins.head matchedLines)
        else
          [ ];
    in
    extracted;

  # Extract dependencies from script comments
  extractDeps = scriptContent: extractLineWith {
    pattern = ".*#[ ]+deps:[ ]+([a-zA-Z0-9 \-]+).*";
    scriptContent = scriptContent;
  };

  # Extract Bash options from script comments
  extractOptions = scriptContent:
    let
      defaultOptions = [ "errexit" "nounset" ];
      optionsPattern = ".*#[ ]+options:[ ]+([a-zA-Z0-9 \-]+).*";
      options = extractLineWith { pattern = optionsPattern; scriptContent = scriptContent; };
    in
    if options == null then
      defaultOptions
    else if options == [ ] || options == [ "none" ] then
      [ ]
    else
      options;

  # Create a Nix package from a specific script
  makeScriptPackage = { scriptPath }:
    let
      scriptContent = readScript scriptPath;
      name = builtins.baseNameOf scriptPath;
      deps = extractDeps scriptContent;
      bashOptions = extractOptions scriptContent;
      packageName = builtins.replaceStrings [ ".sh" ] [ "" ] name;
    in
    pkgs.writeShellApplication {
      name = packageName;
      text = scriptContent;
      runtimeInputs = deps;
      inherit bashOptions;
      extraShellCheckFlags = [ "--severity=error" ];
    };
in
{
  makePackagesFromScripts = scriptsDirPath:
    let
      readScriptsAndMakePackages = scriptsDir:
        let
          directoryContents = builtins.readDir scriptsDir;
          scriptFiles = builtins.filter
            (name: let type = builtins.getAttr name directoryContents; in type == "regular" && builtins.match ".*\\.sh$" name != null)
            (builtins.attrNames directoryContents);
          makePackages = name: makeScriptPackage {
            scriptPath = "${scriptsDir}/${name}";
          };
        in
        map makePackages scriptFiles;
    in
    readScriptsAndMakePackages scriptsDirPath;

  # Expose the single script package creator as an attribute
  makePackageFromScript = makeScriptPackage;
}
