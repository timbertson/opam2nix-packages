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
  name = "clangml-transforms-0.20";
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
    sha256 = "08b64h4kn5ij0yxwbxxfgvqmifg734r4n1720jqxjynck70lcn6z";
    url = "https://github.com/Antique-team/clangml-transforms/archive/v0.20.tar.gz";
  };
}

