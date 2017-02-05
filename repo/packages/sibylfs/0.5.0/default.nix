world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-bytes = opamSelection.base-bytes;
      base-unix = opamSelection.base-unix;
      camlp4 = opamSelection.camlp4;
      cmdliner = opamSelection.cmdliner;
      cow = opamSelection.cow;
      cppo = opamSelection.cppo;
      fd-send-recv = opamSelection.fd-send-recv;
      menhir = opamSelection.menhir;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      sexplib = opamSelection.sexplib;
      sha = opamSelection.sha;
      sibylfs-lem = opamSelection.sibylfs-lem;
      unix-fcntl = opamSelection.unix-fcntl;
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
  name = "sibylfs-0.5.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "sibylfs";
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
    sha256 = "15kn2x17r294nvm8zz4czg6bnd58fc9sncw57z8jvb3v25xxag6v";
    url = "https://github.com/sibylfs/sibylfs_src/archive/0.5.0.tar.gz";
  };
}

