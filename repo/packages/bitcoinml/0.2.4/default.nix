world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.unzip) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base = opamSelection.base;
      bignum = opamSelection.bignum;
      bitstring = opamSelection.bitstring;
      configurator = opamSelection.configurator;
      cryptokit = opamSelection.cryptokit;
      jbuilder = opamSelection.jbuilder;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ppx_bitstring = opamSelection.ppx_bitstring;
      ppx_jane = opamSelection.ppx_jane;
      stdint = opamSelection.stdint;
      stdio = opamSelection.stdio;
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
  name = "bitcoinml-0.2.4";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "bitcoinml";
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
    sha256 = "0zl4dyhprgpx4y1j7ap5gwrb0kamcvsf9bk4w8qjzvzfzhywv4j5";
    url = "https://github.com/dakk/bitcoinml/archive/0.2.4-rc4.zip";
  };
}

