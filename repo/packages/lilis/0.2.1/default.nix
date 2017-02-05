world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      batteries = opamSelection.batteries or null;
      cairo2 = opamSelection.cairo2 or null;
      cfstream = opamSelection.cfstream or null;
      cmdliner = opamSelection.cmdliner or null;
      containers = opamSelection.containers;
      core_kernel = opamSelection.core_kernel or null;
      cppo = opamSelection.cppo;
      js_of_ocaml = opamSelection.js_of_ocaml or null;
      lablgtk = opamSelection.lablgtk or null;
      menhir = opamSelection.menhir;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      tyxml = opamSelection.tyxml or null;
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
  name = "lilis-0.2.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "lilis";
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
    sha256 = "1cp5ns9070apir8q2i2x52j9jncydsl766mhb15lxnb5az526v0a";
    url = "https://github.com/Drup/LILiS/archive/v0.2.1.tar.gz";
  };
}

