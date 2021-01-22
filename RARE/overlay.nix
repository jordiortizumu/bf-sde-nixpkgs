let
  overlay = self: super:
    {
      dpdk = super.dpdk.overrideAttrs (oldAttrs: rec {
        name = "dpdk-${version}";
        version = "20.11";
        src = self.fetchurl {
          url = "https://fast.dpdk.org/rel/dpdk-${version}.tar.xz";
          sha256 = "0rbmaybvk0khhmmp47mvhq8jq7gjmrrp1brxzn8k180a20m6pxvh";
        };
      });
      freerouter = super.callPackage ./freerouter {
        openssl = self.openssl_1_1;
      };

      net_snmp = super.net_snmp.overrideAttrs (oldAttrs: rec {
        configureFlags = oldAttrs.configureFlags ++
          [ "--with-perl-modules"
            "--with-persistent-directory=/var/lib/snmp"
          ];
        preConfigure = ''
          perlversion=$(perl -e 'use Config; print $Config{version};')
          perlarchname=$(perl -e 'use Config; print $Config{archname};')
          installFlags="INSTALLSITEARCH=$out/lib/perl5/site_perl/$perlversion/$perlarchname INSTALLARCHLIB=$out/lib/perl5/site_perl/$perlversion/$perlarchname INSTALLSITEMAN3DIR=$out/share/man/man3"
          # http://comments.gmane.org/gmane.network.net-snmp.user/32434
          substituteInPlace "man/Makefile.in" --replace 'grep -vE' '@EGREP@ -v'
        '';

        ## The standard package uses multiple outputs, but this fails
        ## when Perl modules are enabled.  This override should be fixed
        ## to support this.
        outputs = [ "out" ];

        ## Make sure libsnmp is available before building the Perl modules
        enableParallelBuilding = false;

        ## Skip multi-output logic
        postInstall = "true";
      });

      SNMPAgent = super.callPackage ./snmp {};

      RARE = self.recurseIntoAttrs (import ./RARE {
        pkgs = self;
        bf-sde = self.bf-sde.latest;
      });
    };
in [ overlay ]
