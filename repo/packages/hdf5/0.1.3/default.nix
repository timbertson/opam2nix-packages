world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.epel-release or null) (pkgs.hdf5-dev or null)
        (pkgs.hdf5-devel or null) (pkgs."homebrew/science/hdf5" or null)
        (pkgs.libhdf5-serial-dev or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cppo = opamSelection.cppo;
      cppo_ocamlbuild = opamSelection.cppo_ocamlbuild;
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
  name = "hdf5-0.1.3";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "hdf5";
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
    sha256 = "1mfhs4l7gnjy9zr4vqkaf1g97qwm9mmagdp8a0campxyc19gnwk3";
    url = "https://github.com/vbrankov/hdf5-ocaml/archive/v0.1.3.tar.gz";
  };
}

