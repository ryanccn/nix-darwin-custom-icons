{ lib, config, ... }:
let
  cfg = config.environment.customIcons;
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types
    ;
in
{
  options.environment.customIcons = {
    enable = mkEnableOption "environment.customIcons";
    clearCacheOnActivation = mkEnableOption "environment.customIcons.clearCacheOnActivation";

    icons = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            path = mkOption { type = types.path; };
            icon = mkOption { type = types.path; };
          };
        }
      );
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      system.activationScripts.extraActivation.text = ''
        echo -e "applying custom icons..."

        ${
          (builtins.concatStringsSep "\n\n" (
            builtins.map (iconCfg: ''
              osascript <<EOF >/dev/null
                use framework "Cocoa"

                set iconPath to "${iconCfg.icon}"
                set destPath to "${iconCfg.path}"

                set imageData to (current application's NSImage's alloc()'s initWithContentsOfFile:iconPath)
                (current application's NSWorkspace's sharedWorkspace()'s setIcon:imageData forFile:destPath options:2)
              EOF
            '') cfg.icons
          ))
        }

        ${lib.optionalString cfg.clearCacheOnActivation ''
          sudo rm -rf /Library/Caches/com.apple.iconservices.store
          sudo find /private/var/folders/ -name com.apple.dock.iconcache -or -name com.apple.iconservices -or -name com.apple.iconservicesagent -exec rm -rf {} \; || true
          killall Dock
        ''}'';
    })
  ];
}
