{ unstable, unstableWithCuda, ... }:

{
  programs.bash.shellAliases = {
    yt-mp4 = "yt-dlp -f mp4 -o '%(title)s.%(ext)s'";
    yt-mp3 = "yt-dlp -x --audio-format mp3 -o '%(title)s.%(ext)s'";
    yt-wav = "yt-dlp -x --audio-format wav -o '%(title)s.%(ext)s'";
  };
  
  environment.systemPackages = [
      unstable.yt-dlp
      unstableWithCuda.openai-whisper
      # unstableWithCuda.whisperx # actual impossible to build package, need like 300GB of ram and 4 A100s to build this apparently
      (unstable.callPackage ./packages/japanese_vocab/package.nix { })
      (import ./scripts/deepl_jp.nix { inherit unstable; })
    ];
}


