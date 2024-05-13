{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "bhoudebert";
  home.homeDirectory = "/home/bhoudebert";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
 home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    
    # editors
    vim
    # emacs -- commented as potentially installed from sources 

    # fonts
    powerline-fonts

    # For copilot
    siege
    nodejs_22
    
    # Misc tools
    translate-shell
    gh
    ipfs
    pandoc
    ripgrep
    ncdu

    # Better ls and in Rust!
    eza
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/bhoudebert/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "vim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Enable git with all ready to use aliases
  programs.git = {
    enable = true;
    aliases = {
      st = "status";
      stp = "status --porcelain";
      ci = "commit";
      br = "branch";
      brd = "branch -d";
      co = "checkout";
      cob = "checkout -b";
      rz = "reset --hard HEAD";
      pullr = "pull --rebase";
      unstage = "reset HEAD";
      aa = "add -A .";
      cm = "commit -m";
      aacm = "!git add -A . && git commit -m";
      aacmpu = "!sh -c \"git add -A . && git commit -m '$1' && git pu\"";
      main = "!git checkout main && git pull origin";
      lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
      lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
      lpush = "!git --no-pager log origin/$(git currentbranch)..HEAD --oneline";
      lpull = "!git --no-pager log HEAD..origin/$(git currentbranch) --oneline";
      whatsnew = "!git diff origin/$(git currentbranch)...HEAD";
      whatscoming = "!git diff HEAD...origin/$(git currentbranch)";
      currentbranch = "!git branch | grep \"^\\*\" | cut -d \" \" -f 2";
      po = "push origin";
      pu = "!git push origin `git branch --show-current`";
      plo = "pull origin";
      plom = "pull origin main";
      f = "!git ls-files | grep -i";
    };
    userEmail = "bhoudebert@gmail.com";
    userName = "bhoudebert";
    extraConfig = {
      core = { autocrlf = "input"; };
      init = { defaultBranch = "main"; };
    };
  };

  # Setup zsh with plugins.
  # For WSL only: https://learn.microsoft.com/en-us/windows/terminal/tutorials/custom-prompt-setup#set-cascadia-code-pl-as-fontface-in-settings
  # Install Cascadia Code PL https://github.com/microsoft/cascadia-code
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ 
        "aws"
        "catimg"
        "colored-man-pages"
        "colorize"
        "command-not-found"
        "copybuffer"
        "copyfile"
        "copypath"
        "dircycle"
        "docker-compose"
        "docker"
        "emoji-clock"
        "encode64"
        "genpass"
        "gh"
        "git"
        "git-prompt"
        "history"
        "ipfs"
        "isodate"
        "jump"
        "ripgrep"
        "rsync"
        "rust"
        "sudo"
       ];
      theme = "agnoster";
    };
    shellAliases = {
      ll = "eza -al";
    };
    # The extra part loading nix.sh is only necessary on non NixOS env, might be adapt for your own user
    initExtra = ''
      . /home/bhoudebert/.nix-profile/etc/profile.d/nix.sh
      eval "$(direnv hook zsh)"
    '';
  };

}
