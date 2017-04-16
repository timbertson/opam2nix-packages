world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      batteries = opamSelection.batteries;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      topkg = opamSelection.topkg;
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
  name = "obandit-0.2.3.1-5-g40e1b6c";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "obandit";
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
    sha256 = "1gdhjiril7gl59n243svv61i7hvd6whzjd7w4ppncc4ra595ygxy";
    url = "https://github.com/freuk/obandit/releases/download/v0.2.3.1-5-g40e1b6c/obandit-0.2.3.1-5-g40e1b6c.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

