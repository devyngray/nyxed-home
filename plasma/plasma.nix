{
  lib,
  config,
  ...
}:
let
  cfg = config.nyxed-home-plasma;
in
{
  config = lib.mkIf cfg.enable {
    programs.plasma = {
      enable = true;
      overrideConfig = true;

      workspace = {
        lookAndFeel = "org.kde.breezedark.desktop";
      };

      input = {
        keyboard = {
          options = [ "caps:escape" ];
        };

        # TODO: take touchpad name, productID, and vendorID as an option
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
          name = "Launch Ghostty";
          key = "Alt+Return";
          command = "ghostty";
        };
        launch-firefox = {
          name = "Launch Firefox";
          key = "Alt+B";
          command = "firefox";
        };
      };

      shortcuts = {
        kwin = {
          "Window Close" = "Alt+Q";
        };
      };

      session = {
        general.askForConfirmationOnLogout = false;
        sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
      };
    };
  };
}
