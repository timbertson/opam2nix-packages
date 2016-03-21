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
      io-page-xen = opamSelection.io-page-xen;
      ipaddr = opamSelection.ipaddr;
      mirage-clock-xen = opamSelection.mirage-clock-xen;
      mirage-net-xen = opamSelection.mirage-net-xen;
      mirage-types = opamSelection.mirage-types;
      mirage-xen = opamSelection.mirage-xen;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
    };
    opamSelection = world.opamSelection;
    pkgs = world.pkgs;
in
pkgs.stdenv.mkDerivation 
{
  buildInputs = inputs;
  buildPhase = "${opam2nix}/bin/opam2nix invoke build";
  configurePhase = "true";
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "mirage-tcpip-xen-0.9.5";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mirage-tcpip-xen";
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
    sha256 = "1y6a46182qdf9d0lqfbvb279vgwhrgvf824cyn45vr63bjsv2z19";
    url = "https://github.com/mirage/mirage-tcpip/archive/v0.9.5.tar.gz";
  };
}

