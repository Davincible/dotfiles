{ config, configLib, ... }:

{
  environment.systemPackages = (configLib.scriptsDirPath (toString ../scripts));
}
