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
  name = "dns-0.20.1";
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
    sha256 = "1ffc2dzk2vq8wrhlbm9fj3scv3zdvlmx7lczgil29946y5g0b6a3";
    url = "https://github.com/mirage/ocaml-dns/releases/download/0.20.1/dns-0.20.1.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

