world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-unix = opamSelection.base-unix or null;
      camlzip = opamSelection.camlzip or null;
      channel = opamSelection.channel or null;
      cmdliner = opamSelection.cmdliner;
      cohttp = opamSelection.cohttp or null;
      conduit = opamSelection.conduit or null;
      crc = opamSelection.crc;
      dolog = opamSelection.dolog;
      hex = opamSelection.hex;
      lwt = opamSelection.lwt;
      mirage-flow = opamSelection.mirage-flow or null;
      mirage-http = opamSelection.mirage-http or null;
      mirage-types-lwt = opamSelection.mirage-types-lwt or null;
      mstruct = opamSelection.mstruct;
      nocrypto = opamSelection.nocrypto or null;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ocamlgraph = opamSelection.ocamlgraph;
      stringext = opamSelection.stringext;
      uri = opamSelection.uri;
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
  name = "git-1.7.2";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "git";
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
    sha256 = "1ff5xjkr6pn06c6b4c5wg181nl2vga9r6a2h450ywqfcxvmj20f9";
    url = "https://github.com/mirage/ocaml-git/archive/1.7.2.tar.gz";
  };
}

