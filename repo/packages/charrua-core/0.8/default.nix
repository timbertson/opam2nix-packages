world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cstruct = opamSelection.cstruct;
      ipaddr = opamSelection.ipaddr;
      jbuilder = opamSelection.jbuilder;
      menhir = opamSelection.menhir;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ppx_cstruct = opamSelection.ppx_cstruct;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      rresult = opamSelection.rresult;
      sexplib = opamSelection.sexplib;
      tcpip = opamSelection.tcpip;
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
  name = "charrua-core-0.8";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "charrua-core";
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
    sha256 = "1c0jmchfkax24srxcnlfgqd05c2axq8b9brad2lgdaycjh35gvdf";
    url = "https://github.com/mirage/charrua-core/releases/download/v0.8/charrua-core-0.8.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

