{ pkgs, nyxed, ... }:
{
  # install git
  home.packages = [
    pkgs.git
  ];

  # enable jj
  programs.jujutsu = {
    enable = true;
  };

  # configure jj
  programs.jujutsu.settings = {
    user = {
      name = nyxed.vcsName;
      email = nyxed.vcsEmail;
    };

    ui = {
      default-command = "shortlog";
      diff-formatter = "git";
    };

    revset-aliases = {
      "closest_bookmark(to)" = "heads(::to & bookmarks())";
      "unmerged(from)" = "::from ~ ::trunk()";
    };

    aliases = {
      shortlog = [
        "log"
        "-n"
        "20"
      ];
      a = [
        "log"
        "-r"
        "all()"
      ];
      b = [ "bookmark" ];
    };

    code.fsmonitor = "watchman";
  };
}
