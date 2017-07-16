world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      async_kernel = opamSelection.async_kernel;
      async_unix = opamSelection.async_unix;
      core_kernel = opamSelection.core_kernel;
      cstruct = opamSelection.cstruct;
      jbuilder = opamSelection.jbuilder;
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
  name = "cstruct-async-3.1.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "cstruct-async";
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
    sha256 = "1x4jxsvd1lrfibnjdjrkfl7hqsc48rljnwbap6faanj9qhwwa6v2";
    url = "https://github.com/mirage/ocaml-cstruct/releases/download/v3.1.1/cstruct-3.1.1.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

