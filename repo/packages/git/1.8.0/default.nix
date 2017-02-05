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
      base-unix = opamSelection.base-unix or null;
      camlzip = opamSelection.camlzip or null;
      channel = opamSelection.channel or null;
      cmdliner = opamSelection.cmdliner;
      cohttp = opamSelection.cohttp or null;
      conduit = opamSelection.conduit or null;
      crc = opamSelection.crc;
      fmt = opamSelection.fmt;
      hex = opamSelection.hex;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      mirage-flow = opamSelection.mirage-flow or null;
      mirage-http = opamSelection.mirage-http or null;
      mirage-types-lwt = opamSelection.mirage-types-lwt or null;
      mstruct = opamSelection.mstruct;
      mtime = opamSelection.mtime;
      nocrypto = opamSelection.nocrypto or null;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ocamlgraph = opamSelection.ocamlgraph;
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
  name = "git-1.8.0";
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
    sha256 = "1p6wqxm1wyibnww2wgabmdwfjy562xlbnv49fwjwg5anrcz6g97s";
    url = "https://github.com/mirage/ocaml-git/archive/1.8.0.tar.gz";
  };
}

