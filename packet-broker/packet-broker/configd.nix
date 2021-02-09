{ bf-sde, fetchFromGitHub, makeWrapper }:

let
  bf-drivers = bf-sde.pkgs.bf-drivers;
  python = bf-drivers.pythonModule;
in python.pkgs.buildPythonApplication rec {
  pname = "packet-broker-configd";
  version = "0.1";

  src = import ./repo.nix { inherit fetchFromGitHub; };
  propagatedBuildInputs = [
    bf-drivers
  ] ++ (with python.pkgs; [ jsonschema ipaddress ]);
  buildInputs = [ makeWrapper ];

  preConfigure = ''cd control-plane'';

  postInstall = ''
    mkdir -p $out/etc/packet-broker
    cp config.json schema.json $out/etc/packet-broker
    wrapProgram $out/bin/configd.py --set PYTHONPATH ${bf-drivers.sitePackagesPath}/tofino
  '';
}
