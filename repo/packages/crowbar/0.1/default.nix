world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      afl-persistent = opamSelection.afl-persistent;
      calendar = opamSelection.calendar or null;
      cmdliner = opamSelection.cmdliner;
      fpath = opamSelection.fpath or null;
      jbuilder = opamSelection.jbuilder;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ocplib-endian = opamSelection.ocplib-endian;
      uucp = opamSelection.uucp or null;
      uunf = opamSelection.uunf or null;
      uutf = opamSelection.uutf or null;
      xmldiff = opamSelection.xmldiff or null;
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
  name = "crowbar-0.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "crowbar";
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
    sha256 = "0bhs8yc9yidgp1x7xbgrc1bp5b3w7iv85qd2y4x4bvg0qb6pr7gg";
    url = "https://github.com/stedolan/crowbar/archive/v0.1.tar.gz";
  };
}

