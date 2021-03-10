{ pkgs }:

let
  bf-sde = pkgs.bf-sde.latest;
  services = import ./services { inherit (pkgs) path runCommand; };
  release = {
    packetBroker = pkgs.callPackage ./packet-broker.nix { inherit bf-sde; };
    configd = pkgs.callPackage ./configd.nix { inherit bf-sde; };
    inherit (pkgs) SNMPAgent;
    ## For bfshell
    inherit (bf-sde.pkgs) bf-utils;
  };
in {
  ## Final installation on the target system with
  ##   nix-env -f . -p /nix/var/nix/profiles/per-user/$USER/packet-broker -r -i -A packetBroker.install
  install = release // services // {
    wrapper = release.packetBroker.makeModuleWrapper;
  };

  ## Closure for binary deployments containing the release derivations
  ## plus the modules for all supported kernels.  If this closure is
  ## available in the Nix store of the target, only the services and
  ## wrapper will be built locally.
  closure = pkgs.buildEnv {
    name = "packet-broker-closure";
    paths = builtins.attrValues (release // bf-sde.buildModulesForAllKernels);
    ignoreCollisions = true;
  };
}
