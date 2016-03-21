world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.libgrib-api-dev or null) (pkgs.libjasper-dev or null)
        (pkgs.libjpeg-dev or null) (pkgs.libopenjpeg-dev or null)
        (pkgs.libpng-dev or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      batteries = opamSelection.batteries;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      pcre = opamSelection.pcre;
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
  name = "grib-0.9.7";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "grib";
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
    sha256 = "1iq2van5f2b1mr1g6l955xsbylv026h5sc2jxsi72zcvky6l9c55";
    url = "https://github.com/hcarty/ocaml-grib/archive/v0.9.7.tar.gz";
  };
}

