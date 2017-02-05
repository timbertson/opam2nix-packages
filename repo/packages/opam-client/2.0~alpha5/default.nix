world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cmdliner = opamSelection.cmdliner;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      opam-solver = opamSelection.opam-solver;
      opam-state = opamSelection.opam-state;
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
  name = "opam-client-2.0~alpha5";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "opam-client";
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
    sha256 = "1fqz5yxw8s2d0dmw15ggpxgyw63riwyzgy4z6lgahpajpn520akq";
    url = "https://github.com/ocaml/opam/archive/2.0-alpha5+1.tar.gz";
  };
}

