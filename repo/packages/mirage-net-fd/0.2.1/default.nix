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
      io-page-unix = opamSelection.io-page-unix;
      ipaddr = opamSelection.ipaddr;
      jbuilder = opamSelection.jbuilder;
      lwt = opamSelection.lwt;
      mirage-net-lwt = opamSelection.mirage-net-lwt;
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
  name = "mirage-net-fd-0.2.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mirage-net-fd";
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
    sha256 = "0q3vxn5m6q5ilz0m6yybqyck75wlzad50vmwl2mjvvm354l06bia";
    url = "https://github.com/mirage/mirage-net-fd/releases/download/0.2.1/mirage-net-fd-0.2.1.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

