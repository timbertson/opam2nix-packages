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
  name = "ppx_xml_conv-113.24.00";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ppx_xml_conv";
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
    sha256 = "0kb6dzmdrk9wgm02imn80hdd6559m6zi426nhd7xqf0h1l3zk6x4";
    url = "https://ocaml.janestreet.com/ocaml-core/113.24/files/ppx_xml_conv-113.24.00.tar.gz";
  };
}

