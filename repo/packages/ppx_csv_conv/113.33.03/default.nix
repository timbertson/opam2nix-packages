world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      js-build-tools = opamSelection.js-build-tools;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ppx_conv_func = opamSelection.ppx_conv_func;
      ppx_core = opamSelection.ppx_core;
      ppx_tools = opamSelection.ppx_tools;
      ppx_type_conv = opamSelection.ppx_type_conv;
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
  name = "ppx_csv_conv-113.33.03";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ppx_csv_conv";
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
    sha256 = "1sjwja5cm0jd8z46ngc6gx1gwnflk1s3s4smzc8x3127zcvj21f5";
    url = "https://ocaml.janestreet.com/ocaml-core/113.33/files/ppx_csv_conv-113.33.03.tar.gz";
  };
}

