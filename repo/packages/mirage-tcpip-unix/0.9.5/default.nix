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
      io-page-unix = opamSelection.io-page-unix;
      ipaddr = opamSelection.ipaddr;
      mirage-clock-unix = opamSelection.mirage-clock-unix;
      mirage-net-unix = opamSelection.mirage-net-unix;
      mirage-types = opamSelection.mirage-types;
      mirage-unix = opamSelection.mirage-unix;
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
  name = "mirage-tcpip-unix-0.9.5";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mirage-tcpip-unix";
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

