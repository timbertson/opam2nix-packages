world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.postgresql or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      eliom = opamSelection.eliom;
      imagemagick = opamSelection.imagemagick;
      macaque = opamSelection.macaque;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ocsigen-toolkit = opamSelection.ocsigen-toolkit;
      pgocaml = opamSelection.pgocaml;
      safepass = opamSelection.safepass;
      yojson = opamSelection.yojson;
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
  name = "ocsigen-start-0.99";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ocsigen-start";
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
    sha256 = "1rrrpvcfv2y8z7m57v0p2iiaikgs1wvrzh22cg3gg0m4h0y0qrqq";
    url = "https://github.com/ocsigen/ocsigen-start/archive/v0.99.tar.gz";
  };
}

