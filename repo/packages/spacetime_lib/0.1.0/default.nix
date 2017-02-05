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
      base-unix = opamSelection.base-unix;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      owee = opamSelection.owee;
      raw_spacetime = opamSelection.raw_spacetime;
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
  name = "spacetime_lib-0.1.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "spacetime_lib";
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
    sha256 = "0gcwj48j6gbxvha39dxjay41lkcqpcnmk19dxv1lva4iw4a5ayim";
    url = "https://github.com/lpw25/spacetime_lib/archive/0.1.0.tar.gz";
  };
}

