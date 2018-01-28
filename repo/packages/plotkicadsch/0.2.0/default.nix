world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base64 = opamSelection.base64;
      cmdliner = opamSelection.cmdliner;
      core_kernel = opamSelection.core_kernel;
      git = opamSelection.git;
      git-unix = opamSelection.git-unix;
      jbuilder = opamSelection.jbuilder;
      kicadsch = opamSelection.kicadsch;
      lwt = opamSelection.lwt;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      patience_diff = opamSelection.patience_diff;
      sha = opamSelection.sha;
      tyxml = opamSelection.tyxml;
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
  name = "plotkicadsch-0.2.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "plotkicadsch";
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
    sha256 = "0l0gsxjzlc9379di8vjf78qwz80y1qh7iq7cxc00vhh55d26phgi";
    url = "https://github.com/jnavila/plotkicadsch/releases/download/v0.2.0/plotkicadsch-0.2.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

