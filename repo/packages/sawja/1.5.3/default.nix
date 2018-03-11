world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      extlib-compat = opamSelection.extlib-compat;
      javalib = opamSelection.javalib;
      ocaml = opamSelection.ocaml;
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
  name = "sawja-1.5.3";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "sawja";
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
    sha256 = "17vfknr126vfhpmr14j75sg8r47xz7pw7fba4nsdw3k7rq43vcn2";
    url = "https://gforge.inria.fr/frs/download.php/file/37403/sawja-1.5.3.tar.bz2";
  };
}

