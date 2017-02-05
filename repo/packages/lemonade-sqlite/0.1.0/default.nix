world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.sqlite3 or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      broken = opamSelection.broken;
      bsdowl = opamSelection.bsdowl;
      conf-bmake = opamSelection.conf-bmake;
      lemonade = opamSelection.lemonade;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
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
  name = "lemonade-sqlite-0.1.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "lemonade-sqlite";
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
    sha256 = "17p9j50045521qjbihlbv1fy90rkj2r6a19y12adipq0rfv3a0yp";
    url = "https://github.com/michipili/lemonade-sqlite/releases/download/v0.1.0/lemonade-sqlite-0.1.0.tar.xz";
  };
}

