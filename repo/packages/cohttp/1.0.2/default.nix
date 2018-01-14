world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      alcotest = opamSelection.alcotest or null;
      base-bytes = opamSelection.base-bytes;
      base64 = opamSelection.base64;
      fieldslib = opamSelection.fieldslib;
      fmt = opamSelection.fmt or null;
      jbuilder = opamSelection.jbuilder;
      jsonm = opamSelection.jsonm;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ppx_fields_conv = opamSelection.ppx_fields_conv;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      ppx_type_conv = opamSelection.ppx_type_conv;
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
  name = "cohttp-1.0.2";
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
    sha256 = "1x87laql7ksfq9324iq3yrx81dfjdm0knd40h880d02ny6g299v4";
    url = "https://github.com/mirage/ocaml-cohttp/releases/download/v1.0.2/cohttp-1.0.2.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

