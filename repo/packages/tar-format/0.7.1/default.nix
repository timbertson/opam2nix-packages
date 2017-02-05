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
      io-page = opamSelection.io-page or null;
      lwt = opamSelection.lwt or null;
      mirage-block = opamSelection.mirage-block or null;
      mirage-block-lwt = opamSelection.mirage-block-lwt or null;
      mirage-types-lwt = opamSelection.mirage-types-lwt or null;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ppx_tools = opamSelection.ppx_tools;
      re = opamSelection.re;
      result = opamSelection.result;
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
  name = "tar-format-0.7.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "tar-format";
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
    sha256 = "1vcqnqx17b12hiqxksy8q5b5kgfszy60vc8vj6s7126v30113hlr";
    url = "https://github.com/mirage/ocaml-tar/releases/download/v0.7.1/tar-format-0.7.1.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

