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
      jbuilder = opamSelection.jbuilder;
      lwt = opamSelection.lwt;
      mirage-flow-lwt = opamSelection.mirage-flow-lwt;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      rawlink = opamSelection.rawlink;
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
  name = "mirage-flow-rawlink-1.0.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mirage-flow-rawlink";
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
    sha256 = "1azqcwpmpykm7z0mijiysjh6h49m70s71z31mx209jhalzpxr9g3";
    url = "https://github.com/mirage/mirage-flow-rawlink/releases/download/1.0.0/mirage-flow-rawlink-1.0.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

