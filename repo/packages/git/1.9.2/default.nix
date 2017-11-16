world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      alcotest = opamSelection.alcotest or null;
      astring = opamSelection.astring;
      base-unix = opamSelection.base-unix or null;
      camlzip = opamSelection.camlzip or null;
      channel = opamSelection.channel or null;
      cmdliner = opamSelection.cmdliner;
      cohttp = opamSelection.cohttp or null;
      conduit = opamSelection.conduit or null;
      fmt = opamSelection.fmt;
      hex = opamSelection.hex;
      logs = opamSelection.logs;
      lwt = opamSelection.lwt;
      mirage-flow = opamSelection.mirage-flow or null;
      mirage-fs-unix = opamSelection.mirage-fs-unix or null;
      mirage-http = opamSelection.mirage-http or null;
      mirage-types-lwt = opamSelection.mirage-types-lwt or null;
      mstruct = opamSelection.mstruct;
      mtime = opamSelection.mtime;
      nocrypto = opamSelection.nocrypto or null;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ocamlgraph = opamSelection.ocamlgraph;
      ocplib-endian = opamSelection.ocplib-endian;
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
  name = "git-1.9.2";
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
    sha256 = "1bvjfrgz31zrng1l0ka3d0a50iknikimhrd792wh3isra7mpk864";
    url = "https://github.com/mirage/ocaml-git/releases/download/1.9.2/git-1.9.2.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

