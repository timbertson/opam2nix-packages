world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      astring = opamSelection.astring;
      hardcaml = opamSelection.hardcaml;
      hardcaml-framework = opamSelection.hardcaml-framework;
      hardcaml-waveterm = opamSelection.hardcaml-waveterm;
      js_of_ocaml = opamSelection.js_of_ocaml;
      lwt = opamSelection.lwt;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      omd = opamSelection.omd;
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
  name = "hardcaml-examples-0.3.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "hardcaml-examples";
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
    sha256 = "0sz05b6wa5yaxk7qr2v85ry9l22yk39wyang0qdnmbw4qwl93j0p";
    url = "https://github.com/ujamjar/hardcaml-examples/archive/v0.3.0.tar.gz";
  };
}

