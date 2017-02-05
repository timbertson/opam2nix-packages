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
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      result = opamSelection.result;
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
  name = "parse-argv-0.0.3";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "parse-argv";
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
    sha256 = "03irk4m9hp2gjjh7b9r9j1f1wbawyf50i51315zzmfbynxmyqj50";
    url = "https://github.com/mirage/parse-argv/releases/download/v0.0.3/parse-argv-0.0.3.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

