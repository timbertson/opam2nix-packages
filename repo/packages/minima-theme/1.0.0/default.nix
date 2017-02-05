world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      bos = opamSelection.bos;
      fmt = opamSelection.fmt;
      lambdasoup = opamSelection.lambdasoup;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ptime = opamSelection.ptime;
      topkg = opamSelection.topkg;
      uri = opamSelection.uri;
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
  name = "minima-theme-1.0.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "minima-theme";
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
    sha256 = "1adk9q1gb9q5caj4077hzzl4ncdjdd93rrw75wpfnamg6hbbv74w";
    url = "https://github.com/avsm/ocaml-minima-theme/releases/download/v1.0.0/minima-theme-1.0.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

