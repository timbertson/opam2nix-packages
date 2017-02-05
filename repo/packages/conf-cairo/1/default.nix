world:
let
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.cairo or null) (pkgs.cairo-devel or null)
        (pkgs."graphics/cairo" or null) (pkgs.libcairo-devel or null)
        (pkgs.libcairo2-dev or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      conf-pkg-config = opamSelection.conf-pkg-config;
      ocaml = opamSelection.ocaml;
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
  name = "conf-cairo-1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "conf-cairo";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  propagatedBuildInputs = inputs;
  unpackPhase = "true";
}

