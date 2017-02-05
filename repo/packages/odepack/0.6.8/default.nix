world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.gcc or null) (pkgs.gcc-fortran or null)
        (pkgs.gcc-gfortran or null) (pkgs.gfortran or null)
        (pkgs."lang/f77" or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-bigarray = opamSelection.base-bigarray;
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
  name = "odepack-0.6.8";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "odepack";
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
    sha256 = "1himjkmlvyksfz48yxlfnji3bxm7z9nckf4my4k23saili4sxf4f";
    url = "https://github.com/Chris00/ocaml-odepack/releases/download/0.6.8/odepack-0.6.8.tar.gz";
  };
}

