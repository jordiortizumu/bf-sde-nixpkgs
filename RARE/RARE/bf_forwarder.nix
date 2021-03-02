{ bf-sde, fetchgit, sal_modules }:

let
  repo = import ./repo.nix { inherit fetchgit; };
  bf-drivers = bf-sde.pkgs.bf-drivers;
  python = bf-drivers.pythonModule;
in python.pkgs.buildPythonApplication rec {
  inherit (repo) version src;
  pname = "bf_forwarder";

  propagatedBuildInputs = [
    bf-drivers sal_modules
  ];

  preConfigure = ''
    cd bfrt_python
  '';
}
