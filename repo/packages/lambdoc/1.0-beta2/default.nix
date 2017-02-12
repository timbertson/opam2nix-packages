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
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "lambdoc-1.0-beta2";
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
  prePatch = "cp -r ${./files}/* ./";
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "0pax7637ys92cndvdzbdffb8hvzpbyipl4a32ziqlilf3ikr3yy1";
    url = "https://forge.ocamlcore.org/frs/download.php/1459/lambdoc-1.0-beta2.tgz";
  };
}

