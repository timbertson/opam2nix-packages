world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
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
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "edn-0.1.2-1-g09b142a";
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
    sha256 = "10fja6qyiwd1jbc2pgjs7p68fgdspjk9ycmqry2ls93af9cz5njm";
    url = "https://github.com/prepor/ocaml-edn/releases/download/v0.1.2-1-g09b142a/edn-0.1.2-1-g09b142a.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

