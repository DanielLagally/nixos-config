{ unstable, ... }:

{
  environment.systemPackages = [
    unstable.python312
    unstable.ruff
  ];
}


