{ runtime ? false, pname, version, buildSystem, src, patches, lib,
  stdenv, bf-drivers, makeWrapper, bridge-utils, inetutils, gnugrep,
  coreutils, ethtool, iproute, procps, cmake, thrift }:

let
  python = bf-drivers.pythonModule;
in stdenv.mkDerivation rec {
  pname = "ptf-utils" + lib.optionalString runtime "-runtime";
  inherit version src patches;

  buildInputs = [ python python.pkgs.wrapPython makeWrapper ]
                ++ lib.optional (lib.versionAtLeast version "9.8.0") [ thrift ]
                ++ lib.optional buildSystem.isCmake [ cmake ];

  preConfigure = buildSystem.preConfigure rec {
    package = "ptf-modules";
    cmakeRules = ''
      set(PTF_PKG_DIR "${package}")
      add_subdirectory(''${BF_PKG_DIR}/''${PTF_PKG_DIR}/ptf-utils)
    '';
    alternativeCmds = ''
      cd ptf-utils
    '' + lib.optionalString (version == "9.1.1") ''
      sed -i Makefile.in -e '/^ixia_utils.*$/d'
    '';
  };

  preBuild = lib.optionalString (! buildSystem.isCmake) ''
    substituteInPlace run_ptf_tests.py --replace six.print '#six.print'
  '';
  postInstall = ''
    utilsPath=$out/lib/${python.libPrefix}/site-packages/p4testutils/
  '' +
  ## Starting with 9.8.0, the bf_switch_dev_status.py utility is part
  ## of the bf-drivers package.
  (if (lib.versionOlder version "9.8.0") then
    (''
       chmod a+x $utilsPath/run_ptf_tests.py $utilsPath/bf_switchd_dev_status.py
     '' + lib.optionalString runtime ''
       mv $utilsPath/bf_switchd_dev_status.py $TEMP
       rm -rf $out/share $utilsPath/*
       mv $TEMP/bf_switchd_dev_status.py $utilsPath
     '')
   else (''
       chmod a+x $utilsPath/*
     '' + lib.optionalString runtime ''
       rm -rf $out/share $utilsPath/*
     '')
  ) +
  ''
    for program in $out/bin/port_*; do
      wrapProgram $program \
        --set PATH "${lib.strings.makeBinPath [ bridge-utils inetutils gnugrep ]}"
    done

  '' + (if buildSystem.isCmake then
          ## ptf-modules was converted to python3 in 9.7.0 but some
          ## modules were missed, which leads to errors during
          ## compilation below.  The CMake installer does not
          ## perform python compilation, which is probably why Intel
          ## did not notice the problem.  We simply don't install those
          ## scripts and assume they are not used anywhere.
          lib.optionalString (lib.versionAtLeast version "9.7.0") ''
            rm -f $utilsPath/{traffic_streams.py,traffic_utils.py}
          '' + ''
            python -m compileall $utilsPath
            substituteInPlace $out/bin/veth_setup.sh --replace /sbin/ethtool ethtool
            wrapProgram $out/bin/veth_setup.sh \
              --set PATH "${lib.strings.makeBinPath [ coreutils ethtool iproute gnugrep procps ]}"
            wrapProgram $out/bin/veth_teardown.sh \
              --set PATH "${lib.strings.makeBinPath [ coreutils iproute ]}"
          ''
        else ''
          substitute veth_setup.sh $out/bin/veth_setup.sh --replace /sbin/ethtool ethtool
          wrapProgram $out/bin/veth_setup.sh \
            --set PATH "${lib.strings.makeBinPath [ coreutils ethtool iproute gnugrep procps ]}"
          cp veth_teardown.sh $out/bin
          wrapProgram $out/bin/veth_teardown.sh \
            --set PATH "${lib.strings.makeBinPath [ coreutils iproute ]}"
        '');

  pythonPath = with python.pkgs; [ six ];
  postFixup = ''
    wrapPythonProgramsIn $utilsPath "$utilsPath $pythonPath"
  '';
}

