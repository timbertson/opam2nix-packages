world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cmdliner = opamSelection.cmdliner;
      datakit-client = opamSelection.datakit-client;
      datakit-client-9p = opamSelection.datakit-client-9p;
      datakit-github = opamSelection.datakit-github;
      fmt = opamSelection.fmt;
      irmin = opamSelection.irmin;
      irmin-unix = opamSelection.irmin-unix;
      irmin-watcher = opamSelection.irmin-watcher;
      jbuilder = opamSelection.jbuilder;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      protocol-9p-unix = opamSelection.protocol-9p-unix;
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
  name = "datakit-bridge-local-git-0.11.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "datakit-bridge-local-git";
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
    sha256 = "1djh5x2ikpa0l238a610iihx421d950wi7sypk2sincipzdw5gbc";
    url = "https://github.com/moby/datakit/releases/download/0.11.0/datakit-0.11.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

