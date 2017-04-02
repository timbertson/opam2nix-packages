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
      fmt = opamSelection.fmt;
      hex = opamSelection.hex;
      jsonm = opamSelection.jsonm;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ocamlgraph = opamSelection.ocamlgraph;
      topkg = opamSelection.topkg;
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
  name = "irmin-1.0.2";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "irmin";
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
    sha256 = "02js38z4a71f5wfjr145p128mfmiq947rlyw62bw1xi51xg3g667";
    url = "https://github.com/mirage/irmin/releases/download/1.0.2/irmin-1.0.2.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

