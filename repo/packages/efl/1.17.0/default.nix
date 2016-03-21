world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.elementary or null)
        (pkgs."https://gist.githubusercontent.com/axiles/6e0f43192045c5f9b460/raw/f7c0668e063e12ded850f9b67fc4432b31ca1a7b/install_efl_1_17_on_ubuntu" or null)
        ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
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
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "efl-1.17.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "efl";
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
    sha256 = "0jijz8bmyzkwwdwa56qi2csc8z7hz6dhcn5l2a64hgijf3rfwcqa";
    url = "https://forge.ocamlcore.org/frs/download.php/1598/ocaml-efl-1.17.0.tar.gz";
  };
}

