{ pkgs, ... }:

{
  # ~/.local/bin (where `uv tool install` places executables) isn't on PATH by default on NixOS.
  environment.localBinInPath = true;

  # Bootstraps a self-updatable yt-dlp into ~/.local/bin via uv, without exposing uv itself
  # on $PATH (uv is only ever invoked here, via its Nix store path). Idempotent: `uv tool
  # install` without --force no-ops if yt-dlp is already installed, so this never clobbers
  # a copy you've since updated yourself with `yt-dlp -U`.
  system.activationScripts.installYtDlp = {
    deps = [ "users" ];
    text = ''
      ${pkgs.su}/bin/su daniel --shell ${pkgs.runtimeShell} --command \
        "${pkgs.uv}/bin/uv tool install yt-dlp" || true
    '';
  };

  programs.bash.shellAliases = {
    yt-mp4 = "yt-dlp -f mp4 -o '%(title)s.%(ext)s'";
    yt-mp3 = "yt-dlp -x --audio-format mp3 -o '%(title)s.%(ext)s'";
    yt-wav = "yt-dlp -x --audio-format wav -o '%(title)s.%(ext)s'";
  };
  
  programs.fish.shellAliases = {
    yt-mp4 = "yt-dlp -f mp4 -o '%(title)s.%(ext)s'";
    yt-mp3 = "yt-dlp -x --audio-format mp3 -o '%(title)s.%(ext)s'";
    yt-wav = "yt-dlp -x --audio-format wav -o '%(title)s.%(ext)s'";
  };
  
  environment.systemPackages = [
      pkgs.yt-dlp # pinned fallback if uv's install hasn't landed yet; shadowed on PATH by ~/.local/bin/yt-dlp once it has
      # unstableWithCuda.openai-whisper # fuck magma ain't nobody got time for that
      # pkgs.withCuda.whisperx # actual impossible to build package, need like 300GB of ram and 4 A100s to build this apparently
      pkgs.whisper-cpp-vulkan
      pkgs.python3Packages.manga-ocr
      pkgs.ffmpeg
      (pkgs.callPackage ./packages/japanese_vocab/package.nix { })
      (import ./scripts/deepl_jp.nix { unstable = pkgs; })
    ];

    i18n = {
      inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
          waylandFrontend = true;
          addons = [
            pkgs.fcitx5-mozc
            pkgs.fcitx5-gtk
            pkgs.qt6Packages.fcitx5-configtool
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


