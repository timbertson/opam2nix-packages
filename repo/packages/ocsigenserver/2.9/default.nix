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
      camlp4 = opamSelection.camlp4;
      camlzip = opamSelection.camlzip or null;
      cryptokit = opamSelection.cryptokit;
      dbm = opamSelection.dbm or null;
      ipaddr = opamSelection.ipaddr;
      lwt = opamSelection.lwt;
      lwt_react = opamSelection.lwt_react;
      lwt_ssl = opamSelection.lwt_ssl;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ocamlnet = opamSelection.ocamlnet;
      pcre = opamSelection.pcre;
      pgocaml = opamSelection.pgocaml or null;
      react = opamSelection.react;
      sqlite3 = opamSelection.sqlite3 or null;
      ssl = opamSelection.ssl;
      tyxml = opamSelection.tyxml;
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
  name = "ocsigenserver-2.9";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ocsigenserver";
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
    sha256 = "0na3qa4h89f2wv31li63nfpg4151d0g8fply0bq59j3bhpyc85nd";
    url = "https://github.com/ocsigen/ocsigenserver/archive/2.9.tar.gz";
  };
}

