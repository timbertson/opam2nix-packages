world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      jbuilder = opamSelection.jbuilder;
      lwt = opamSelection.lwt;
      lwt_react = opamSelection.lwt_react;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      zed = opamSelection.zed;
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
  name = "lambda-term-1.11";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "lambda-term";
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
    sha256 = "10lx1jqgmmfwwlv64di4a8nia9l53v7179z70n9fx6aq5l7r8nba";
    url = "https://github.com/diml/lambda-term/archive/1.11.tar.gz";
  };
}

