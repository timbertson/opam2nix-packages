world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      asetmap = opamSelection.asetmap;
      asl = opamSelection.asl;
      astring = opamSelection.astring;
      cmdliner = opamSelection.cmdliner;
      conduit = opamSelection.conduit;
      cstruct = opamSelection.cstruct;
      datakit-server-9p = opamSelection.datakit-server-9p;
      fmt = opamSelection.fmt;
      git = opamSelection.git;
      hvsock = opamSelection.hvsock;
      irmin = opamSelection.irmin;
      irmin-git = opamSelection.irmin-git;
      irmin-mem = opamSelection.irmin-mem;
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
      protocol-9p-unix = opamSelection.protocol-9p-unix;
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
  name = "datakit-0.11.0";
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
    sha256 = "1djh5x2ikpa0l238a610iihx421d950wi7sypk2sincipzdw5gbc";
    url = "https://github.com/moby/datakit/releases/download/0.11.0/datakit-0.11.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

