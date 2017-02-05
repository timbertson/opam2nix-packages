world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-bytes = opamSelection.base-bytes;
      base-threads = opamSelection.base-threads;
      base-unix = opamSelection.base-unix;
      camlp4 = opamSelection.camlp4;
      camlzip = opamSelection.camlzip;
      extlib = opamSelection.extlib or null;
      extlib-compat = opamSelection.extlib-compat or null;
      extunix = opamSelection.extunix;
      gperftools = opamSelection.gperftools or null;
      libevent = opamSelection.libevent;
      lwt = opamSelection.lwt;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ocamlnet = opamSelection.ocamlnet;
      ocurl = opamSelection.ocurl;
      ounit = opamSelection.ounit;
      pcre = opamSelection.pcre;
      xmlm = opamSelection.xmlm;
      yojson = opamSelection.yojson;
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
  name = "devkit-0.4";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "devkit";
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
    sha256 = "16sh29nybcz1n9j7a06w1h6c180x70965hi4gc6z07s66r30swv6";
    url = "https://github.com/ahrefs/devkit/archive/v0.4.tar.gz";
  };
}

