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
      cppo = opamSelection.cppo;
      fmt = opamSelection.fmt;
      inotify = opamSelection.inotify or null;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ocb-stubblr = opamSelection.ocb-stubblr;
      osx-fsevents = opamSelection.osx-fsevents or null;
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
  name = "irmin-watcher-0.2.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "irmin-watcher";
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
    sha256 = "1vb1i9q7ll16zxdhrjb1sr2xc9gxdfhsryywfia59jsbjyiqmkxz";
    url = "https://github.com/samoht/irmin-watcher/releases/download/0.2.0/irmin-watcher-0.2.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

