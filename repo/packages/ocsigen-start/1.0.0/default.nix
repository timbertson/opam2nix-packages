world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.npm or null) (pkgs.postgresql or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      eliom = opamSelection.eliom;
      macaque = opamSelection.macaque;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ocsigen-i18n = opamSelection.ocsigen-i18n;
      ocsigen-toolkit = opamSelection.ocsigen-toolkit;
      pgocaml = opamSelection.pgocaml;
      safepass = opamSelection.safepass;
      yojson = opamSelection.yojson;
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
  name = "ocsigen-start-1.0.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ocsigen-start";
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
    sha256 = "0npc2iq39ixci6ly0fssklv07zqi5cfa1adad4hm8dbzjawkqqll";
    url = "https://github.com/ocsigen/ocsigen-start/archive/1.0.0.tar.gz";
  };
}

