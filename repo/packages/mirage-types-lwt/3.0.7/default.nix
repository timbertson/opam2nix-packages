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
      io-page = opamSelection.io-page;
      ipaddr = opamSelection.ipaddr;
      jbuilder = opamSelection.jbuilder;
      lwt = opamSelection.lwt;
      mirage-block-lwt = opamSelection.mirage-block-lwt;
      mirage-channel-lwt = opamSelection.mirage-channel-lwt;
      mirage-clock-lwt = opamSelection.mirage-clock-lwt;
      mirage-console-lwt = opamSelection.mirage-console-lwt;
      mirage-flow-lwt = opamSelection.mirage-flow-lwt;
      mirage-fs-lwt = opamSelection.mirage-fs-lwt;
      mirage-kv-lwt = opamSelection.mirage-kv-lwt;
      mirage-net-lwt = opamSelection.mirage-net-lwt;
      mirage-protocols-lwt = opamSelection.mirage-protocols-lwt;
      mirage-random = opamSelection.mirage-random;
      mirage-stack-lwt = opamSelection.mirage-stack-lwt;
      mirage-time-lwt = opamSelection.mirage-time-lwt;
      mirage-types = opamSelection.mirage-types;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
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
  name = "mirage-types-lwt-3.0.7";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mirage-types-lwt";
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
    sha256 = "11qyfdnmsgwg0bybsbsjblqv4f8zca7fbcj1wxxwb6b7lgq99z7j";
    url = "https://github.com/mirage/mirage/releases/download/3.0.7/mirage-3.0.7.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

