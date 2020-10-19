{ bf-sde, fetchFromGitHub }:

bf-sde.buildP4Program rec {
  version = "0.1";
  name = "packet-broker-${version}";
  p4Name = "packet_broker";
  src = import ./repo.nix { inherit fetchFromGitHub; };
  kernelModule = "bf_kpkt";
}
