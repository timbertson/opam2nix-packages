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
      cmdliner = opamSelection.cmdliner;
      conduit = opamSelection.conduit;
      git-http = opamSelection.git-http;
      jbuilder = opamSelection.jbuilder;
      logs = opamSelection.logs;
      mtime = opamSelection.mtime;
      nocrypto = opamSelection.nocrypto;
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
  name = "git-unix-1.11.0";
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
    sha256 = "0x7bc43z3rg0z1y1xxmfk9in5gszhc9b076b4lh034ifack2inlh";
    url = "https://github.com/mirage/ocaml-git/releases/download/1.11.0/git-1.11.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

