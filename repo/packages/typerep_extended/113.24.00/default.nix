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
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ppx_bin_prot = opamSelection.ppx_bin_prot;
      ppx_driver = opamSelection.ppx_driver;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
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
  name = "typerep_extended-113.24.00";
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
    sha256 = "1f01ggvv4pkxjnw70gwhr06hcbmn3c4i59nm00gpn50wmzklc0kw";
    url = "https://ocaml.janestreet.com/ocaml-core/113.24/files/typerep_extended-113.24.00.tar.gz";
  };
}

