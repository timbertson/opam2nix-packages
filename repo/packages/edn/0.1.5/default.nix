world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cconv = opamSelection.cconv;
      menhir = opamSelection.menhir;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      topkg = opamSelection.topkg;
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
  name = "edn-0.1.5";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "edn";
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
    sha256 = "1y86367243r7hyrbka5ylmiklv2d2x7qam5cncnpaqq2rgyrrx8h";
    url = "https://github.com/prepor/ocaml-edn/releases/download/v0.1.5/edn-0.1.5.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

