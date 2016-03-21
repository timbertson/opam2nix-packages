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
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ocamlnet = opamSelection.ocamlnet;
      pcre = opamSelection.pcre;
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
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "ocsigenserver-2.6";
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
    sha256 = "0638xvlr0sssvjarmdwhgh7vbgdx8wiyjwq73w1bkjfwl7qm21zp";
    url = "https://github.com/ocsigen/ocsigenserver/archive/2.6.tar.gz";
  };
}

