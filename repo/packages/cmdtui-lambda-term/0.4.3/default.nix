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
      cmdliner = opamSelection.cmdliner;
      cmdtui = opamSelection.cmdtui;
      fmt = opamSelection.fmt;
      jbuilder = opamSelection.jbuilder;
      lambda-term = opamSelection.lambda-term;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
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
  name = "cmdtui-lambda-term-0.4.3";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "cmdtui-lambda-term";
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
    sha256 = "1n7a0yivjsd1c7aps23y4cphg6ma3zd3x4453npi5lhz10qpf132";
    url = "https://gitlab.com/edwintorok/cmdtui/uploads/6b3cad4a29a2b1f1a019e1a1ded0e429/cmdtui-0.4.3.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

