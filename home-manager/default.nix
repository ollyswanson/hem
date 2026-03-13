{
  lib,
  config,
  hemLib,
  ...
}:

let
  cfg = config.hem;

  modules = hemLib.extendModules (name: {
    extraOptions = {
      hem.${name}.enable = lib.mkEnableOption "enable ${name} configuration";
    };

    configExtension = config: (lib.mkIf cfg.${name}.enable config);
  }) (hemLib.filesIn ./modules);
in
{
  imports = modules;
}
