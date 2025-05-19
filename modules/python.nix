{ unstable, ... }:

{
  environment.systemPackages = [
    unstable.python313
    unstable.ruff
  ];
}


