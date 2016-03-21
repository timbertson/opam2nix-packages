world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      async = opamSelection.async;
      async_inotify = opamSelection.async_inotify;
      async_parallel = opamSelection.async_parallel;
      async_shell = opamSelection.async_shell;
      bin_prot = opamSelection.bin_prot;
      camlp4 = opamSelection.camlp4;
      comparelib = opamSelection.comparelib;
      core = opamSelection.core;
      core_extended = opamSelection.core_extended;
      fieldslib = opamSelection.fieldslib;
      ocaml = opamSelection.ocaml;
      ocaml_plugin = opamSelection.ocaml_plugin;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      pcre = opamSelection.pcre;
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
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "jenga-113.00.00";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "jenga";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  postUnpack = "cp -r ${./files}/* \"$sourceRoot/\"";
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "1wfjbvgkm2p9izsihmn50ivsaxyrj0yv71vgacm9d66yqx9wkspg";
    url = "https://ocaml.janestreet.com/ocaml-core/113.00/files/jenga-113.00.00.tar.gz";
  };
}

