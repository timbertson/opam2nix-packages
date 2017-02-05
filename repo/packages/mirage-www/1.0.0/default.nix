world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cow = opamSelection.cow;
      cowabloga = opamSelection.cowabloga;
      mirage = opamSelection.mirage;
      mirage-console-unix = opamSelection.mirage-console-unix;
      mirage-fs-unix = opamSelection.mirage-fs-unix;
      mirage-http-unix = opamSelection.mirage-http-unix;
      mirage-tcpip-unix = opamSelection.mirage-tcpip-unix;
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
  name = "mirage-www-1.0.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "mirage-www";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  prePatch = "cp -r ${./files}/* ./";
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "0i0b2dsh1qb47nw20w80hc8czgg2fikhw44iq419nc1wwl3vp2p1";
    url = "https://github.com/mirage/mirage-www/archive/1.0.0.tar.gz";
  };
}

