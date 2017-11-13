world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      camomile = opamSelection.camomile;
      jbuilder = opamSelection.jbuilder;
      lwt = opamSelection.lwt;
      lwt_react = opamSelection.lwt_react;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      react = opamSelection.react;
      zed = opamSelection.zed;
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
  name = "lambda-term-1.12.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "lambda-term";
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
    sha256 = "0ffapsvglhnwga30pkj94rhjsjlcs454sglcd1m76qn4r0rskfrb";
    url = "https://github.com/diml/lambda-term/releases/download/1.12.0/lambda-term-1.12.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

