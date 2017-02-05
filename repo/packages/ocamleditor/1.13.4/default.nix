world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      lablgtk = opamSelection.lablgtk;
      ocaml = opamSelection.ocaml;
      ocamldiff = opamSelection.ocamldiff or null;
      ocamlfind = opamSelection.ocamlfind;
      ocurl = opamSelection.ocurl or null;
      xml-light = opamSelection.xml-light;
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
  name = "ocamleditor-1.13.4";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ocamleditor";
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
    sha256 = "0jzil9wc67mk111s8xhfh5s8vnapplrkqwx73pk8c0zbcpllgg31";
    url = "https://github.com/ftovagliari/ocamleditor/archive/1.13.4.tar.gz";
  };
}

