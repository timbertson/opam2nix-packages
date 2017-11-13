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
      linenoise = opamSelection.linenoise;
      lwt = opamSelection.lwt;
      mysql = opamSelection.mysql or null;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      postgresql = opamSelection.postgresql or null;
      sqlite3 = opamSelection.sqlite3 or null;
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
  name = "links-0.7.1";
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
    sha256 = "0ckhys5wvndq68fvrpz2cnmmrmnivzfp1nyni17sz5jvfnaa4njf";
    url = "https://github.com/links-lang/links/archive/v0.7.1.tar.gz";
  };
}

