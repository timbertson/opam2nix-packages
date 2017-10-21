world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      config-file = opamSelection.config-file;
      lablgtk = opamSelection.lablgtk;
      lablgtk-extras = opamSelection.lablgtk-extras;
      menhir = opamSelection.menhir;
      mysql = opamSelection.mysql;
      ocaml = opamSelection.ocaml;
      ocamldot = opamSelection.ocamldot;
      ocamlfind = opamSelection.ocamlfind;
      ocamlnet = opamSelection.ocamlnet;
      pcre = opamSelection.pcre;
      postgresql = opamSelection.postgresql or null;
      rdf = opamSelection.rdf;
      xtmpl = opamSelection.xtmpl;
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
  name = "genet-0.5";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "genet";
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
    sha256 = "04ld1ikppr2k4kscb36ynds3203cqf72xh3b92la457dsp458f7x";
    url = "http://zoggy.github.io/genet/genet-0.5.tar.gz";
  };
}

