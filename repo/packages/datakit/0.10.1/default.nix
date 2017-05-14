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
      camlzip = opamSelection.camlzip;
      cmdliner = opamSelection.cmdliner;
      conduit = opamSelection.conduit;
      cstruct = opamSelection.cstruct;
      datakit-server = opamSelection.datakit-server;
      fmt = opamSelection.fmt;
      git = opamSelection.git;
      hvsock = opamSelection.hvsock;
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
  name = "datakit-0.10.1";
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
    sha256 = "1fmf5x2yzyb5hf4sk3yb642nd5i8g67m9sgclnnils4lw9l39ax9";
    url = "https://github.com/moby/datakit/releases/download/0.10.1/datakit-0.10.1.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

