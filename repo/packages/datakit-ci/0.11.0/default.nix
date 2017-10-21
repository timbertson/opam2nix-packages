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
      cmdliner = opamSelection.cmdliner;
      conduit = opamSelection.conduit;
      crunch = opamSelection.crunch;
      datakit-client = opamSelection.datakit-client;
      datakit-client-9p = opamSelection.datakit-client-9p;
      datakit-github = opamSelection.datakit-github;
      fmt = opamSelection.fmt;
      github-unix = opamSelection.github-unix;
      io-page = opamSelection.io-page;
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
  name = "datakit-ci-0.11.0";
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
    sha256 = "1djh5x2ikpa0l238a610iihx421d950wi7sypk2sincipzdw5gbc";
    url = "https://github.com/moby/datakit/releases/download/0.11.0/datakit-0.11.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

