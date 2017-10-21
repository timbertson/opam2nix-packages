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
      async_rpc_kernel = opamSelection.async_rpc_kernel;
      async_unix = opamSelection.async_unix;
      bin_prot = opamSelection.bin_prot;
      camlp4 = opamSelection.camlp4;
      core = opamSelection.core;
      fieldslib = opamSelection.fieldslib;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      pa_ounit = opamSelection.pa_ounit;
      pipebang = opamSelection.pipebang;
      sexplib = opamSelection.sexplib;
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
  name = "async_extra-113.00.00";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "async_extra";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  prePatch = "cp -r ${./files}/* ./";
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "1ad1hdzl775adxs5n6p9x1k5p8r6xd8g5vbqsfipjpks3x4igg1x";
    url = "https://ocaml.janestreet.com/ocaml-core/113.00/files/async_extra-113.00.00.tar.gz";
  };
}

