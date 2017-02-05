world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base64 = opamSelection.base64;
      cryptokit = opamSelection.cryptokit;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ocurl = opamSelection.ocurl;
      omake = opamSelection.omake;
      ppx_meta_conv = opamSelection.ppx_meta_conv;
      ppx_monadic = opamSelection.ppx_monadic;
      ppx_orakuda = opamSelection.ppx_orakuda;
      spotlib = opamSelection.spotlib;
      tiny_json = opamSelection.tiny_json;
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
  name = "ocamltter-4.1.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ocamltter";
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
    sha256 = "1wq1agbkwgflp69f3njjwddgmj310r3xkjin1nzdmilfbdwpx5ys";
    url = "https://github.com/yoshihiro503/ocamltter/archive/4.1.1.tar.gz";
  };
}

