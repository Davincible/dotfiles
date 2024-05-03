{ lib, pkgs }:

scriptsDirPath:
let
  readScript = scriptPath: lib.readFile scriptPath;

  extractLineWith = { pattern, scriptContent }:
    let
      matchedLines = builtins.match pattern scriptContent;
      extracted = if (matchedLines != null && builtins.length matchedLines > 0) 
        then 
	  lib.splitString " " (builtins.head matchedLines)
	else 
	  null;
    in
    extracted;

  extractDeps = scriptContent: extractLineWith {
    pattern = ".*#[ ]+deps:[ ]+([a-zA-Z0-9 \-]+).*";
    scriptContent = scriptContent;
  };

  extractOptions = scriptContent: let
    defaultOptions = [ "errexit" "nounset" ];
    optionsPattern = ".*#[ ]+options:[ ]+([a-zA-Z0-9 \-]+).*";
    options = extractLineWith { pattern = optionsPattern; scriptContent = scriptContent; };
  in
    if options == null || options == [] then defaultOptions
    else options;

  makeScriptPackage = { name, scriptContent }:
    let
      deps = extractDeps scriptContent;
      bashOptions = extractOptions scriptContent;
      packageName = builtins.replaceStrings [ ".sh" ] [ "" ] name;
    in
    pkgs.writeShellApplication {
        inherit name;
        text = scriptContent;
        runtimeInputs = deps;
        inherit bashOptions;
	extraShellCheckFlags = [ "--severity=error" ];
      };

  readScriptsAndMakePackages = scriptsDir:
    let
      directoryContents = builtins.readDir scriptsDir;
      scriptFiles = builtins.filter
        (name: let type = builtins.getAttr name directoryContents; in type == "regular" && builtins.match ".*\\.sh$" name != null)
        (builtins.attrNames directoryContents);
      makePackages = name: makeScriptPackage {
        name = name;
        scriptContent = readScript "${scriptsDir}/${name}";
      };
    in
    map makePackages scriptFiles;
in
  readScriptsAndMakePackages scriptsDirPath
