world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.kernel-headers or null) (pkgs.linux-glibc-devel or null)
        (pkgs.linux-headers or null) (pkgs.linux-libc-dev or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cstruct = opamSelection.cstruct;
      cstruct-lwt = opamSelection.cstruct-lwt;
      fmt = opamSelection.fmt or null;
      io-page-unix = opamSelection.io-page-unix;
      jbuilder = opamSelection.jbuilder;
      logs = opamSelection.logs;
      mirage-block-lwt = opamSelection.mirage-block-lwt;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ounit = opamSelection.ounit or null;
      rresult = opamSelection.rresult;
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
  name = "mirage-block-unix-2.9.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mirage-block-unix";
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
    sha256 = "036hhi6q1hn7xksz5ligr0dkxqa74br6lnyy088y5qm40p28vyxj";
    url = "https://github.com/mirage/mirage-block-unix/releases/download/v2.9.0/mirage-block-unix-2.9.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

