world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs."database/sqlite3" or null) (pkgs.libsqlite3-dev or null)
        (pkgs.sqlite-dev or null) (pkgs.sqlite-devel or null)
        (pkgs.sqlite3 or null) (pkgs.sqlite3-devel or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base = opamSelection.base;
      conf-pkg-config = opamSelection.conf-pkg-config;
      configurator = opamSelection.configurator;
      jbuilder = opamSelection.jbuilder;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      stdio = opamSelection.stdio;
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
  name = "sqlite3-4.3.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "sqlite3";
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
    sha256 = "120rxzhnzp6dj29gnwimnylvwp8m2nsfcsxhqy7p3z78rsvll2i5";
    url = "https://github.com/mmottl/sqlite3-ocaml/releases/download/4.3.0/sqlite3-4.3.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

