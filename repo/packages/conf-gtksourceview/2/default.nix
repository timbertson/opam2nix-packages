world:
let
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.gtksourceview or null) (pkgs."libgtksourceview2.0-dev" or null)
        (pkgs.libxml2 or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      ocaml = opamSelection.ocaml;
    };
    opamSelection = world.opamSelection;
    pkgs = world.pkgs;
in
pkgs.stdenv.mkDerivation 
{
  buildInputs = inputs;
  buildPhase = "true";
  installPhase = "mkdir -p $out";
  name = "conf-gtksourceview-2";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "conf-gtksourceview";
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

