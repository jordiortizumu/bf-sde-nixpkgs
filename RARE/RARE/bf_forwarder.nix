{ bf-sde, fetchgit, sal_modules, python2, makeWrapper }:

let
  repo = import ./repo.nix { inherit fetchgit; };
in python2.pkgs.buildPythonApplication rec {
  inherit (repo) version src;
  pname = "bf_forwarder";

  propagatedBuildInputs = [
    bf-sde.pkgs.bf-drivers sal_modules
    (python2.withPackages (ps: with ps; [ ]))
  ];
  buildInputs = [ makeWrapper ];

  preConfigure = ''
    cd bfrt_python
  '';

  postInstall = ''
    for p in bf_forwarder.py switchdctl.py; do
      wrapProgram "$out/bin/$p" --set SDE ${bf-sde} --set SDE_INSTALL ${bf-sde} --set PYTHONPATH "${bf-sde.pkgs.bf-drivers}/lib/python2.7/site-packages/tofino"
    done
  '';
}
