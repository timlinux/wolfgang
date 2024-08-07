#let
#  #
#  # Note that I am using a specific version from NixOS here because of
#  # https://github.com/NixOS/nixpkgs/issues/267916#issuecomment-1817481744
#  #
#  nixpkgs = builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-22.11.tar.gz";
#  #nixpkgs = builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/51f732d86fac4693840818ad2aa4781d78be2e89.tar.gz";
#  pkgs = import nixpkgs { config = { }; overlays = [ ]; };
#  pythonPackages = pkgs.python311Packages;

with import <nixpkgs> { };
let
  # For packages pinned to a specific version
  pinnedHash = "617579a787259b9a6419492eaac670a5f7663917";
  pinnedPkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/${pinnedHash}.tar.gz") { };
  pythonPackages = python3Packages;
in pkgs.mkShell rec {
  name = "impurePythonEnv";
  venvDir = "./.venv";
  buildInputs = [
    # A Python interpreter including the 'venv' module is required to bootstrap
    # the environment.
    pythonPackages.python

    # This executes some shell code to initialize a venv in $venvDir before
    # dropping into the shell
    pythonPackages.venvShellHook
    pinnedPkgs.virtualenv
    # Those are dependencies that we would like to use from nixpkgs, which will
    # add them to PYTHONPATH and thus make them accessible from within the venv.
    pythonPackages.numpy
    pinnedPkgs.armadillo # needed for fringe lib
    pinnedPkgs.blas # needed for fringe lib
    pinnedPkgs.openssl
    pinnedPkgs.git
    pinnedPkgs.libxml2
    pinnedPkgs.libxslt
    pinnedPkgs.libzip
    pinnedPkgs.zlib
    pinnedPkgs.gnused
    pinnedPkgs.parallel
    pinnedPkgs.moreutils
    pinnedPkgs.unzip
    pinnedPkgs.zip
    pinnedPkgs.qt5Full
    pinnedPkgs.hcloud
    pinnedPkgs.poppler_utils
    pythonPackages.pip
    pythonPackages.cython
    pythonPackages.numpy
    pythonPackages.setuptools
    pythonPackages.gdal
    pythonPackages.pybind11
    pythonPackages.rasterio
    pythonPackages.jupyter
    pythonPackages.ipython
    pythonPackages.webdavclient3
    pythonPackages.relatorio
    pythonPackages.geopandas
    pythonPackages.watchdog
    pythonPackages.psutil
    pythonPackages.django
    pythonPackages.psycopg2
    pythonPackages.python-dotenv
    pythonPackages.ipympl
    pythonPackages.shapely
    pythonPackages.beautifulsoup4
    pythonPackages.xmltodict
    pythonPackages.resend
    pythonPackages.sentry-sdk
    pinnedPkgs.cmake
    pinnedPkgs.pkg-config
    pinnedPkgs.xorg.libX11
    pinnedPkgs.xorg.libX11.dev
    pinnedPkgs.gfortran9
    pinnedPkgs.fftw
    pinnedPkgs.fftwFloat
    pinnedPkgs.motif
    pinnedPkgs.opencv
    pinnedPkgs.vim
    pinnedPkgs.git
    pinnedPkgs.wget
    pinnedPkgs.screen
    pinnedPkgs.gotop
    pinnedPkgs.pandoc
    pinnedPkgs.pigz
    # For printing from jupyter
    # The list after scheme-small and latex are all .sty latex
    # modules that are needed for jupyter printing to work. 
    # I obtained the list from this issue:
    # https://github.com/jupyter/nbconvert/issues/1328#issue-659661022
    # Scheme-small is a small footprint latext install. The
    # latex schemes and the sytax for the entry below are 
    # described here:
    # https://nixos.wiki/wiki/TexLive
    # To actually generate a pdf in jupyter, do
    # File -> Save and export notebook as -> PDF
    (pinnedPkgs.texlive.combine { inherit (texlive)
        scheme-small latex adjustbox caption collectbox enumitem environ eurosym jknapltx
        parskip pgf rsfs tcolorbox titling trimspaces ucs ulem upquote 
        lastpage titlesec advdate pdfcol soul
        collection-langgerman collection-langenglish
    ;})
    pinnedPkgs.pandoc
    #pinnedPkgs.tetex
    #pinnedPkgs.texlive.combined.scheme-full
  ];
  # Run this command, only after creating the virtual environment
  PROJECT_ROOT = builtins.getEnv "PWD";

  postVenvCreation = ''
    unset SOURCE_DATE_EPOCH
    pip install -r requirements.txt
    mkdir -p SAR_SMM
    echo "#!/usr/bin/env bash" > environment.sh
    # escape environment variable name
    echo "export MINTPY_HOME=\$(python -c 'import site; print(site.getsitepackages()[0])')/mintpy" >> environment.sh
    echo "export MIAPLPY_HOME=$(python -c 'import site; print(site.getsitepackages()[0])')/miaplpy" >> environment.sh
    echo "export PATH=\$ISCE_HOME/applications:\$PATH" >> environment.sh
    echo "export ISCE_HOME=${PROJECT_ROOT}/isce2-build" >> environment.sh
    echo "export PATH=\$ISCE_HOME/applications:\$PATH" >> environment.sh
    echo "export ISCE_STACK=${PROJECT_ROOT}/isce2/contrib/stack" >> environment.sh
    echo "export PATH=\$PATH:\$ISCE_HOME/bin:\$ISCE_HOME/packages/isce/applications:${PROJECT_ROOT}/fringe-build/bin:${PROJECT_ROOT}/snaphu-build/" >> environment.sh
    echo "export PYTHONPATH=\$PYTHONPATH:${PROJECT_ROOT}/isce2-build/packages:${PROJECT_ROOT}/fringe-build/python:\$ISCE_STACK:\$ISCE_HOME:\$ISCE_HOME/packages/isce2/components:${PROJECT_ROOT}/SAR_SMM" >> environment.sh
    echo "export PATH=\$PATH:${PROJECT_ROOT}/isce2-build/packages/isce/applications/" >> environment.sh
    echo "# This needs to be last to shadow out scripts with duplicate names" >> environment.sh

    # We don't add topStack to PATH, due to https://github.com/isce-framework/isce2/blob/main/contrib/stack/README.md
    # Adding topsStack or stripmapStack will be done when running SMM processing script.
    # stripmapStack will be used when processing TerraSAR-X.
    # topsStack will be used when processing Sentinel.
    #echo "export PATH=\$PATH:\$ISCE_STACK/topsStack" >> environment.sh

    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${PROJECT_ROOT}/fringe-build/lib:${stdenv.cc.cc.lib}/lib/:${pkgs.lib.makeLibraryPath buildInputs}:${pkgs.stdenv.cc.cc.lib.outPath}" >> environment.sh
    echo "export PATH=\$PATH:`pwd`/snaphu-build" >> environment.sh
    chmod +x environment.sh
    source environment.sh
    ./setup.sh
    python test.py

  '';

  # Now we can execute any commands within the virtual environment.
  # This is optional and can be left out to run pip manually.
  postShellHook = ''
    # allow pip to install wheels
    unset SOURCE_DATE_EPOCH
    source environment.sh
  '';


}
