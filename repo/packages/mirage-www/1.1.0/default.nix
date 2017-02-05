world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cohttp = opamSelection.cohttp;
      cow = opamSelection.cow;
      cowabloga = opamSelection.cowabloga;
      crunch = opamSelection.crunch;
      cstruct = opamSelection.cstruct;
      fat-filesystem = opamSelection.fat-filesystem;
      ipaddr = opamSelection.ipaddr;
      lwt = opamSelection.lwt;
      mirage = opamSelection.mirage;
      mirage-block-unix = opamSelection.mirage-block-unix;
      mirage-console-unix = opamSelection.mirage-console-unix;
      mirage-fs-unix = opamSelection.mirage-fs-unix;
      mirage-http = opamSelection.mirage-http;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ssl = opamSelection.ssl;
      tcpip = opamSelection.tcpip;
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
  name = "mirage-www-1.1.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "mirage-www";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  prePatch = "cp -r ${./files}/* ./";
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "08aiw1dafwsiaird52701s9b8mzhs162q8m6f5kzh2ayhxlj0rjw";
    url = "https://github.com/mirage/mirage-www/archive/1.1.0.tar.gz";
  };
}

