world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      bin_prot = opamSelection.bin_prot;
      core_kernel = opamSelection.core_kernel;
      jbuilder = opamSelection.jbuilder;
      ocaml = opamSelection.ocaml;
      ocaml-migrate-parsetree = opamSelection.ocaml-migrate-parsetree;
      ocamlfind = opamSelection.ocamlfind or null;
      ppx_bin_prot = opamSelection.ppx_bin_prot;
      ppx_driver = opamSelection.ppx_driver;
      ppx_jane = opamSelection.ppx_jane;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      ppx_sexp_value = opamSelection.ppx_sexp_value;
      ppx_type_conv = opamSelection.ppx_type_conv;
      ppx_typerep_conv = opamSelection.ppx_typerep_conv;
      sexplib = opamSelection.sexplib;
      typerep = opamSelection.typerep;
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
  name = "typerep_extended-v0.9.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "typerep_extended";
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
    sha256 = "0bpz6fnldaihy4fbi02ycqz3881qhw7m5lmw64ia8d4g3c9xl6r0";
    url = "https://ocaml.janestreet.com/ocaml-core/v0.9/files/typerep_extended-v0.9.0.tar.gz";
  };
}

