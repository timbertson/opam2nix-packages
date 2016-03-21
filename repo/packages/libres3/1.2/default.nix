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
      base-unix = opamSelection.base-unix;
      cryptokit = opamSelection.cryptokit;
      dns = opamSelection.dns;
      jsonm = opamSelection.jsonm;
      lwt = opamSelection.lwt;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ocamlnet = opamSelection.ocamlnet;
      ocsigenserver = opamSelection.ocsigenserver;
      ounit = opamSelection.ounit;
      re = opamSelection.re;
      sqlite3 = opamSelection.sqlite3;
      ssl = opamSelection.ssl;
      xmlm = opamSelection.xmlm;
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
  name = "libres3-1.2";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "libres3";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  postUnpack = "cp -r ${./files}/* \"$sourceRoot/\"";
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "1n1w1sjd7w2gl6dkhwiwgg1zkycf3byg6h51gfv6a3ly7dm1j0yr";
    url = "http://cdn.skylable.com/source/libres3-1.2.tar.gz";
  };
}

