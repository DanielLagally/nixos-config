{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper
}:

buildGoModule rec {
  pname = "japanese_vocab";
  version = "commit 0b3e73c";

  src = fetchFromGitHub {
    owner = "BrianWill";
    repo = "japanese_vocab";
    rev = "0b3e73c26582a2463f0f2756a0a28b66962a1daa";
    hash = "sha256-m/oDygZlRl7Vm6iBJOJSXXztieLr9qbAGgUwXnpup7s=";
  };
  vendorHash = "sha256-1c2Zk3KHuew3kgy7vQqIXUacK8JhM8IwIOwgydtC6P8=";

  sourceRoot = "source/app";
  # subPackages = [ "source/app" ];

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
      mv $out/bin/japanese $out/bin/japanese-unwrapped
      mkdir -p $out/share/japanese_vocab
      cp -r ${src}/* $out/share/japanese_vocab

      makeWrapper $out/bin/japanese-unwrapped $out/bin/japanese \
        --run "if [ ! -d \"\$HOME/.local/share/japanese_vocab\" ] || [ -z \"\$(ls -A \"\$HOME/.local/share/japanese_vocab\" 2>/dev/null)\" ]; then
             mkdir -p \"\$HOME/.local/share/japanese_vocab\"
             cp -r $out/share/japanese_vocab/* \"\$HOME/.local/share/japanese_vocab/\"
             chmod -R u+rwX \"\$HOME/.local/share/japanese_vocab\" 
           fi
           cd \$HOME/.local/share/japanese_vocab/app"
      '';

  meta = with lib; {
    description = "A program for learning Japanese through input by listening to stories and drilling their vocabulary.";
    mainProgram = "japanese";
    homepage = "https://github.com/BrianWill/japanese_vocab";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
