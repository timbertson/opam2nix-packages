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
      io-page = opamSelection.io-page;
      ipaddr = opamSelection.ipaddr;
      jbuilder = opamSelection.jbuilder;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      mirage-clock-lwt = opamSelection.mirage-clock-lwt;
      mirage-net-lwt = opamSelection.mirage-net-lwt;
      mirage-profile = opamSelection.mirage-profile;
      mirage-time-lwt = opamSelection.mirage-time-lwt;
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
  name = "mirage-vnetif-0.4.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mirage-vnetif";
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
    sha256 = "0dqqn3n19ynpdzbmzkr3i7vwqvkcnh8mc49142gwjs1xz4mmnaq5";
    url = "https://github.com/mirage/mirage-vnetif/releases/download/v0.4.0/mirage-vnetif-0.4.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

