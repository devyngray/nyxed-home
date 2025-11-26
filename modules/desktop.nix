{
  pkgs,
  lib,
  nyxed,
  ...
}:
{
  home.packages = lib.mkIf nyxed.desktop [
    pkgs.kdePackages.krohnkite
  ];

  programs.plasma = lib.mkIf nyxed.desktop {
    enable = true;
    overrideConfig = true;

    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
    };

    input = {
      keyboard = {
        options = [ "caps:escape" ];
      };

      touchpads = [
        {
          # framework laptop touchpad
          disableWhileTyping = true;
          enable = true;
          leftHanded = false;
          middleButtonEmulation = true;
          name = "PIXA3854:00 093A:0274 Touchpad";
          naturalScroll = true;
          pointerSpeed = 0;
          productId = "0274";
          tapToClick = true;
          vendorId = "093a";
        }
      ];
    };

    hotkeys.commands = {
      launch-ghostty = {
        name = "Launch ghostty";
        key = "Alt+Return";
        command = "ghostty";
      };
      launch-firefox = {
        name = "Launch ghostty";
        key = "Alt+B";
        command = "firefox";
      };
    };

    kwin = {
      effects = {
        desktopSwitching.animation = "off";
      };

      virtualDesktops = {
        number = 5;
        rows = 1;
      };
    };

    session = {
      general.askForConfirmationOnLogout = false;
      sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
    };

    shortcuts = {
      kwin = {
        "KrohnkiteMonocleLayout" = "Alt+M";

        "KrohnkiteFocusLeft" = "Alt+H";
        "KrohnkiteFocusUp" = "Alt+K";
        "KrohnkiteFocusDown" = "Alt+J";
        "KrohnkiteFocusRight" = "Alt+L";

        "KrohnkiteShiftLeft" = "Alt+Shift+H";
        "KrohnkiteShiftUp" = "Alt+Shift+K";
        "KrohnkiteShiftDown" = "Alt+Shift+J";
        "KrohnkiteShiftRight" = "Alt+Shift+L";

        "Switch to Desktop 1" = "Alt+1";
        "Switch to Desktop 2" = "Alt+2";
        "Switch to Desktop 3" = "Alt+3";
        "Switch to Desktop 4" = "Alt+4";
        "Switch to Desktop 5" = "Alt+5";

        "Window Close" = "Alt+Q";
      };
    };

    configFile = {
      kwinrc = {
        Plugins = {
          krohnkiteEnabled = true;
        };
      };
    };
  };
}
