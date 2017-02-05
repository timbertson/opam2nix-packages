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
      io-page = opamSelection.io-page;
      ipaddr = opamSelection.ipaddr;
      lwt = opamSelection.lwt;
      mirage-profile = opamSelection.mirage-profile;
      mirage-types = opamSelection.mirage-types;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind or null;
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
  name = "mirage-vnetif-0.1.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mirage-vnetif";
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
    sha256 = "0c1pnbpwzv06qh3jrjf3wpy6wcva7q05pccdsh210spby8zihnn5";
    url = "https://github.com/MagnusS/mirage-vnetif/archive/0.1.tar.gz";
  };
}

