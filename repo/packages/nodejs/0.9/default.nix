world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.node or null) (pkgs.nodejs or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      js_of_ocaml = opamSelection.js_of_ocaml;
      lwt = opamSelection.lwt;
      magic-mime = opamSelection.magic-mime;
      ocaml = opamSelection.ocaml;
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
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "nodejs-0.9";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "nodejs";
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
    sha256 = "0kkj0lrnvm2gvivym01y954i8k3sl5yhdzdj725dh730ymwlh7nk";
    url = "https://github.com/fxfactorial/ocaml-nodejs/archive/v0.9.tar.gz";
  };
}

