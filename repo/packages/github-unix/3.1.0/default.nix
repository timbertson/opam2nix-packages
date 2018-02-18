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
      cohttp-lwt-unix = opamSelection.cohttp-lwt-unix;
      github = opamSelection.github;
      jbuilder = opamSelection.jbuilder;
      lambda-term = opamSelection.lambda-term;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      stringext = opamSelection.stringext;
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
  name = "github-unix-3.1.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "github-unix";
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
    sha256 = "1ygq5g5d6dm0s9brxgdy8a5g7z0iz22yvmykkr34rb96v4w2cx4b";
    url = "https://github.com/mirage/ocaml-github/releases/download/3.1.0/github-3.1.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

