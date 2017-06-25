world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cstruct = opamSelection.cstruct;
      io-page = opamSelection.io-page;
      io-page-xen = opamSelection.io-page-xen;
      ipaddr = opamSelection.ipaddr;
      jbuilder = opamSelection.jbuilder;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      mirage-net-lwt = opamSelection.mirage-net-lwt;
      mirage-profile = opamSelection.mirage-profile;
      mirage-xen = opamSelection.mirage-xen;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ppx_cstruct = opamSelection.ppx_cstruct;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      ppx_tools = opamSelection.ppx_tools;
      result = opamSelection.result;
      sexplib = opamSelection.sexplib;
      shared-memory-ring = opamSelection.shared-memory-ring;
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
  name = "netchannel-1.7.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "netchannel";
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
    sha256 = "1g3lp0pfdc2rv3m0czyl9b55p2z4zrxy4pjcd24f2qrb6dbikwg8";
    url = "https://github.com/mirage/mirage-net-xen/releases/download/1.7.1/mirage-net-xen-1.7.1.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

