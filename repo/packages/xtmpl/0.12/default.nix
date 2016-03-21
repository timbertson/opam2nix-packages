world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      js_of_ocaml = opamSelection.js_of_ocaml;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      xmlm = opamSelection.xmlm;
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
  name = "xtmpl-0.12";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "xtmpl";
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
    sha256 = "0y2yx518pp5y0rvfmlcjbxq4v0ghwxi54bs711nsgfzxmds3asj4";
    url = "http://zoggy.github.com/xtmpl/xtmpl-0.12.tar.gz";
  };
}

