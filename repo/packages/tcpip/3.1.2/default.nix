world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cstruct = opamSelection.cstruct;
      duration = opamSelection.duration;
      fmt = opamSelection.fmt;
      ipaddr = opamSelection.ipaddr;
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
      mirage-xen = opamSelection.mirage-xen or null;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ppx_tools = opamSelection.ppx_tools;
      randomconv = opamSelection.randomconv;
      result = opamSelection.result;
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
  name = "tcpip-3.1.2";
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
    sha256 = "1l0qqh5xgppirzpvpz6gs5ahd30c5pd9ma3c6jcm01hshq9n3vqh";
    url = "https://github.com/mirage/mirage-tcpip/archive/v3.1.2.tar.gz";
  };
}

