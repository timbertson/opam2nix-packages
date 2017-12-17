world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cmdliner = opamSelection.cmdliner;
      js_of_ocaml = opamSelection.js_of_ocaml or null;
      js_of_ocaml-compiler = opamSelection.js_of_ocaml-compiler or null;
      js_of_ocaml-toplevel = opamSelection.js_of_ocaml-toplevel;
      ocaml = opamSelection.ocaml;
      ocaml-webworker = opamSelection.ocaml-webworker;
      ocamlfind = opamSelection.ocamlfind;
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
  name = "ocaml-gist-0.0.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ocaml-gist";
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
    sha256 = "1xyiw6rly2ljb333c22139vx3j60cv1301hyx7ml7d7632afgwfa";
    url = "https://github.com/SanderSpies/ocaml-gist/archive/0.0.2.tar.gz";
  };
}

