{ stdenv, fetchFromGitHub, jdk, jre_headless, libpcap,
  libbsd, openssl, dpdk, numactl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "freerouter-${version}";
  version = "20.12.16";

  src = fetchFromGitHub {
    owner = "mc36";
    repo = "freerouter";
    rev = "6085ccb";
    sha256 = "1nh6pcy3kab7rr59r3734c3yx1y47inw6dja87ig2f2w9jw28i3w";
  };

  outputs = [ "out" "native" ];
  buildInputs = [ jdk jre_headless makeWrapper libpcap libbsd openssl dpdk numactl ];

  NIX_LDFLAGS = "-ldl -lnuma -lrte_telemetry -lrte_mbuf -lrte_kvargs -lrte_eal";

  buildPhase = ''
    set -e
    mkdir binTmp
    pushd misc/native
    substituteInPlace p4dpdk.c --replace '<dpdk/' '<'
    sh -e ./c.sh
    popd
    pushd src
    javac router.java
    popd
  '';

  installPhase = ''
    pushd src

    mkdir -p $out/bin
    mkdir -p $out/share/java

    jar cf $out/share/java/freerouter.jar router.class */*.class
    makeWrapper ${jre_headless}/bin/java $out/bin/freerouter \
      --add-flags "-cp $out/share/java/freerouter.jar router"

    popd

    mkdir -p $native/bin
    cp binTmp/*.bin $native/bin
  '';

}
