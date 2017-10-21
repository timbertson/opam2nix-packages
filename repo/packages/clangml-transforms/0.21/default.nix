world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      batteries = opamSelection.batteries;
      clangml = opamSelection.clangml;
      deriving = opamSelection.deriving;
      dolog = opamSelection.dolog;
      obuild = opamSelection.obuild;
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
  name = "clangml-transforms-0.21";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "clangml-transforms";
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
    sha256 = "1k2w813gzqw02mfqbkvsf5w92vjrg0fzva0r0d9ir4998z4bhhs1";
    url = "https://github.com/Antique-team/clangml-transforms/archive/v0.21.tar.gz";
  };
}

