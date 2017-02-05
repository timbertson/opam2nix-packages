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
      base-bytes = opamSelection.base-bytes;
      base-unix = opamSelection.base-unix;
      channel = opamSelection.channel;
      cmdliner = opamSelection.cmdliner;
      cstruct = opamSelection.cstruct;
      fmt = opamSelection.fmt;
      lambda-term = opamSelection.lambda-term or null;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      mirage-types-lwt = opamSelection.mirage-types-lwt;
      named-pipe = opamSelection.named-pipe;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ppx_deriving = opamSelection.ppx_deriving;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      ppx_tools = opamSelection.ppx_tools;
      result = opamSelection.result;
      sexplib = opamSelection.sexplib;
      topkg = opamSelection.topkg;
      win-error = opamSelection.win-error;
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
  name = "protocol-9p-0.7.4";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "protocol-9p";
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
    sha256 = "07ni1krzpn8hbis7v4310p0jhgw9gx2cil0b79yaqam5b4v3pf26";
    url = "https://github.com/mirage/ocaml-9p/releases/download/v0.7.4/protocol-9p-0.7.4.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

