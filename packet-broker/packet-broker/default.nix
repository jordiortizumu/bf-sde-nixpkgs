{ bf-sde, callPackage }:

{
  packetBroker = callPackage ./packet-broker.nix { inherit bf-sde; };
  configd = callPackage ./configd.nix { inherit bf-sde; };
  ## Include a copy of the SDE. This is useful to include those
  ## executables (in particular "bfshell") in a nix-env.
  inherit bf-sde;
  services = callPackage ./services { };
}
