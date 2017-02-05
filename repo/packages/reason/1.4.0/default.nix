world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      BetterErrors = opamSelection.BetterErrors;
      easy-format = opamSelection.easy-format;
      menhir = opamSelection.menhir;
      merlin = opamSelection.merlin;
      merlin-extend = opamSelection.merlin-extend;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      re = opamSelection.re;
      utop = opamSelection.utop;
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
  name = "reason-1.4.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "reason";
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
    sha256 = "1d8b09wvf80jkh1ahrvlbkvazw2fvykb07n6wig8pbarx99ida8r";
    url = "https://github.com/facebook/reason/archive/1.4.0.zip";
  };
}

