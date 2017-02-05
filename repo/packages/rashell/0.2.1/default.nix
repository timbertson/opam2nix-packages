world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      atdgen = opamSelection.atdgen;
      broken = opamSelection.broken;
      bsdowl = opamSelection.bsdowl;
      conf-bmake = opamSelection.conf-bmake;
      lwt = opamSelection.lwt;
      mixture = opamSelection.mixture;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
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
  name = "rashell-0.2.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "rashell";
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
    sha256 = "0ngrzc51hlq224wsxqpfqknnd8iz1ij20s2srsqm3mfp7zqpmwrc";
    url = "https://github.com/michipili/rashell/releases/download/v0.2.1/rashell-0.2.1.tar.xz";
  };
}

