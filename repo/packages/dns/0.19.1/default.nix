world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      async = opamSelection.async or null;
      base-bytes = opamSelection.base-bytes;
      base64 = opamSelection.base64;
      cmdliner = opamSelection.cmdliner or null;
      cstruct = opamSelection.cstruct;
      duration = opamSelection.duration or null;
      hashcons = opamSelection.hashcons;
      io-page = opamSelection.io-page or null;
      ipaddr = opamSelection.ipaddr;
      lwt = opamSelection.lwt or null;
      mirage-kv-lwt = opamSelection.mirage-kv-lwt or null;
      mirage-profile = opamSelection.mirage-profile or null;
      mirage-stack-lwt = opamSelection.mirage-stack-lwt or null;
      mirage-time-lwt = opamSelection.mirage-time-lwt or null;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ppx_tools = opamSelection.ppx_tools;
      re = opamSelection.re;
      result = opamSelection.result;
      topkg = opamSelection.topkg;
      uri = opamSelection.uri;
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
  name = "dns-0.19.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "dns";
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
    sha256 = "0ghwgpwg33mx5m0mfkbxjddsm8n93fbj64qd6nf9g2sl56ar6mk3";
    url = "http://github.com/mirage/ocaml-dns/archive/v0.19.1.tar.gz";
  };
}

