world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cairo2 = opamSelection.cairo2 or null;
      gg = opamSelection.gg;
      js_of_ocaml = opamSelection.js_of_ocaml;
      js_of_ocaml-compiler = opamSelection.js_of_ocaml-compiler;
      js_of_ocaml-ocamlbuild = opamSelection.js_of_ocaml-ocamlbuild;
      js_of_ocaml-ppx = opamSelection.js_of_ocaml-ppx;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      otfm = opamSelection.otfm or null;
      result = opamSelection.result;
      topkg = opamSelection.topkg;
      uchar = opamSelection.uchar;
      uutf = opamSelection.uutf or null;
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
  name = "vg-0.9.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "vg";
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
    sha256 = "1czd2fq85hy24w5pllarsq4pvbx9rda5zdikxfxdng8s9kff2h3f";
    url = "http://erratique.ch/software/vg/releases/vg-0.9.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

