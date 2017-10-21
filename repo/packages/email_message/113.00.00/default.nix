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
      camlp4 = opamSelection.camlp4;
      core = opamSelection.core;
      core_extended = opamSelection.core_extended;
      cryptokit = opamSelection.cryptokit;
      fieldslib = opamSelection.fieldslib;
      magic-mime = opamSelection.magic-mime;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind or null;
      pa_ounit = opamSelection.pa_ounit;
      pa_test = opamSelection.pa_test;
      re2 = opamSelection.re2;
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
  name = "email_message-113.00.00";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "email_message";
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
    sha256 = "161d5y32n9l4rp8z4gdpggn0lx2fyl0mb7j80j1yc7ws7547kzhb";
    url = "https://ocaml.janestreet.com/ocaml-core/113.00/files/email_message-113.00.00.tar.gz";
  };
}

