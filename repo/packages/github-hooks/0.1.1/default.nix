world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-unix = opamSelection.base-unix;
      cohttp = opamSelection.cohttp;
      fmt = opamSelection.fmt;
      github = opamSelection.github;
      hex = opamSelection.hex;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      nocrypto = opamSelection.nocrypto;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      topkg = opamSelection.topkg;
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
  name = "github-hooks-0.1.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "github-hooks";
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
    sha256 = "1f33ix2xrk9qqvzzy9xz4dnxwd04n91xp52bp4symm862y9jlb7c";
    url = "https://github.com/dsheets/ocaml-github-hooks/releases/download/0.1.1/github-hooks-0.1.1.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

