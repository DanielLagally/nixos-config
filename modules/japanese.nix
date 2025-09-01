{ unstable, ... }:

{
  environment.systemPackages = [
      unstable.yt-dlp
      unstable.openai-whisper
    ];
}


