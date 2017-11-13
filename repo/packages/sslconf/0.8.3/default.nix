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
      cmdliner = opamSelection.cmdliner;
      fpath = opamSelection.fpath;
      jbuilder = opamSelection.jbuilder;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      odoc = opamSelection.odoc or null;
      ounit = opamSelection.ounit or null;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      rresult = opamSelection.rresult;
      sexplib = opamSelection.sexplib;
      topkg-jbuilder = opamSelection.topkg-jbuilder;
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
  name = "sslconf-0.8.3";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "sslconf";
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
    sha256 = "02nzxjzidrw9pk1xmq2y990wxy4zy3vg351rixqrx8s7g9yaj9xl";
    url = "https://github.com/awuersch/sslconf/releases/download/0.8.3/sslconf-0.8.3.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

