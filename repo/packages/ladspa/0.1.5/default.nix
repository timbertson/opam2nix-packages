world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs."drfill/liquidsoap/ladspa_header" or null)
        (pkgs.ladspa-sdk or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
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
  name = "ladspa-0.1.5";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ladspa";
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
    sha256 = "15jlj7zsq1mgx8if8rm60pkaq1hrzfysh4q9g7n98qp91ig0aigh";
    url = "https://github.com/savonet/ocaml-ladspa/releases/download/0.1.5/ocaml-ladspa-0.1.5.tar.gz";
  };
}

