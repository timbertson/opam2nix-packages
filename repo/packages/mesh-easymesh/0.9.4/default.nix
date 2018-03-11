world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-bigarray = opamSelection.base-bigarray;
      base-bytes = opamSelection.base-bytes;
      jbuilder = opamSelection.jbuilder;
      lacaml = opamSelection.lacaml or null;
      mesh = opamSelection.mesh;
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
  name = "mesh-easymesh-0.9.4";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mesh-easymesh";
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
    sha256 = "1gg69s01m6hss0l2i97d1f4bdzbnmk67ql7c1zmwvr3d0xf7csl1";
    url = "https://github.com/Chris00/mesh/releases/download/0.9.4/mesh-0.9.4.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

