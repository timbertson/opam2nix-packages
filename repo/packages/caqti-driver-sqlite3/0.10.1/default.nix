world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      caqti = opamSelection.caqti;
      caqti-async = opamSelection.caqti-async or null;
      caqti-dynload = opamSelection.caqti-dynload or null;
      caqti-lwt = opamSelection.caqti-lwt or null;
      jbuilder = opamSelection.jbuilder;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      sqlite3 = opamSelection.sqlite3;
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
  name = "caqti-driver-sqlite3-0.10.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "caqti-driver-sqlite3";
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
    sha256 = "103jfgd5lc6m4jvrldasp704xawcqq3d0xa7rz0kyn7lahxxicg2";
    url = "https://github.com/paurkedal/ocaml-caqti/releases/download/v0.10.1/caqti-0.10.1.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}
