{ config, lib, pkgs, ... }: {

  # OPTIONS
  options = {
    modules.gnome = {
      enable = lib.mkEnableOption "";
      autoLogin = lib.mkEnableOption "";
      disableCoreApps = lib.mkEnableOption "";
      disablePowerManager = lib.mkEnableOption "";
    };
  };
  
  # CONFIG
  config = lib.mkMerge [
    # Enable GNOME, GDM, XDG desktop portal
    (lib.mkIf config.modules.gnome.enable {
      services = {
        xserver = {
          enable = true;
          desktopManager.gnome.enable = true;
          displayManager.gdm.enable = true;
        };
        autoLogin = {
          enable = config.modules.gnome.autoLogin;
          user = "user";
        };
      };

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];
      };
    })

    # Disable GNOME apps
    (lib.mkIf config.modules.gnome.disableCoreApps {
      services = {
        gnome = {
          core-utilities.enable = false;
          gnome-initial-setup.enable = false;
        };
      };

      environment.gnome.excludePackages = (with pkgs; [
        gnome-tour
        gnome-shell-extensions
      ]);
    })

    # Disable power manager
    (lib.mkIf config.modules.gnome.disablePowerManager {
      services.upower.enable = lib.mkForce false;
    })
  ];

}
