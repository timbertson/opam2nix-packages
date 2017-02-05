world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.efl or null)
        (pkgs."https://gist.githubusercontent.com/axiles/ad30d3b4465bd08bcb4eb117e21d70c8/raw/3367e23cb29e1255cd8588008250ef98d389bbbd/install_efl_1_18_on_ubuntu" or null)
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
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "efl-1.18.0";
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
    sha256 = "1ijjp4cnsq88f3xi9lhgdg03p3nk7x6s2pccyxbrhbk474wz124j";
    url = "https://forge.ocamlcore.org/frs/download.php/1661/ocaml-efl-1.18.0.tar.gz";
  };
}

