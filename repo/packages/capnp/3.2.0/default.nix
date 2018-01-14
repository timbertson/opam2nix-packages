world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      conf-capnproto = opamSelection.conf-capnproto or null;
      core = opamSelection.core or null;
      core_kernel = opamSelection.core_kernel;
      extunix = opamSelection.extunix;
      jbuilder = opamSelection.jbuilder;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ocplib-endian = opamSelection.ocplib-endian;
      ounit = opamSelection.ounit or null;
      res = opamSelection.res;
      result = opamSelection.result;
      uint = opamSelection.uint;
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
  name = "capnp-3.2.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "capnp";
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
    sha256 = "174g1r93wy2j1q3mcxiz3jr8g2h6kp0jybhxn3fld8b9k8970x96";
    url = "https://github.com/capnproto/capnp-ocaml/releases/download/v3.2.0/capnp-3.2.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

