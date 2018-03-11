world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
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
  name = "interval-1.4";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "interval";
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
    sha256 = "1jc0h38c719jmvwbml7na5mcflfnnzc96ys9vhp2ygfz40n0wg08";
    url = "https://github.com/Chris00/ocaml-interval/releases/download/1.4/interval-1.4.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

