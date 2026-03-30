{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nyxed-home-dev;
in
{
  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      prefix = "C-b";
      keyMode = "vi";
      mouse = true;
      terminal = "tmux-256color";
      historyLimit = 50000;
      escapeTime = 0;
      baseIndex = 1;

      plugins = with pkgs.tmuxPlugins; [
        sensible
        yank
        resurrect
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '15'
          '';
        }
      ];

      extraConfig = ''
        # true color support
        set -as terminal-features ",ghostty:RGB"
        set -as terminal-features ",xterm-256color:RGB"

        # OSC 52 clipboard passthrough (critical for SSH)
        set -g set-clipboard on

        # pane navigation (Alt+hjkl, no prefix)
        bind -n M-h select-pane -L
        bind -n M-j select-pane -D
        bind -n M-k select-pane -U
        bind -n M-l select-pane -R

        # intuitive splits in current directory
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"

        # resize panes (prefix + Alt+hjkl)
        bind M-h resize-pane -L 5
        bind M-j resize-pane -D 5
        bind M-k resize-pane -U 5
        bind M-l resize-pane -R 5

        # rename window
        bind r command-prompt "rename-window '%%'"

        # gruvbox status bar
        set -g status-style "bg=#3c3836,fg=#ebdbb2"
        set -g status-left "#[bg=#b8bb26,fg=#3c3836,bold] #S #[default] "
        set -g status-right "#[fg=#a89984]%H:%M "
        set -g window-status-format "#[fg=#a89984] #I:#W "
        set -g window-status-current-format "#[bg=#504945,fg=#fabd2f,bold] #I:#W "
        set -g pane-border-style "fg=#504945"
        set -g pane-active-border-style "fg=#b8bb26"
        set -g status-left-length 30
      '';
    };
  };
}
