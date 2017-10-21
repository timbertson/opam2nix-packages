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
      cstruct = opamSelection.cstruct;
      dns = opamSelection.dns;
      duration = opamSelection.duration;
      fmt = opamSelection.fmt;
      ipaddr = opamSelection.ipaddr;
      jbuilder = opamSelection.jbuilder;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      mirage-channel-lwt = opamSelection.mirage-channel-lwt;
      mirage-clock-lwt = opamSelection.mirage-clock-lwt;
      mirage-flow-lwt = opamSelection.mirage-flow-lwt;
      mirage-time-lwt = opamSelection.mirage-time-lwt;
      mtime = opamSelection.mtime;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      result = opamSelection.result;
      rresult = opamSelection.rresult;
      sexplib = opamSelection.sexplib;
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
  name = "dns-forward-0.9.0";
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
    sha256 = "12sj6vl44mgklbm770l0v59h8kprw0j530brg9czlg9gwkdcs4xz";
    url = "https://github.com/mirage/ocaml-dns-forward/releases/download/v0.9.0/dns-forward-0.9.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

