world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      ANSITerminal = opamSelection.ANSITerminal;
      astring = opamSelection.astring;
      base-unix = opamSelection.base-unix;
      cohttp = opamSelection.cohttp;
      ezxmlm = opamSelection.ezxmlm;
      oasis = opamSelection.oasis;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      re = opamSelection.re;
      tyxml = opamSelection.tyxml;
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
  name = "podge-0.8.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "podge";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  prePatch = "cp -r ${./files}/* ./";
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "017hf2ifz44w0gn5375n9xvpann9w5ccq83y5nvnj37412y6prw7";
    url = "https://github.com/fxfactorial/podge/archive/v0.8.0.tar.gz";
  };
}

