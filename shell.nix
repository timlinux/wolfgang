with import <nixpkgs> { };

let
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

    # Those are dependencies that we would like to use from nixpkgs, which will
    # add them to PYTHONPATH and thus make them accessible from within the venv.
    pythonPackages.numpy
    openssl
    git
    libxml2
    libxslt
    libzip
    zlib
    gnused
    python311Packages.cython
    python311Packages.numpy
    python311Packages.setuptools
    python311Packages.gdal
    python311Packages.jupyterlab
    python311Packages.ipympl
    cmake
    gfortran9
    fftw
    fftwFloat
    motif
    opencv
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
