world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      asetmap = opamSelection.asetmap;
      asl = opamSelection.asl;
      cmdliner = opamSelection.cmdliner;
      conduit = opamSelection.conduit;
      datakit-client = opamSelection.datakit-client;
      datakit-server = opamSelection.datakit-server;
      fmt = opamSelection.fmt;
      github = opamSelection.github;
      github-hooks = opamSelection.github-hooks;
      hex = opamSelection.hex;
      hvsock = opamSelection.hvsock;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      mtime = opamSelection.mtime;
      named-pipe = opamSelection.named-pipe;
      nocrypto = opamSelection.nocrypto;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      topkg = opamSelection.topkg;
      win-eventlog = opamSelection.win-eventlog;
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
  name = "datakit-github-0.8.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "datakit-github";
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
    sha256 = "0rsyr19psw7gf3w1kg6xdns18a896lp36ygxpf0xdin2m0j4hdhl";
    url = "https://github.com/docker/datakit/releases/download/0.8.1/datakit-0.8.1.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

