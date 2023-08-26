{
  lib,
  config,
  ...
}: let
  cfg = config.environment.customIcons;
  inherit (lib) mkEnableOption mkIf mkMerge mkOption types;
in {
  options.environment.customIcons = {
    enable = mkEnableOption "environment.customIcons";
    icons = mkOption {
      type = types.listOf (types.submodule {
        options = {
          path = mkOption {
            type = types.path;
          };
          icon = mkOption {
            type = types.path;
          };
        };
      });
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      system.activationScripts.postActivation.text =
        ''
          echo -e "\033[1;36mActivating customIcons\033[0m"
        ''
        + (
          builtins.concatStringsSep "\n\n" (
            builtins.map
            (
              iconCfg: ''
                osascript <<EOF >/dev/null
                  use framework "Cocoa"

                  set iconPath to "${iconCfg.icon}"
                  set destPath to "${iconCfg.path}"

                  set imageData to (current application's NSImage's alloc()'s initWithContentsOfFile:iconPath)
                  (current application's NSWorkspace's sharedWorkspace()'s setIcon:imageData forFile:destPath options:2)
                EOF
              ''
            )
            cfg.icons
          )
        );
    })
  ];
}
