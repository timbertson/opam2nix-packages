world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cmdliner = opamSelection.cmdliner;
      cstruct = opamSelection.cstruct;
      io-page = opamSelection.io-page;
      jbuilder = opamSelection.jbuilder;
      lwt = opamSelection.lwt;
      mirage-flow-lwt = opamSelection.mirage-flow-lwt;
      mirage-xen = opamSelection.mirage-xen;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ppx_cstruct = opamSelection.ppx_cstruct;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      ppx_tools = opamSelection.ppx_tools;
      result = opamSelection.result;
      sexplib = opamSelection.sexplib;
      vchan = opamSelection.vchan;
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
  name = "vchan-xen-3.0.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "vchan-xen";
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
    sha256 = "090m36hrwpkpy9v9lfhx70ldl1yi4db79pqdym4g425krgxv26bj";
    url = "https://github.com/mirage/ocaml-vchan/releases/download/3.0.0/vchan-3.0.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

