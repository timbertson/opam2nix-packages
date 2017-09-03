world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cohttp-lwt-unix = opamSelection.cohttp-lwt-unix;
      conduit-lwt-unix = opamSelection.conduit-lwt-unix;
      github-hooks = opamSelection.github-hooks;
      github-unix = opamSelection.github-unix;
      jbuilder = opamSelection.jbuilder;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
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
  name = "github-hooks-unix-0.2.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "github-hooks-unix";
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
    sha256 = "1k1lmdzmsd4yzkssdin4np8my23a6dgm3x0hsq5szh062gxq89yz";
    url = "https://github.com/dsheets/ocaml-github-hooks/releases/download/0.2.0/github-hooks-0.2.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

