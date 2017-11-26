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
      asl = opamSelection.asl;
      cmdliner = opamSelection.cmdliner;
      datakit = opamSelection.datakit or null;
      datakit-client = opamSelection.datakit-client;
      datakit-client-9p = opamSelection.datakit-client-9p;
      datakit-client-git = opamSelection.datakit-client-git;
      datakit-github = opamSelection.datakit-github;
      fmt = opamSelection.fmt;
      github = opamSelection.github;
      github-hooks-unix = opamSelection.github-hooks-unix;
      hex = opamSelection.hex;
      hvsock = opamSelection.hvsock;
      jbuilder = opamSelection.jbuilder;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      mtime = opamSelection.mtime;
      nocrypto = opamSelection.nocrypto;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      prometheus-app = opamSelection.prometheus-app;
      protocol-9p-unix = opamSelection.protocol-9p-unix;
      uri = opamSelection.uri;
      win-eventlog = opamSelection.win-eventlog;
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
  name = "datakit-bridge-github-0.12.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "datakit-bridge-github";
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
    sha256 = "1lbm38x6fsiakzswmv4y781ncmigd8yrla2dj1glwqn7mizm2gqg";
    url = "https://github.com/moby/datakit/releases/download/0.12.0/datakit-0.12.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

