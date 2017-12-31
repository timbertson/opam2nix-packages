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
      csv = opamSelection.csv;
      dockerfile-opam = opamSelection.dockerfile-opam;
      fmt = opamSelection.fmt;
      jbuilder = opamSelection.jbuilder;
      logs = opamSelection.logs;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
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
  name = "dockerfile-cmd-4.0.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "dockerfile-cmd";
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
    sha256 = "00q2qxi3hrn02vc47z03l9chv6a1g4qqhj25zfxs19anbhg65g8z";
    url = "https://github.com/avsm/ocaml-dockerfile/releases/download/v4.0.0/dockerfile-4.0.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

