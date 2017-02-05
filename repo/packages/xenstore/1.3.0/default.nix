world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.libxen-dev or null) (pkgs.uuid-dev or null)
        (pkgs.xen-devel or null) (pkgs.xen-dom0-libs-devel or null)
        (pkgs.xen-libs-devel or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      camlp4 = opamSelection.camlp4;
      cstruct = opamSelection.cstruct;
      lwt = opamSelection.lwt;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ounit = opamSelection.ounit;
      ppx_tools = opamSelection.ppx_tools;
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
  name = "xenstore-1.3.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "xenstore";
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
    sha256 = "1hplnhm1yhnqjd01n1sw0ik4x3p0lifjin61xzscw265kdg67awk";
    url = "https://github.com/mirage/ocaml-xenstore/archive/v1.3.0.tar.gz";
  };
}

