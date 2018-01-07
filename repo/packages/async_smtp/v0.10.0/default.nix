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
      async_sendfile = opamSelection.async_sendfile;
      async_shell = opamSelection.async_shell;
      async_ssl = opamSelection.async_ssl;
      core = opamSelection.core;
      core_extended = opamSelection.core_extended;
      cryptokit = opamSelection.cryptokit;
      email_message = opamSelection.email_message;
      jbuilder = opamSelection.jbuilder;
      ocaml = opamSelection.ocaml;
      ocaml-migrate-parsetree = opamSelection.ocaml-migrate-parsetree;
      ocamlfind = opamSelection.ocamlfind or null;
      ppx_driver = opamSelection.ppx_driver;
      ppx_jane = opamSelection.ppx_jane;
      re2 = opamSelection.re2;
      textutils = opamSelection.textutils;
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
  name = "async_smtp-v0.10.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "async_smtp";
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
    sha256 = "1jmmwvd5v5n7ydywlb4id80r4wps4r7c9k0xjd0zcagkzdkqx79l";
    url = "https://ocaml.janestreet.com/ocaml-core/v0.10/files/async_smtp-v0.10.0.tar.gz";
  };
}

