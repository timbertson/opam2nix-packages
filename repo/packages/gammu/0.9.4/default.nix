world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.epel-release or null) (pkgs.gammu or null)
        (pkgs.gammu-dev or null) (pkgs.gammu-devel or null)
        (pkgs.lib64gammu-devel or null) (pkgs.libgammu-dev or null)
        (pkgs.pkg-config or null) (pkgs.pkgconf or null)
        (pkgs.pkgconfig or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base = opamSelection.base;
      base-unix = opamSelection.base-unix;
      configurator = opamSelection.configurator;
      jbuilder = opamSelection.jbuilder;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      stdio = opamSelection.stdio;
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
  name = "gammu-0.9.4";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "gammu";
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
    sha256 = "0kp6jcgbj9hq0rgi4sz90p31agjsm6ya9f9sjm6z9jskgjmb13f2";
    url = "https://github.com/Chris00/ocaml-gammu/releases/download/0.9.4/gammu-0.9.4.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

