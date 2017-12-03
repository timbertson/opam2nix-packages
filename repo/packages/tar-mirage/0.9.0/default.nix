world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cstruct = opamSelection.cstruct;
      io-page = opamSelection.io-page;
      io-page-unix = opamSelection.io-page-unix or null;
      jbuilder = opamSelection.jbuilder;
      lwt = opamSelection.lwt;
      mirage-block-unix = opamSelection.mirage-block-unix or null;
      mirage-types-lwt = opamSelection.mirage-types-lwt;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ounit = opamSelection.ounit or null;
      re = opamSelection.re;
      result = opamSelection.result;
      tar = opamSelection.tar;
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
  name = "tar-mirage-0.9.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "tar-mirage";
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
    sha256 = "1ak8jxq35fb84z66s07p571dz60sj7mgw0f6yanq2sl1332iidky";
    url = "https://github.com/mirage/ocaml-tar/releases/download/v0.9.0/tar-0.9.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

