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
      base64 = opamSelection.base64;
      cgi = opamSelection.cgi;
      cohttp = opamSelection.cohttp;
      deriving = opamSelection.deriving;
      jbuilder = opamSelection.jbuilder;
      linenoise = opamSelection.linenoise;
      lwt = opamSelection.lwt;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      safepass = opamSelection.safepass;
      websocket-lwt = opamSelection.websocket-lwt;
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
  name = "links-0.7.2";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "links";
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
    sha256 = "14i72z16271cyx93xj7fprs9rafyv4ghbm3j1gbya9dvb6gbjqcl";
    url = "https://github.com/links-lang/links/releases/download/0.7.2/links-0.7.2.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

