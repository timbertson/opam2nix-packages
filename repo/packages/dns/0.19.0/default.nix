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
      base-unix = opamSelection.base-unix or null;
      base64 = opamSelection.base64;
      cmdliner = opamSelection.cmdliner;
      cstruct = opamSelection.cstruct;
      duration = opamSelection.duration;
      hashcons = opamSelection.hashcons;
      ipaddr = opamSelection.ipaddr;
      lwt = opamSelection.lwt;
      mirage-kv-lwt = opamSelection.mirage-kv-lwt or null;
      mirage-profile = opamSelection.mirage-profile;
      mirage-protocols = opamSelection.mirage-protocols or null;
      mirage-stack-lwt = opamSelection.mirage-stack-lwt or null;
      mirage-time-lwt = opamSelection.mirage-time-lwt or null;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ounit = opamSelection.ounit or null;
      pcap-format = opamSelection.pcap-format or null;
      ppx_cstruct = opamSelection.ppx_cstruct;
      ppx_tools = opamSelection.ppx_tools;
      re = opamSelection.re;
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
  name = "dns-0.19.0";
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
    sha256 = "1zald3whc9swjinz6z6cyz0z6bz3wdl1w9c3cvk6g1j9qf61ynfr";
    url = "https://github.com/mirage/ocaml-dns/archive/v0.19.0.tar.gz";
  };
}

