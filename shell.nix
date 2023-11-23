#with import <nixpkgs> { };
let
  # 
  # Note that I am using a specific version from NixOS here because of 
  # https://github.com/NixOS/nixpkgs/issues/267916#issuecomment-1817481744
  #
  nixpkgs = builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/5751ca54362d36af0227e8931c78cc91934c60e3.tar.gz";
  pkgs = import nixpkgs { config = { }; overlays = [ ]; };
  pythonPackages = pkgs.python311Packages;
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

    # Those are dependencies that we would like to use from nixpkgs, which will
    # add them to PYTHONPATH and thus make them accessible from within the venv.
    pkgs.openssl
    pkgs.git
    pkgs.libxml2
    pkgs.libxslt
    pkgs.libzip
    pkgs.zlib
    pkgs.gnused
    pythonPackages.cython
    pythonPackages.numpy
    pythonPackages.setuptools
    pythonPackages.gdal
    # Currently broken, see requirements.txt rather
    pythonPackages.jupyterhub 
    pythonPackages.ipympl
    pythonPackages.pyppeteer # for pdf export of jupyter notebook
    pkgs.cmake
    pkgs.gfortran9
    pkgs.fftw
    pkgs.fftwFloat
    pkgs.motif
    pkgs.opencv
  ];

  # Run this command, only after creating the virtual environment
  postVenvCreation = ''
    unset SOURCE_DATE_EPOCH
    pip install -r requirements.txt
  '';

  # Now we can execute any commands within the virtual environment.
  # This is optional and can be left out to run pip manually.
  postShellHook = ''
    # allow pip to install wheels
    unset SOURCE_DATE_EPOCH
  '';

  PROJECT_ROOT = builtins.getEnv "PWD";

  shellHook = ''
    # Make sure you have run setup.sh the first time you install 
    export ISCE_HOME=${PROJECT_ROOT}/isce2-build
    export PATH=$ISCE_HOME/applications:$PATH
    ./setup.sh
    python test.py
  '';

}
