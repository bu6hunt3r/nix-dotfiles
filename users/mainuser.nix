{ config, pkgs, ... }:

let
  inherit (import ../variables.nix) nixosConfigDir mainUser;
in
{
  nixpkgs.config = import ../pkgs/nixpkgs-config.nix;

  programs.go.enable = true;
  programs.direnv.enable = true;

  programs.zsh.profileExtra = ''
    source ${nixosConfigDir}/users/configs/profile
  '';

  manual.manpages.enable = false;

  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.enableAutosuggestions = true;
  programs.zsh.initExtra = ''
    source ${nixosConfigDir}/users/configs/zshrc
  '';

  programs.tmux = {
    enable = true;
    clock24 = true;
    newSession = false;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.fingers;
        extraConfig = ''
        # Prevent tmux from renaming the tab when processes change
        set-option -g allow-rename off

        # Set base to 1
        set -g base-index 1
        # Start index of window/pane with 1, because we're humans, not computers
        setw -g pane-base-index 1

        # Enable UTF-8 support in status bar
        set -g status on

        # Increase scrollback lines
        set -g history-limit 30000

        set-option -g renumber-windows on

        # see: toggle on/off all keybindings · Issue #237 · tmux/tmux - https://github.com/tmux/tmux/issues/237
        # Also, change some visual styles when window keys are off
        bind -T root F12  \
        set prefix None \;\
        set key-table off \;\
        #set status-style "fg=$color_status_text,bg=$color_window_off_status_bg" \;\
        #set window-status-current-format "#[fg=$color_window_off_status_bg,bg=$color_window_off_status_current_bg]$separator_powerline_right#[default] #I:#W# #[fg=$color_window_off_status_current_bg,bg=$color_window_off_status_bg]$separator_powerline_right#[default]" \;\
        #set window-status-current-style "fg=$color_dark,bold,bg=$color_window_off_status_current_bg" \;\
        if -F '#{pane_in_mode}' 'send-keys -X cancel' \;\
        refresh-client -S \;\

        bind -T off F12 \
	set -u prefix \;\
	set -u key-table \;\
	set -u status-style \;\
	set -u window-status-current-style \;\
  	set -u window-status-current-format \;\
  	refresh-client -S

        unbind C-b
	set -g prefix C-a
	bind C-a send-prefix

	bind-key p last-window

	bind h select-pane -L
	bind j select-pane -D
	bind k select-pane -U
	bind l select-pane -R

	set-window-option -g mode-keys vi

	bind-key Escape copy-mode			# enter copy mode; default [
	bind-key -T copy-mode-vi 'v' send -X begin-selection
	bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel
	bind-key -T copy-mode-vi 'V' send-keys -X select-line
	bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
	bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "xclip -selection clipboard"

	bind-key y split-window -h
	bind-key x split-window -v

	bind-key g command-prompt -p "join pane from:"  "join-pane -s ':%%'"
	bind-key s command-prompt -p "send pane to:"  "join-pane -t ':%%'"

	bind-key Left resize-pane -L 5
	bind-key Right resize-pane -R 5
	bind-key Up resize-pane -U 5
	bind-key Down resize-pane -D 5
	bind-key = select-layout even-vertical
	bind-key | select-layout even-horizontal

	# ditched m which had select-pane -m
	# this place a stronger visual cue on the selected pane
	# add bind for mouse support toggle needs tmux 2.2
	bind-key m set -g mouse

	bind-key - set status

	# The panes
	set-window-option -g pane-active-border-style 'fg=red'
	set-window-option -g pane-border-style 'fg=#121212'

	# The statusbar
	set -g status-interval 30
	set -g status-position bottom
	set -g status-bg colour235
	set -g status-fg colour255

	#set -g status-justify centre
	set -g status-justify left
        set -g @fingers-key F
	set -g @fingers-pattern-0 '0x([0-9a-f]+)'
	set -g @fingers-copy-command 'xclip -selection clipboard'
        run-shell ${pkgs.tmuxPlugins.fingers}/share/tmux-plugins/fingers/tmux-fingers.tmux
        '';
      }
    ];
  };

  xdg.userDirs = {
    download = "\$HOME/downloads";
    desktop = "\$HOME";
    documents = "\$HOME/dox";
    music = "\$HOME/music";
    pictures = "\$HOME/pix";
    templates = "\$HOME";
    videos = "\$HOME/videos";
  };

  services.polybar = {
    enable=true;
    package=pkgs.polybar.override {
      i3Support=true;
      alsaSupport=true;
      iwSupport=true;
    };
    config = ./configs/polybarconfig;
    script="";
  };
  
  services.screen-locker = {
    enable = true;
    lockCmd = ''
      ${pkgs.i3lock}/bin/i3lock -n -c 000000
    '';
  };

  xdg.configFile = {
    "compton/compton.conf".source= ./configs/compton.conf;
    "css-collection/markdown.css".source= ./configs/cssmarkdown;
    "deluge/blocklist.conf".source= ./configs/delugeblocklist;
    "deluge/plugins/Pieces-0.5-py2.7.egg".source= ./configs/delugepieces.egg;
    "deluge/plugins/SequentialDownload-1.0-py2.7.egg".source= ./configs/delugesequential.egg;
    "dunst/dunstrc".source= ./configs/dunstrc;
    "homepage/index.html".text= builtins.replaceStrings ["mainUser"] ["${mainUser}"] (builtins.readFile ./configs/homepage.html);
    "homepage/style.css".text= builtins.replaceStrings ["mainUser"] ["${mainUser}"] (builtins.readFile ./configs/homepage.css);
    "i3/config".source = ./configs/i3config;
    "i3/darkwing.jpg".source = ./configs/darkwing.jpg;
    "i3/blured_darkwing.png".source = ./configs/blured_darkwing.png;
    "polybar/polybar.sh".source = ./configs/polybar.sh;
    "i3blocks/config".source = ./configs/i3blocksconfig;
    "kitty/kitty.conf".source = ./configs/kitty.conf;
    "mutt/mutt-wizard.muttrc".source = (builtins.toPath "${pkgs.mutt-wizard}/share/mutt-wizard.muttrc");
    "mpd/mpd.conf".source = ./configs/mpd.conf;
    "mpv/mpv.conf".source = ./configs/mpv.conf;
    "mpv/input.conf".source = ./configs/mpvinput.conf;
    #"mpv/scripts/webm.lua".source = builtins.fetchurl "https://raw.githubusercontent.com/ElegantMonkey/mpv-webm/master/build/webm.lua";
    "ncmpcpp/bindings".source = ./configs/ncmpcppbindings;
    "ncmpcpp/config".source = ./configs/ncmpcppconfig;
    "newsboat/config".source = ./configs/newsboatconfig;
    "nixpkgs/config.nix".source = ../pkgs/nixpkgs-config.nix;
    "qutebrowser/config.py".source= ./configs/qutebrowser.py;
    "qutebrowser/darksheet.css".source= ./configs/darksheet.css;
    "qutebrowser/jblock".source = builtins.fetchTarball "https://gitlab.com/jgkamat/jblock/-/archive/master/jblock-master.tar.gz";
    "qutebrowser/dracula".source = builtins.fetchGit {
      url = "https://github.com/dracula/qutebrowser.git";
      rev = "ba5bd6589c4bb8ab35aaaaf7111906732f9764ef";
    };
    "ranger/commands.py".source = ./configs/rangercommands.py;
    "ranger/rc.conf".source = ./configs/rangerrc.conf;
    "ranger/rifle.conf".source = ./configs/rangerrifle.conf;
    "ranger/scope.sh".source = ./configs/rangerscope.sh;
    "rofi/config.rasi".source = ./configs/config.rasi;
    "transliteration/transliteration.html".source = ./configs/transliteration.html;
    "zathura/zathurarc".source = ./configs/zathurarc;
    "wal/templates/colorskitty.conf".source = ./share/templates/pywalkittytemplate;
    "wal/templates/colorspython.py".source = ./share/templates/pywalpythontemplate.py;
    "wal/templates/zathuracolors".source = ./share/templates/pywalzathuratemplate;
    "aliasrc".source = ./configs/aliasrc;
    "emoji".source = ./configs/emoji;
    "fontawesome".source = ./configs/fontawesome;
    "inputrc".source = ./configs/inputrc;
    "mimeapps.list".source = ./configs/mimeapps.list;
  };

  xdg.dataFile = {
    "applications".source = ./share/applications;
    "qutebrowser/greasemonkey/4chanx.user.js".source = builtins.fetchurl "https://www.4chan-x.net/builds/4chan-X.user.js";
    "qutebrowser/greasemonkey/ffz.user.js".source = builtins.fetchurl "https://cdn.frankerfacez.com/static/ffz_injector.user.js";
    "qutebrowser/greasemonkey/4chancss.user.js".source = ./share/userscripts/4chancssuserscript;
    "qutebrowser/userscripts/changetogoogle".source = ./share/userscripts/changetogoogle;
    "qutebrowser/userscripts/configwithhostblocking".source = ./share/userscripts/configwithhostblocking;
    "qutebrowser/userscripts/configwithoutjblock".source = ./share/userscripts/configwithoutjblock;
    "qutebrowser/userscripts/follow4chan".source = ./share/userscripts/follow4chan;
    "qutebrowser/userscripts/updatecolors".source = ./share/userscripts/updatecolors;
  };

  home.file = {
    ".local/bin".source = ./bin;
    "dox/latex/templates/article.tex".source = ./share/templates/article.tex;
    "dox/latex/templates/presentation.tex".source = ./share/templates/presentation.tex;
    #".tmux.conf".source = ./configs/tmux.conf;
    ".xinitrc".source = ./configs/xinitrc;
    ".calcurse/conf".source= ./configs/calcurseconf;
    ".zsh_plugins".source= ./configs/zsh_plugins;
    ".zbindkeys".source= ./configs/zbindkeys;
  };



  home.packages = with pkgs; [
    ####vim
    vimCustom
    ####sysutil
    htop
    libnotify
    acpi
    inotify-tools
    xdg_utils
    ####dev
    emacs
    cabal-install
    cabal2nix
    haskellPackages.haskell-language-server
    ghc
    git
    ksshaskpass
    gawk
    jq
    python3
    go
    gcc
    ####audio
    pavucontrol
    pulsemixer
    audacity
    mpd
    mpdris2
    mpc_cli
    easytag
    spotify
    spotifyd
    spotify-tui
    ####video
    mpv
    kdenlive
    ####img
    sxiv
    imagemagick
    feh
    krita
    gmic_krita_qt
    kolourpaint
    ueberzug
    ####documents
    zathura
    zathura-poppler-only
    libreoffice
    pandoc
    texlive.combined.scheme-full
    ####shell
    antibody
    fzf
    grc
    libqalculate
    kitty
    screen
    tmux
    ####utils
    binutils
    bc
    emacs
    git-crypt
    gnumake
    cmake
    pkg-config
    killall
    pass
    ####files
    ranger
    syncthing
    jmtpfs
    unrar
    zip
    unzip
    fzf
    ffmpeg
    appimage-run
    ark
    ####Ranger utils
    atool
    libarchive
    mupdf
    ffmpegthumbnailer
    exiftool
    file
    poppler_utils
    ####web
    qutebrowser
    youtube-dl
    wget
    weechat
    keepassxc
    ####Torrenting Linux ISOs
    deluge
    ####neomutt extras
    mutt-wizard
    neomutt
    isync
    msmtp
    pass
    gnupg
    notmuch
    lynx
    ####gaymen
    nudoku
    openjdk
    ####misc
    #diary
    tty-clock
    calcurse
    newsboat
    pywal
    nix-prefetch-scripts
    nix-prefetch-github
    ##i3
    i3lock-color
    papirus-icon-theme
    #bemenu
    adapta-gtk-theme
    gnome3.adwaita-icon-theme
    xorg.xcursorthemes
    lxappearance
    rofi
    #i3blocks
    #personalblocks
    i3lock-fancy
    dunst
    maim
    redshift
    xidlehook
    xdotool
    xorg.xdpyinfo
    xclip
    arandr
    alttab
    compton-tryone
    numlockx
    ##kde gui
    plasma-integration
    libsForQt5.kio
    breeze-qt5
    breeze-icons
    #kdeApplications.kio-extras
    ffmpegthumbs
    #kdeApplications.kdegraphics-thumbnailers
    ##pwn
    pwndbg
    vagrant
    virt-manager
  ];
}
