{ bf-sde, fetchFromGitHub, python2, makeWrapper }:

python2.pkgs.buildPythonApplication rec {
  pname = "packet-broker-configd";
  version = "0.1";

  src = import ./repo.nix { inherit fetchFromGitHub; };
  propagatedBuildInputs = [
    bf-sde
    (python2.withPackages (ps: with ps; [ jsonschema ipaddress ]))
  ];
  buildInputs = [ makeWrapper ];

  preConfigure = ''cd control-plane'';
  postInstall = ''
    wrapProgram "$out/bin/configd.py" --set PYTHONPATH "${bf-sde}/lib/python2.7/site-packages/tofino"
  '';

}
