world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs."g++-4.8" or null)
        (pkgs."https://gist.githubusercontent.com/domsj/9a28ba5a523a3420ded8/raw/dc6ebd8768a87dee285e84438dc733dfc58e037f/gistfile1.txt" or null)
        (pkgs.libbz2-dev or null) (pkgs.libgflags-dev or null)
        (pkgs.libsnappy-dev or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      ctypes = opamSelection.ctypes;
      ctypes-foreign = opamSelection.ctypes-foreign;
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
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "orocksdb-0.2.2";
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
    sha256 = "1ywsp0hjlw5a308hr0ssrvpwn3gnkz6izwgayia4p3grw9nw2nl9";
    url = "https://github.com/domsj/orocksdb/archive/0.2.2.tar.gz";
  };
}

