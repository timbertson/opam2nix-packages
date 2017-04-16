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
      cstruct = opamSelection.cstruct;
      ipaddr = opamSelection.ipaddr;
      lwt = opamSelection.lwt;
      mtime = opamSelection.mtime;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
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
  name = "charrua-unix-0.6";
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
    sha256 = "18zrs2ijxavmjphrjmfsbdsvj7q9vzx762nn1jx5dmsbk6s42qig";
    url = "https://github.com/haesbaert/charrua-unix/releases/download/v0.6/charrua-unix-0.6.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

