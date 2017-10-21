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
      async_shell = opamSelection.async_shell;
      async_ssl = opamSelection.async_ssl;
      camlp4 = opamSelection.camlp4;
      core = opamSelection.core;
      core_extended = opamSelection.core_extended;
      email_message = opamSelection.email_message;
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
  name = "async_smtp-113.00.00";
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
    sha256 = "11dslyg9kkp5d1z83r8jxb4y7h6kb56pri1i5jdhr7vjyzw21x2x";
    url = "https://ocaml.janestreet.com/ocaml-core/113.00/files/async_smtp-113.00.00.tar.gz";
  };
}

