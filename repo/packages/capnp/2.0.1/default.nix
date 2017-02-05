world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      camlp4 = opamSelection.camlp4;
      core = opamSelection.core;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ocplib-endian = opamSelection.ocplib-endian;
      omake = opamSelection.omake;
      res = opamSelection.res;
      uint = opamSelection.uint;
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
  name = "capnp-2.0.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "capnp";
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
    sha256 = "0k2js8jrjq7xsd20ik03xg4vb9iivbygam6z4s7bp1s0n9vbnxr1";
    url = "https://github.com/pelzlpj/capnp-ocaml/archive/v2.0.1.tar.gz";
  };
}

