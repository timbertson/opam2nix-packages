world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      batteries = opamSelection.batteries or null;
      csv = opamSelection.csv;
      estring = opamSelection.estring or null;
      extlib = opamSelection.extlib or null;
      extlib-compat = opamSelection.extlib-compat or null;
      lwt = opamSelection.lwt;
      oasis = opamSelection.oasis;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      sqlite3 = opamSelection.sqlite3 or null;
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
  name = "sqlexpr-0.3.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "sqlexpr";
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
    sha256 = "1jdlrxq9s96nxfbxk2g62fnhk18gqg6hl6vfh814b9w7xvqgc1jp";
    url = "https://github.com/downloads/mfp/ocaml-sqlexpr/ocaml-sqlexpr-0.3.0.tar.gz";
  };
}

