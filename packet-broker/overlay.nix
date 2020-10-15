let
  overlay = self: super:
    {
      net_snmp = super.net_snmp.overrideAttrs (oldAttrs: rec {
        configureFlags = oldAttrs.configureFlags ++ [ "--with-perl-modules" ];
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
      packetBroker = self.recurseIntoAttrs (import ./packet-broker {
        bf-sde = self.bf-sde.latest;
	inherit (self) callPackage;
      });
    };
in [ overlay ]
