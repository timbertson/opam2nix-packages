world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      asetmap = opamSelection.asetmap;
      base-unix = opamSelection.base-unix;
      bos = opamSelection.bos;
      cmdliner = opamSelection.cmdliner;
      fmt = opamSelection.fmt;
      fpath = opamSelection.fpath;
      logs = opamSelection.logs;
      mtime = opamSelection.mtime;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      opam-lib = opamSelection.opam-lib;
      rresult = opamSelection.rresult;
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
  name = "odig-0.0.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "odig";
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
    sha256 = "1x13rc2gbvkqq36qyzgvml0sxc3dxykkcr9xfi8y034bcn23qk0v";
    url = "http://erratique.ch/software/odig/releases/odig-0.0.1.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

