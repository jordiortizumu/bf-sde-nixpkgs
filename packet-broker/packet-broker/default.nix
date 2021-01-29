{ pkgs }:

let
  bf-sde = pkgs.bf-sde.latest;
in with pkgs;
{
  packetBroker = callPackage ./packet-broker.nix { inherit bf-sde; };
  configd = callPackage ./configd.nix { inherit bf-sde; };
  ## Include a copy of the SDE. This is useful to include those
  ## executables (in particular "bfshell") in a nix-env.
  inherit bf-sde;
  services = import ./services { inherit path runCommand; };
}
