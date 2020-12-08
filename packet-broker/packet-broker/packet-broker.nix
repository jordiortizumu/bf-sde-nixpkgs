{ bf-sde, fetchFromGitHub }:

bf-sde.buildP4Program rec {
  version = "0.1";
  pname = "packet-broker";
  p4Name = "packet_broker";
  src = import ./repo.nix { inherit fetchFromGitHub; };
  requiredKernelModule = "bf_kpkt";
}
