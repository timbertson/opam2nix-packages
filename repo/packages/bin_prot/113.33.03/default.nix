world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      js-build-tools = opamSelection.js-build-tools;
      mirage-xen-ocaml = opamSelection.mirage-xen-ocaml or null;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
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
  name = "bin_prot-113.33.03";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "bin_prot";
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
    sha256 = "1ws8c017z8nbj3vw92ndvjk9011f71rmp3llncbv8r5fc76wqv3l";
    url = "https://ocaml.janestreet.com/ocaml-core/113.33/files/bin_prot-113.33.03.tar.gz";
  };
}

