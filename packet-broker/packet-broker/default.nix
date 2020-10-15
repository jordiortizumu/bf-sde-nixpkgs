{ bf-sde, callPackage }:

{
  packetBroker = callPackage ./packet-broker.nix { inherit bf-sde; };
  configd = callPackage ./configd.nix { inherit bf-sde; };
}
