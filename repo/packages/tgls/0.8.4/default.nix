world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-bytes = opamSelection.base-bytes;
      ctypes = opamSelection.ctypes;
      ctypes-foreign = opamSelection.ctypes-foreign;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
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
  name = "tgls-0.8.4";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "tgls";
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
    sha256 = "1aa0qwgmc3l1j7fvncarxz0fmjbzn54b3v2fv7iivxhsqa2k02dh";
    url = "http://erratique.ch/software/tgls/releases/tgls-0.8.4.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

