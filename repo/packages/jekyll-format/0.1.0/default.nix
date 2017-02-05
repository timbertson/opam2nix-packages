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
      fmt = opamSelection.fmt;
      fpath = opamSelection.fpath;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      omd = opamSelection.omd;
      ptime = opamSelection.ptime;
      result = opamSelection.result;
      rresult = opamSelection.rresult;
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
  name = "jekyll-format-0.1.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "jekyll-format";
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
    sha256 = "1mgz9d7av0qvlphy9bn0i2waal6vrk7my2xkq9kfwky7s044a89c";
    url = "https://github.com/avsm/jekyll-format/releases/download/v0.1.0/jekyll-format-0.1.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

