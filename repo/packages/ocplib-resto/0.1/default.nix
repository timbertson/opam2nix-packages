world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      lwt = opamSelection.lwt;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ocp-build = opamSelection.ocp-build;
      ocplib-json-typed = opamSelection.ocplib-json-typed;
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
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "ocplib-resto-0.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ocplib-resto";
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
    sha256 = "0w825q26ihsxc109zlyvniz0lnbdd49ynpsdb0c1bz7jjniwgqmy";
    url = "https://github.com/OCamlPro/ocplib-resto/releases/download/0.1/ocplib-resto_0.1.tar.gz";
  };
}

