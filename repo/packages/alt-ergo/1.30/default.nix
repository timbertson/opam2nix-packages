world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      camlzip = opamSelection.camlzip;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      ocplib-simplex = opamSelection.ocplib-simplex;
      zarith = opamSelection.zarith;
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
  name = "alt-ergo-1.30";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "alt-ergo";
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
    sha256 = "025pacb4ax864fn5x8k78mw6hiig4jcazblj18gzxspg4f1l5n1g";
    url = "http://alt-ergo.ocamlpro.com/http/alt-ergo-1.30/alt-ergo-1.30.tar.gz";
  };
}

