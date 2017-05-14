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
      datakit-github = opamSelection.datakit-github;
      fmt = opamSelection.fmt;
      github = opamSelection.github;
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
  name = "datakit-ci-0.10.1";
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
    sha256 = "1fmf5x2yzyb5hf4sk3yb642nd5i8g67m9sgclnnils4lw9l39ax9";
    url = "https://github.com/moby/datakit/releases/download/0.10.1/datakit-0.10.1.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

