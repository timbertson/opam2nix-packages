world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      configurator = opamSelection.configurator;
      cstruct = opamSelection.cstruct;
      cstruct-lwt = opamSelection.cstruct-lwt;
      duration = opamSelection.duration;
      fmt = opamSelection.fmt;
      io-page-unix = opamSelection.io-page-unix;
      ipaddr = opamSelection.ipaddr;
      jbuilder = opamSelection.jbuilder;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      mirage-clock = opamSelection.mirage-clock;
      mirage-clock-lwt = opamSelection.mirage-clock-lwt;
      mirage-net = opamSelection.mirage-net;
      mirage-net-lwt = opamSelection.mirage-net-lwt;
      mirage-profile = opamSelection.mirage-profile;
      mirage-protocols = opamSelection.mirage-protocols;
      mirage-protocols-lwt = opamSelection.mirage-protocols-lwt;
      mirage-random = opamSelection.mirage-random;
      mirage-stack-lwt = opamSelection.mirage-stack-lwt;
      mirage-time-lwt = opamSelection.mirage-time-lwt;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      randomconv = opamSelection.randomconv;
      rresult = opamSelection.rresult;
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
  name = "tcpip-3.2.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "tcpip";
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
    sha256 = "1xqgz5lz9a3rh0swy0cb41ar8i7fxjxvlvn3dq0i5qs7bq1iwzmn";
    url = "https://github.com/mirage/mirage-tcpip/releases/download/v3.2.0/tcpip-3.2.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

