world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cmdliner = opamSelection.cmdliner;
      crunch = opamSelection.crunch;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      toml = opamSelection.toml;
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
  name = "pds-5.18";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "pds";
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
    sha256 = "061g1zc1czgxcalnsw7q02l6k86x5cr1l1336fbjgmbc5761sxj1";
    url = "https://bitbucket.org/mimirops/pds/get/5.18.tar.gz";
  };
}

