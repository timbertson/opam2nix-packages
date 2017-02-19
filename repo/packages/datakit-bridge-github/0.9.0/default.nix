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
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      mtime = opamSelection.mtime;
      nocrypto = opamSelection.nocrypto;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      prometheus-app = opamSelection.prometheus-app;
      protocol-9p = opamSelection.protocol-9p;
      topkg = opamSelection.topkg;
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
  name = "datakit-bridge-github-0.9.0";
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
    sha256 = "08q2kifg66bh8fnf4971gvlw5c9r78zvq6l9r7x0ng1q9ylkx7d2";
    url = "https://github.com/docker/datakit/releases/download/0.9.0/datakit-0.9.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

