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
      cstruct-lwt = opamSelection.cstruct-lwt;
      jbuilder = opamSelection.jbuilder;
      lwt = opamSelection.lwt;
      mirage-fs-lwt = opamSelection.mirage-fs-lwt;
      mirage-kv-lwt = opamSelection.mirage-kv-lwt;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      result = opamSelection.result;
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
  name = "mirage-fs-unix-1.4.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mirage-fs-unix";
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
    sha256 = "117bcs6b2wdzvmxvwrxzyy3fj0mnv7w8dz9j731akfg4vs21vf0b";
    url = "https://github.com/mirage/mirage-fs-unix/releases/download/v1.4.0/mirage-fs-unix-1.4.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

