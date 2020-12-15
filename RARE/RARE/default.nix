{ bf-sde, callPackage }:

let
  fetchBitbucketPrivate = callPackage ./fetchbitbucket {
    identityFile = ./bitbucket_deployment_rsa;
  };
  sal_modules = callPackage ./sal/modules.nix {
    inherit fetchBitbucketPrivate;
  };
  std = {
    inherit bf-sde;
    requiredKernelModule = "bf_kpkt";
  };
in rec {
  mpls = callPackage ./generic.nix (std // {
    flavor = "mpls";
    buildFlags = "-DHAVE_MPLS";
  });
  mpls_wedge100bf32x = callPackage ./generic.nix (std // {
    flavor = "mpls_wedge100bf32x";
    buildFlags = "-DHAVE_MPLS -D_WEDGE100BF32X_";
  });
  srv6 = callPackage ./generic.nix (std // {
    flavor = "srv6";
    buildFlags = "-DHAVE_SRV6";
  });
  srv6_wedge100bf32x = callPackage ./generic.nix (std // {
    flavor = "srv6_wedge100bf32x";
    buildFlags = "-DHAVE_SRV6 -D_WEDGE100BF32X_";
  });
  bf_forwarder = callPackage ./bf_forwarder.nix {
    inherit bf-sde sal_modules;
  };
  sal_bf2556x = callPackage ./sal/bf2556x.nix {
    inherit fetchBitbucketPrivate sal_modules;
  };
  p4Dummy = bf-sde.buildP4DummyProgram;
  ## Include a copy of the SDE. This is useful to include those
  ## executables (in particular "bfshell") in an environment with
  ## "nix-env -A RARE".
  inherit bf-sde;
}
