{ config, lib, pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
    ./hardware-configuration.nix
  ];

  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="input", ATTRS{name}=="AT Translated Set 2 keyboard", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates = "monthly";
    options = "--delete-older-than 60d";
  };

  hardware.graphics.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "computr";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb.layout = "fr";

  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.me = {
    isNormalUser = true;
    description = "me";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  programs.firefox.enable = true;
  programs.zsh.enable = true;

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  virtualisation.docker.enable = true;
  programs.steam.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    neovim xclip
    zoxide btop wget tree file
    zsh
    zip unzip
    gcc gnumake cargo python3
    jdk25_headless
    libreoffice
    librewolf
    gimp
    kdePackages.kdenlive
    vscodium qbittorrent
    telegram-desktop signal-desktop
    vlc obs-studio
    protonvpn-gui
    todo yt-dlp scdl ffmpeg xdotool vmpk
    obsidian
    burpsuite ffuf wireshark wpscan sqlmap nmap
    pandoc
    keepass
  ];

  home-manager.backupFileExtension = "backup";

  home-manager.users.me = { config, pkgs, ... }: {
    home.stateVersion = "26.05";

    programs = {
      zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        oh-my-zsh = {
          enable = true;
          theme = "robbyrussell";
          plugins = [ "git" "npm" "history" "rust" ];
        };
      };

      neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        extraConfig = ''
          set number relativenumber
          set autoindent
          set tabstop=4
          set shiftwidth=4
          set expandtab
          set list
          set clipboard+=unnamedplus
          if &diff
            colorscheme blue
          endif
        '';
      };

      zoxide.enable = true;
      zoxide.enableZshIntegration = true;
    };
  };

  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  system.stateVersion = "26.05";
}
