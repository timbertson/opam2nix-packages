world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      async = opamSelection.async or null;
      camlzip = opamSelection.camlzip;
      cfstream = opamSelection.cfstream;
      core = opamSelection.core or null;
      core_kernel = opamSelection.core_kernel;
      lwt = opamSelection.lwt or null;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ounit = opamSelection.ounit or null;
      ppx_compare = opamSelection.ppx_compare;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      re = opamSelection.re;
      rresult = opamSelection.rresult;
      sexplib = opamSelection.sexplib;
      solvuu-build = opamSelection.solvuu-build;
      uri = opamSelection.uri;
      xmlm = opamSelection.xmlm;
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
  name = "biocaml-0.7.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "biocaml";
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
    sha256 = "1khlabnffm26h7sxzmxf9w334dpnw9h1lnxxyjybnsllrzaj2igm";
    url = "https://github.com/biocaml/biocaml/archive/0.7.0.tar.gz";
  };
}

