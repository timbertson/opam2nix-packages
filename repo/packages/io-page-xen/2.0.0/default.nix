world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      configurator = opamSelection.configurator;
      cstruct = opamSelection.cstruct;
      io-page = opamSelection.io-page;
      jbuilder = opamSelection.jbuilder;
      mirage-xen-ocaml = opamSelection.mirage-xen-ocaml;
      ocaml = opamSelection.ocaml;
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
  name = "io-page-xen-2.0.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "io-page-xen";
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
    sha256 = "0skk1fyk06mnp1pmpz3pfdmhsgl0i5m0arcpfrxnkcchqq1sbrl5";
    url = "https://github.com/mirage/io-page/releases/download/2.0.0/io-page-2.0.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

