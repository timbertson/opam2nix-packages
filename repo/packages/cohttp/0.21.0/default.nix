world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      async = opamSelection.async or null;
      base-bytes = opamSelection.base-bytes;
      base64 = opamSelection.base64;
      cmdliner = opamSelection.cmdliner;
      conduit = opamSelection.conduit;
      fieldslib = opamSelection.fieldslib;
      js_of_ocaml = opamSelection.js_of_ocaml or null;
      lwt = opamSelection.lwt or null;
      magic-mime = opamSelection.magic-mime;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ppx_fields_conv = opamSelection.ppx_fields_conv;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      re = opamSelection.re;
      sexplib = opamSelection.sexplib;
      stringext = opamSelection.stringext;
      uri = opamSelection.uri;
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
  name = "cohttp-0.21.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "cohttp";
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
    sha256 = "09n45x5z2zb2f6nqa03fk056dbbvc5z5hk4yjk435ks7zhfbrqk5";
    url = "https://github.com/mirage/ocaml-cohttp/archive/v0.21.0.tar.gz";
  };
}

