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
      fd-send-recv = opamSelection.fd-send-recv;
      ipaddr = opamSelection.ipaddr;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      tuntap = opamSelection.tuntap;
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
  name = "mirari-0.9.7";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mirari";
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
    sha256 = "0419xx02q6nhcfiz4p6h4k1bkd67shgjdbb2pd2xxs26lzy1n57l";
    url = "https://github.com/mirage/mirari/archive/v0.9.7.tar.gz";
  };
}

