world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      asl = opamSelection.asl;
      cmdliner = opamSelection.cmdliner;
      conduit = opamSelection.conduit;
      datakit-client = opamSelection.datakit-client;
      datakit-github = opamSelection.datakit-github;
      datakit-server = opamSelection.datakit-server;
      fmt = opamSelection.fmt;
      github = opamSelection.github;
      github-hooks = opamSelection.github-hooks;
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
  name = "datakit-bridge-github-0.10.1";
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
    sha256 = "1fmf5x2yzyb5hf4sk3yb642nd5i8g67m9sgclnnils4lw9l39ax9";
    url = "https://github.com/moby/datakit/releases/download/0.10.1/datakit-0.10.1.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

