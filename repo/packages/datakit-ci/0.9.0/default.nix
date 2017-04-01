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
      astring = opamSelection.astring;
      channel = opamSelection.channel;
      cmdliner = opamSelection.cmdliner;
      conduit = opamSelection.conduit;
      crunch = opamSelection.crunch;
      datakit-client = opamSelection.datakit-client;
      datakit-github = opamSelection.datakit-github;
      fmt = opamSelection.fmt;
      github = opamSelection.github;
      io-page = opamSelection.io-page;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      multipart-form-data = opamSelection.multipart-form-data;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      pbkdf = opamSelection.pbkdf;
      ppx_deriving = opamSelection.ppx_deriving;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      prometheus-app = opamSelection.prometheus-app;
      protocol-9p = opamSelection.protocol-9p;
      redis = opamSelection.redis;
      session = opamSelection.session;
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
  name = "datakit-ci-0.9.0";
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
    sha256 = "08q2kifg66bh8fnf4971gvlw5c9r78zvq6l9r7x0ng1q9ylkx7d2";
    url = "https://github.com/docker/datakit/releases/download/0.9.0/datakit-0.9.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

