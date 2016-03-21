world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      atd = opamSelection.atd;
      atdgen = opamSelection.atdgen;
      bolt = opamSelection.bolt;
      calendar = opamSelection.calendar;
      cohttp = opamSelection.cohttp;
      lwt = opamSelection.lwt;
      oasis = opamSelection.oasis;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind or null;
      ssl = opamSelection.ssl;
      uri = opamSelection.uri;
      yojson = opamSelection.yojson;
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
  name = "facebook-sdk-0.2.12";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "facebook-sdk";
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
    sha256 = "02vcj12bxsqd2a6zjq3vl1ji73yhh597kyrngqxvavh5vc5jrchn";
    url = "https://github.com/dominicjprice/facebook-sdk/archive/v0.2.12.tar.gz";
  };
}

