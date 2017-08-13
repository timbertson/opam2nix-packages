world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      charrua-core = opamSelection.charrua-core;
      cmdliner = opamSelection.cmdliner;
      cstruct-unix = opamSelection.cstruct-unix;
      jbuilder = opamSelection.jbuilder;
      lwt = opamSelection.lwt;
      mtime = opamSelection.mtime;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      rawlink = opamSelection.rawlink;
      tuntap = opamSelection.tuntap;
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
  name = "charrua-unix-0.9";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "charrua-unix";
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
    sha256 = "0m6l4zjipar4n1p6ap4hp7rrmqg0mxfbp9b49h6fn55wcvkr6fy7";
    url = "https://github.com/mirage/charrua-core/releases/download/v0.9/charrua-core-0.9.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

