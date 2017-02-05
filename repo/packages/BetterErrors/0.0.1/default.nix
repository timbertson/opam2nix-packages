world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      ANSITerminal = opamSelection.ANSITerminal;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      re = opamSelection.re;
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
  name = "BetterErrors-0.0.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "BetterErrors";
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
    sha256 = "0iw2y5bxlkdwvimkfsl77cig8vh7mc2ghsgj81vwz8rr6yi2gvv1";
    url = "https://github.com/reasonml/BetterErrors/archive/v0.0.1.tar.gz";
  };
}

