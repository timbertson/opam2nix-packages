world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      beluga = opamSelection.beluga or null;
      ocaml = opamSelection.ocaml;
      ocaml-twt = opamSelection.ocaml-twt;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ounit = opamSelection.ounit or null;
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
  name = "sqlite3EZ-0.1.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "sqlite3EZ";
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
    sha256 = "0j1paqxfxrywiadx9kahp07052mkp2zi3vw9apcwnraaj7awbllf";
    url = "https://github.com/mlin/ocaml-sqlite3EZ/archive/v0.1.0.tar.gz";
  };
}

