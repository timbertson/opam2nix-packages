world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-threads = opamSelection.base-threads;
      cmdliner = opamSelection.cmdliner;
      cohttp = opamSelection.cohttp;
      cstruct = opamSelection.cstruct;
      io-page-unix = opamSelection.io-page-unix;
      lwt = opamSelection.lwt;
      nbd = opamSelection.nbd;
      oasis = opamSelection.oasis;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      re = opamSelection.re;
      sha = opamSelection.sha;
      ssl = opamSelection.ssl;
      tar-format = opamSelection.tar-format;
      uri = opamSelection.uri;
      vhd-format = opamSelection.vhd-format;
      xapi-idl = opamSelection.xapi-idl;
      xapi-tapctl = opamSelection.xapi-tapctl;
      xenstore = opamSelection.xenstore;
      xenstore_transport = opamSelection.xenstore_transport;
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
  name = "vhd-tool-0.12.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "vhd-tool";
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
    sha256 = "1fja59zsjl26kp2wp75rr498pk1r699c8zhmrww7gbw71hc1l5ny";
    url = "https://github.com/xapi-project/vhd-tool/archive/v0.12.0.tar.gz";
  };
}

