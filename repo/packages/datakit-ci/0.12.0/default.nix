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
      astring = opamSelection.astring;
      cmdliner = opamSelection.cmdliner;
      conduit-lwt-unix = opamSelection.conduit-lwt-unix;
      crunch = opamSelection.crunch;
      datakit = opamSelection.datakit or null;
      datakit-client = opamSelection.datakit-client;
      datakit-client-9p = opamSelection.datakit-client-9p;
      datakit-github = opamSelection.datakit-github;
      fmt = opamSelection.fmt;
      github-unix = opamSelection.github-unix;
      io-page = opamSelection.io-page;
      irmin-unix = opamSelection.irmin-unix or null;
      jbuilder = opamSelection.jbuilder;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      multipart-form-data = opamSelection.multipart-form-data;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      pbkdf = opamSelection.pbkdf;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      prometheus-app = opamSelection.prometheus-app;
      protocol-9p-unix = opamSelection.protocol-9p-unix;
      redis-lwt = opamSelection.redis-lwt;
      session-redis-lwt = opamSelection.session-redis-lwt;
      session-webmachine = opamSelection.session-webmachine;
      tls = opamSelection.tls;
      tyxml = opamSelection.tyxml;
      webmachine = opamSelection.webmachine;
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
  name = "datakit-ci-0.12.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "datakit-ci";
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

