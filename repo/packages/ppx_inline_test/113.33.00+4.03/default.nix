world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ppx_core = opamSelection.ppx_core;
      ppx_driver = opamSelection.ppx_driver;
      ppx_tools = opamSelection.ppx_tools;
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
  name = "ppx_inline_test-113.33.00+4.03";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ppx_inline_test";
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
    sha256 = "1sw71wnwznia1spicilj4bzspgdk1dhp0j4hp57a9xmsscg44i4k";
    url = "https://ocaml.janestreet.com/ocaml-core/113.33/files/ppx_inline_test-113.33.00+4.03.tar.gz";
  };
}

