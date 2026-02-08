{ config, pkgs, ... }:

{
  imports = [
      <home-manager/nixos>
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes"];

  nix.gc.automatic = true;
  nix.gc.dates = "monthly";
  nix.gc.options = "--delete-older-than 60d";

  hardware.graphics.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "computr";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "fr_FR.UTF-8";

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
  };

  users.users.me = {
    isNormalUser = true;
    description = "me";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  programs.firefox.enable = true;

  virtualisation.docker.enable = true;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    git
    neovim xclip
    zoxide
    btop
    wget
    tree
    file
    zsh
    zip unzip
    gcc
    gnumake
    cargo
    python3
    jdk
    neofetch
    libreoffice
    librewolf
    gimp
    kdePackages.kdenlive
    vscodium
    qbittorrent
    telegram-desktop
    vlc
    obs-studio
    protonvpn-gui
    openvpn
    element-desktop
    todo
    yt-dlp scdl
    ffmpeg
    nmap
    xdotool
    vmpk
    obsidian
    burpsuite ffuf
    wireshark
  ];

  programs.zsh.enable = true;

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  home-manager.backupFileExtension = "backup";

  home-manager.users.me = { pkgs, ... }: {
    home.stateVersion = "25.11";

    programs = {
      zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        oh-my-zsh = {
          enable = true;
          theme = "robbyrussell";
          plugins = [
            "git"
            "npm"
            "history"
            "rust"
          ];
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

  system.stateVersion = "25.11";
}
