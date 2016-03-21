world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs."g++-4.8" or null)
        (pkgs."https://gist.githubusercontent.com/toolslive/56b9fae64b27d3e00971/raw/60bc8b3f2d8980635500d89bac89e092befac5f9/gistfile1.txt" or null)
        (pkgs.libbz2-dev or null) (pkgs.libgflags-dev or null)
        (pkgs.libsnappy-dev or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      ctypes = opamSelection.ctypes;
      ctypes-foreign = opamSelection.ctypes-foreign;
      depext = opamSelection.depext;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
    };
    opamSelection = world.opamSelection;
    pkgs = world.pkgs;
in
pkgs.stdenv.mkDerivation 
{
  buildInputs = inputs;
  buildPhase = "${opam2nix}/bin/opam2nix invoke build";
  configurePhase = "true";
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "orocksdb-0.1.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "orocksdb";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "0yvqm76vd7fwsmn0gvb4kg1nj1451r56nbbdywa5xsar8i65ssic";
    url = "https://github.com/domsj/orocksdb/archive/0.1.0.tar.gz";
  };
}

