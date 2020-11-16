let
  overlay = self: super:
    {
      dpdk = super.dpdk.overrideAttrs (oldAttrs: rec {
        version = "20.08";
        src = self.fetchurl {
          url = "https://fast.dpdk.org/rel/dpdk-${version}.tar.xz";
          sha256 = "0ixhb6jdjcn8191dk6g8dyby7qxwjfyj88r1vaimnp0vcl2gycqs";
        };
        MAKE_PAUSE = "n";
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
          installFlags="INSTALLSITEARCH=$out/lib/perl5/site_perl/$perlversion/$perlarchname INSTALLSITEMAN3DIR=$out/share/man/man3"
          # http://comments.gmane.org/gmane.network.net-snmp.user/32434
          substituteInPlace "man/Makefile.in" --replace 'grep -vE' '@EGREP@ -v'
	'';
	## Make sure libsnmp is available before building the Perl modules
	enableParallelBuilding = false;
      });

      SNMPAgent = super.callPackage ./snmp {};

      RARE = self.recurseIntoAttrs (import ./RARE {
        bf-sde = self.bf-sde.latest;
        inherit (self) callPackage;
      });
    };
in [ overlay ]
