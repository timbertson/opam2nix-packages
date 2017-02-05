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
      cmdliner = opamSelection.cmdliner;
      fmt = opamSelection.fmt;
      logs = opamSelection.logs;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      opam-lib = opamSelection.opam-lib;
      result = opamSelection.result;
      topkg = opamSelection.topkg;
      webbrowser = opamSelection.webbrowser;
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
  name = "topkg-care-0.8.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "topkg-care";
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
    sha256 = "18rrh6fmf708z7dd30amljmcgaypj3kk49jrmrj68r4wnw8004j8";
    url = "http://erratique.ch/software/topkg/releases/topkg-0.8.1.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

