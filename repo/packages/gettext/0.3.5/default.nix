world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      camomile = opamSelection.camomile;
      fileutils = opamSelection.fileutils;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ounit = opamSelection.ounit;
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
  name = "gettext-0.3.5";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "gettext";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  postUnpack = "cp -r ${./files}/* \"$sourceRoot/\"";
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "0s625h7y9xxqvzk4bnw45k4wvl4fn8gblv56bp47il0lgsx8956i";
    url = "https://forge.ocamlcore.org/frs/download.php/1433/ocaml-gettext-0.3.5.tar.gz";
  };
}

