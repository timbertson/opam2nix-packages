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
      jbuilder = opamSelection.jbuilder;
      lwt = opamSelection.lwt;
      mirage-clock = opamSelection.mirage-clock;
      mirage-clock-lwt = opamSelection.mirage-clock-lwt;
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
  name = "mirage-clock-unix-1.4.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mirage-clock-unix";
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
    sha256 = "0kxlspp1nk8siy2mlcvdv5ykk50lli7z9j0p1d34zj19myv6hz0v";
    url = "https://github.com/mirage/mirage-clock/releases/download/v1.4.0/mirage-clock-1.4.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

