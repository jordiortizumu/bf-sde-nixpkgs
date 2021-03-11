{ pkgs }:

let
  bf-sde = pkgs.bf-sde.latest;
  release = {
    packet-broker = pkgs.callPackage ./packet-broker.nix { inherit bf-sde; };
    configd = pkgs.callPackage ./configd.nix { inherit bf-sde; };
  };
  services = import ./services { inherit (pkgs) path runCommand; };
  moduleWrapper = release.packet-broker.makeModuleWrapper;

  ## We want to have bfshell in the profile's bin directory. It
  ## should be enough to inherit bf-utils here. However, bf-utils is
  ## a multi-output package and nix-env unconditonally realizes all
  ## outputs when it should just use meta.outputsToInstall. In this
  ## case, the second output is "dev", which requires the full SDE
  ## to be available. That is not the case in a runtime-only binary
  ## deployment.  We work around this by wrapping bf-utils in an
  ## environment.
  bf-utils-env = pkgs.buildEnv {
    name = "bf-utils-env";
    paths = [ bf-sde.pkgs.bf-utils ];
  };

  ## Closure for binary deployments containing the release derivations
  ## plus the modules for all supported kernels and the SNMP agent.
  ## If this closure is available in the Nix store of the target or
  ## through a binary cache, only the services and wrapper will be
  ## built locally. Note that bf-utils is part of the closure of
  ## release.packet-broker so we don't have to include it explicitly.
  closure = pkgs.buildEnv {
    name = "packet-broker-closure";
    paths = builtins.attrValues (release // bf-sde.buildModulesForAllKernels //
                                 { inherit (pkgs) SNMPAgent; });

    ## Ignore collisions of the module install scripts. The
    ## environment is just a vehicle to collect everything in a single
    ## derivation.
    ignoreCollisions = true;
  };
in {
  ## For ../release.nix
  inherit release closure;

  ## Final installation on the target system with
  ##   nix-env -f . -p <some-profile-name> -r -i -A packet-broker.install
  install = release // services // {
    inherit moduleWrapper bf-utils-env;
  };
}
