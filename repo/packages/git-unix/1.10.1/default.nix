world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-unix = opamSelection.base-unix;
      camlzip = opamSelection.camlzip;
      cmdliner = opamSelection.cmdliner;
      conduit = opamSelection.conduit;
      git = opamSelection.git;
      git-http = opamSelection.git-http;
      mtime = opamSelection.mtime;
      nocrypto = opamSelection.nocrypto;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
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
  name = "git-unix-1.10.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "git-unix";
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
    sha256 = "0n5g1d3pqq24d0zcdp3qygzvn2dzss3d5fzf0zrvwhjy8fa9kbyb";
    url = "https://github.com/mirage/ocaml-git/releases/download/1.10.1/git-1.10.1.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

