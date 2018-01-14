world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      js_of_ocaml-lwt = opamSelection.js_of_ocaml-lwt;
      js_of_ocaml-ocamlbuild = opamSelection.js_of_ocaml-ocamlbuild;
      lwt = opamSelection.lwt;
      lwt_ppx = opamSelection.lwt_ppx;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      topkg = opamSelection.topkg;
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
  name = "gamepad-0.2.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "gamepad";
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
    sha256 = "0b92sjrmjmala5knpvh4dgnf7cmr56kr0y0jbpm4bz0fby2d9y55";
    url = "https://github.com/emillon/gamepad_of_ocaml/releases/download/v0.2.0/gamepad-0.2.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

