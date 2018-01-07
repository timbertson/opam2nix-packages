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
      cohttp-mirage = opamSelection.cohttp-mirage;
      git = opamSelection.git;
      git-http = opamSelection.git-http;
      io-page = opamSelection.io-page or null;
      jbuilder = opamSelection.jbuilder;
      mirage-channel-lwt = opamSelection.mirage-channel-lwt;
      mirage-conduit = opamSelection.mirage-conduit;
      mirage-flow-lwt = opamSelection.mirage-flow-lwt;
      mirage-fs-lwt = opamSelection.mirage-fs-lwt;
      mirage-fs-unix = opamSelection.mirage-fs-unix or null;
      mtime = opamSelection.mtime or null;
      nocrypto = opamSelection.nocrypto or null;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      result = opamSelection.result;
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
  name = "git-mirage-1.11.4";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "git-mirage";
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

