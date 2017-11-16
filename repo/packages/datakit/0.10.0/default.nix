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
      asetmap = opamSelection.asetmap;
      asl = opamSelection.asl;
      astring = opamSelection.astring;
      camlzip = opamSelection.camlzip;
      cmdliner = opamSelection.cmdliner;
      conduit = opamSelection.conduit;
      cstruct = opamSelection.cstruct;
      datakit-client = opamSelection.datakit-client or null;
      datakit-github = opamSelection.datakit-github or null;
      datakit-server = opamSelection.datakit-server;
      fmt = opamSelection.fmt;
      git = opamSelection.git;
      hvsock = opamSelection.hvsock;
      io-page = opamSelection.io-page or null;
      io-page-unix = opamSelection.io-page-unix or null;
      irmin = opamSelection.irmin;
      irmin-git = opamSelection.irmin-git;
      irmin-watcher = opamSelection.irmin-watcher;
      jbuilder = opamSelection.jbuilder;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      mirage-flow = opamSelection.mirage-flow;
      mtime = opamSelection.mtime;
      named-pipe = opamSelection.named-pipe;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      prometheus-app = opamSelection.prometheus-app;
      protocol-9p = opamSelection.protocol-9p;
      result = opamSelection.result;
      rresult = opamSelection.rresult;
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
  name = "datakit-0.10.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "datakit";
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
    sha256 = "0fkzpll4bbmwr21lk1xwzhnac9y8c3fwh83j0m73npcjassb1yqb";
    url = "https://github.com/moby/datakit/releases/download/0.10.0/datakit-0.10.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

