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
      async_extended = opamSelection.async_extended;
      base64 = opamSelection.base64;
      cmdliner = opamSelection.cmdliner;
      cohttp = opamSelection.cohttp;
      core = opamSelection.core;
      cstruct = opamSelection.cstruct;
      fieldslib = opamSelection.fieldslib;
      ipaddr = opamSelection.ipaddr;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      openflow = opamSelection.openflow;
      pa_ounit = opamSelection.pa_ounit or null;
      packet = opamSelection.packet;
      quickcheck = opamSelection.quickcheck;
      sexplib = opamSelection.sexplib;
      topology = opamSelection.topology;
      ulex = opamSelection.ulex;
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
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "frenetic-3.4.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "frenetic";
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
    sha256 = "0zml4cnybs9jj5vvgb3w4rz3hsdp16cv64zndvf7rvwymvfbfi0b";
    url = "https://github.com/frenetic-lang/frenetic/archive/v3.4.1.tar.gz";
  };
}

