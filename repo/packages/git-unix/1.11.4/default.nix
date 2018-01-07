world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      alcotest = opamSelection.alcotest or null;
      base-unix = opamSelection.base-unix;
      cmdliner = opamSelection.cmdliner;
      cohttp-lwt-unix = opamSelection.cohttp-lwt-unix;
      conduit-lwt-unix = opamSelection.conduit-lwt-unix;
      git-http = opamSelection.git-http;
      io-page = opamSelection.io-page or null;
      jbuilder = opamSelection.jbuilder;
      logs = opamSelection.logs;
      mtime = opamSelection.mtime;
      nocrypto = opamSelection.nocrypto;
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
  name = "git-unix-1.11.4";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "git-unix";
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
    sha256 = "03gpxpgcgn5k7yc52j4nq3fbh4fn5wyak5wr339spb38353bwn35";
    url = "https://github.com/mirage/ocaml-git/releases/download/1.11.4/git-1.11.4.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

