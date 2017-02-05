world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      astring = opamSelection.astring;
      channel = opamSelection.channel;
      cmdliner = opamSelection.cmdliner;
      cstruct = opamSelection.cstruct;
      dns = opamSelection.dns;
      fmt = opamSelection.fmt;
      ipaddr = opamSelection.ipaddr;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      mirage-flow = opamSelection.mirage-flow;
      mtime = opamSelection.mtime;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ppx_tools = opamSelection.ppx_tools;
      result = opamSelection.result;
      rresult = opamSelection.rresult;
      sexplib = opamSelection.sexplib;
      topkg = opamSelection.topkg;
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
  name = "dns-forward-0.7.2";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "dns-forward";
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
    sha256 = "0gqbni4jgb5v605fhafqc0kcj6xg38d1znjr7h6vm7nr3bnjf9dm";
    url = "https://github.com/djs55/ocaml-dns-forward/archive/v0.7.2.tar.gz";
  };
}

