{ bf-sde, fetchFromGitHub, python2, makeWrapper }:

python2.pkgs.buildPythonApplication rec {
  pname = "packet-broker-configd";
  version = "0.1";

  src = import ./repo.nix { inherit fetchFromGitHub; };
  propagatedBuildInputs = [
    bf-sde.pkgs.bf-drivers
    (python2.withPackages (ps: with ps; [ jsonschema ipaddress ]))
  ];
  buildInputs = [ makeWrapper ];

  ## The Python environments (the one above and the one from the
  ## propagated build inputs of bf-drivers) both contain the same
  ## version of the "six" package, causing a conflict when they are
  ## merged.
  catchConflicts = false;

  preConfigure = ''cd control-plane'';

  postInstall = ''
    mkdir -p $out/etc/packet-broker
    cp config.json schema.json $out/etc/packet-broker
    wrapProgram "$out/bin/configd.py" --set PYTHONPATH "${bf-sde.pkgs.bf-drivers}/lib/python2.7/site-packages/tofino"
  '';

}
