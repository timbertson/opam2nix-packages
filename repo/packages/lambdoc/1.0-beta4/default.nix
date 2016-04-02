world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      batteries = opamSelection.batteries;
      blahcaml = opamSelection.blahcaml;
      camlhighlight = opamSelection.camlhighlight;
      camlp4 = opamSelection.camlp4;
      menhir = opamSelection.menhir;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      omd = opamSelection.omd;
      pcre = opamSelection.pcre;
      pxp = opamSelection.pxp;
      sexplib = opamSelection.sexplib;
      type_conv = opamSelection.type_conv;
      tyxml = opamSelection.tyxml;
      ulex = opamSelection.ulex;
      xstrp4 = opamSelection.xstrp4;
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
  name = "lambdoc-1.0-beta4";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "lambdoc";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  postUnpack = "cp -r ${./files}/* \"$sourceRoot/\"";
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "1b5jwkf9266vapmh8jwq6mbdr7w0aacsbhxiaavrwazskxqfrylp";
    url = "https://github.com/darioteixeira/lambdoc/archive/v1.0-beta4.tar.gz";
  };
}

