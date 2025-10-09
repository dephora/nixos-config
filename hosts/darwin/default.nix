{ config, pkgs, ... }:
# https://github.com/dustinlyons/nixos-config/issues/144#issuecomment-2708041683

let user = "bit"; in

{
  imports = [
    ../../modules/darwin/home-manager.nix
    ../../modules/shared
  ];

  #services.nix-daemon.enable = true;

  nix = {
    enable = false; # if you're using something like Determinate Nix, you don't need or want nix-darwin to manage the nix daemon for you
    package = pkgs.nix;
    settings = {
      trusted-users = [ "@admin" "${user}" ];
      substituters = [ "https://nix-community.cachix.org" "https://cache.nixos.org" ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };

    gc = {
      #user = "root";
      #automatic = true;
      automatic = false;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 30d";
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  system.checks.verifyNixPath = false;

  environment.systemPackages = with pkgs; [
    emacs-unstable
  ] ++ (import ../../modules/shared/packages.nix { inherit pkgs; });

  launchd.user.agents.emacs.path = [ config.environment.systemPath ];
  launchd.user.agents.emacs.serviceConfig = {
    KeepAlive = true;
    ProgramArguments = [
      "/bin/sh"
      "-c"
      "/bin/wait4path ${pkgs.emacs}/bin/emacs && exec ${pkgs.emacs}/bin/emacs --fg-daemon"
    ];
    StandardErrorPath = "/tmp/emacs.err.log";
    StandardOutPath = "/tmp/emacs.out.log";
  };

  system = {
    stateVersion = 4;

    defaults = {
      NSGlobalDomain = {
        #AppleFontSmoothing = null;                    # Sets the level of font smoothing (sub-pixel font rendering). Type: null or one of 0, 1, 2. Default: null.
        AppleICUForce24HourTime = true;               # Whether to use 24-hour or 12-hour time. The default is based on region settings.
        AppleInterfaceStyle = "Dark";                 # Set to ‘Dark’ to enable dark mode, or leave unset for normal mode.
        #AppleKeyboardUIMode = 3;                      # Configures the keyboard control behavior. Mode 3 enables full keyboard control. Type: null or value 3 (singular enum). Default: null
        AppleMeasurementUnits = "Inches";             # Whether to use centimeters (metric) or inches (US, UK) as the measurement unit. The default is based on region settings.
        AppleMetricUnits = 0;                         # Whether to use the metric system. The default is based on region settings.
        ApplePressAndHoldEnabled = false;             # Whether to enable the press-and-hold feature. The default is true.
        AppleScrollerPagingBehavior = true;           # Jump to the spot that’s clicked on the scroll bar. The default is false.
        AppleShowAllExtensions = true;                # Whether to show all file extensions in Finder. The default is false.
        AppleShowAllFiles = true;                     # Whether to always show hidden files. The default is false.
        AppleShowScrollBars = "Automatic";            # When to show the scrollbars. Options are ‘WhenScrolling’, ‘Automatic’ and ‘Always’.
        AppleSpacesSwitchOnActivate = false;          # Whether or not to switch to a workspace that has a window of the application open, that is switched to. The default is true.
        AppleTemperatureUnit = "Celsius";             # Whether to use Celsius or Fahrenheit. The default is based on region settings.
        AppleWindowTabbingMode = "fullscreen";        # Sets the window tabbing when opening a new document: ‘manual’, ‘always’, or ‘fullscreen’. The default is ‘fullscreen’.
        InitialKeyRepeat = 15;                        # This sets how long you must hold down the key before it starts repeating. Values: 120, 94, 68, 35, 25, 15
        KeyRepeat = 2;                                # This sets how fast it repeats once it starts. Values: 120, 90, 60, 30, 12, 6, 2
        NSAutomaticCapitalizationEnabled = false;     # Whether to enable automatic capitalization. The default is true.
        NSAutomaticWindowAnimationsEnabled = false;   # Whether to animate opening and closing of windows and popovers. The default is true.
        NSDisableAutomaticTermination = true;         # Whether to disable the automatic termination of inactive apps.
        NSDocumentSaveNewDocumentsToCloud = true;     # Whether to save new documents to iCloud by default. The default is true.
        NSNavPanelExpandedStateForSaveMode = true;    # Whether to use expanded save panel by default. The default is false.
        NSNavPanelExpandedStateForSaveMode2 = true;   # Whether to use expanded save panel by default. The default is false.
        NSScrollAnimationEnabled = true;              # Whether to enable smooth scrolling. The default is true.
        NSUseAnimatedFocusRing = true;                # Whether to enable the focus ring animation. The default is true.
        NSWindowResizeTime = 0.2;                     # Sets the speed speed of window resizing. The default is given in the example. The default is 0.2.
        NSWindowShouldDragOnGesture = false;          # Whether to enable moving window by holding anywhere on it like on Linux. The default is false.
        _HIHideMenuBar = false;                       # Whether to autohide the menu bar. The default is false.

        "com.apple.keyboard.fnState" = null;          # Use F1, F2, etc. keys as standard function keys.
        "com.apple.mouse.tapBehavior" = 1;            # Configures the trackpad tap behavior. Mode 1 enables tap to click.
        "com.apple.sound.beep.feedback" = 0;          # Make a feedback sound when the system volume changed. This setting accepts the integers 0 or 1. Defaults to 1.
        "com.apple.sound.beep.volume" = 0.0;          # Sets the beep/alert volume level from 0.000 (muted) to 1.000 (100% volume).
        "com.apple.springing.delay" = null;           # Set the spring loading delay for directories. The default is 1.0.
        "com.apple.springing.enabled" = null;         # Whether to enable spring loading (expose) for directories.
        "com.apple.swipescrolldirection" = false;     # Whether to enable “Natural” scrolling direction. The default is true.
      };

      SoftwareUpdate = {
        AutomaticallyInstallMacOSUpdates = false;     # Automatically install Mac OS software updates. Defaults to false.
      };

      WindowManager = {
        AppWindowGroupingBehavior = true;             # Grouping strategy when showing windows from an application. false means “One at a time” true means “All at once”
        AutoHide = false;                             # Auto hide stage strip showing recent apps. Default is false.
        EnableStandardClickToShowDesktop = false;     # Click wallpaper to reveal desktop Clicking your wallpaper will move all windows out of the way to allow access to your desktop items and widgets.
        EnableTiledWindowMargins = true;              # Enable window margins when tiling windows. The default is true.
        EnableTilingByEdgeDrag = true;                # Enable dragging windows to screen edges to tile them. The default is true.
        EnableTilingOptionAccelerator = true;         # Enable holding alt to tile windows. The default is true.
        EnableTopTilingByEdgeDrag = true;             # Enable dragging windows to the menu bar to fill the screen. The default is true.
        GloballyEnabled = false;                      # Enable Stage Manager Stage Manager arranges your recent windows into a single strip for reduced clutter and quick access. Default is false.
        HideDesktop = null;                           # Hide items in Stage Manager.
        StageManagerHideWidgets = null;               # Hide widgets in Stage Manager.
        StandardHideDesktopIcons = true;              # Hide items on desktop.
        StandardHideWidgets = true;                   # Hide widgets on desktop.
      };

      dock = {
        autohide = false;
        show-recents = false;
        launchanim = false;                           # Animate opening applications from the Dock
        orientation = "bottom";
        tilesize = 24;                                # Min 16
        largesize = 128;                              # Max 128
        magnification = true;                         # Magnify icon on hover
        expose-animation-duration = 0.0;
        mineffect = null;                             # Set the minimize/maximize window effect. The default is genie.

      
      };

      finder = {
        _FXShowPosixPathInTitle = true;               # Whether to show the full POSIX filepath in the window title. The default is false.
        _FXSortFoldersFirst = true;                   # Keep folders on top when sorting by name. The default is false.
        CreateDesktop = false;                        # Whether to show icons on the desktop or not. The default is true.
        NewWindowTarget = "Home";                     # Change the default folder shown in Finder windows. “Other” corresponds to the value of NewWindowTargetPath. The default is unset (“Recents”).
        QuitMenuItem = true;                          # Whether to allow quitting of the Finder. The default is false.
        ShowExternalHardDrivesOnDesktop = false; 
        ShowPathbar = true;                           # Show path breadcrumbs in finder windows. The default is false.
        ShowStatusBar = true;                         # Show status bar at bottom of finder windows with item/disk space stats. The default is false.
        
      };

      loginwindow = {
        GuestEnabled = false;                         # Allow users to login to the machine as guests using the Guest account. Default is true.
      };

      screencapture = {
        location = "~/Downloads";
        type = "heic";
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };
  };
}
