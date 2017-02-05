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
      cmdliner = opamSelection.cmdliner or null;
      fmt = opamSelection.fmt;
      lambda-term = opamSelection.lambda-term or null;
      logs = opamSelection.logs or null;
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
  name = "cmdtui-0.3.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "cmdtui";
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
    sha256 = "0ffma327h9bm56q0zk39s7r43qnwnshjl22qfvcpm6jg42zpkqhv";
    url = "https://gitlab.com/edwintorok/cmdtui/uploads/d8ed8d08f98a8d3481121df4b9fc13cd/cmdtui-0.3.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

