{ unstable, unstableWithCuda, ... }:

{
  programs.bash.shellAliases = {
    yt-mp4 = "yt-dlp -f mp4 -o '%(title)s.%(ext)s'";
    yt-mp3 = "yt-dlp -x --audio-format mp3 -o '%(title)s.%(ext)s'";
    yt-wav = "yt-dlp -x --audio-format wav -o '%(title)s.%(ext)s'";
  };
  
  environment.systemPackages = [
      unstable.yt-dlp
      # unstableWithCuda.openai-whisper # fuck magma ain't nobody got time for that
      # unstableWithCuda.whisperx # actual impossible to build package, need like 300GB of ram and 4 A100s to build this apparently
      (unstable.callPackage ./packages/japanese_vocab/package.nix { })
      (import ./scripts/deepl_jp.nix { inherit unstable; })
    ];

    i18n = {
      inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
          waylandFrontend = true;
          addons = [
            unstable.fcitx5-mozc
            unstable.fcitx5-gtk
            unstable.qt6Packages.fcitx5-configtool
          ];
        };
      };
    };
    
    environment.variables = {
      GLFW_IM_MODULE = "fcitx";
      # GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS="@im=fcitx";
    };
}


