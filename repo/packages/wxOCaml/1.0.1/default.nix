world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs."libwxgtk-media3.0-dev" or null)
        (pkgs."libwxgtk-webview3.0-dev" or null)
        (pkgs."libwxgtk3.0-dev" or null) (pkgs."wx3.0-headers" or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ocp-build = opamSelection.ocp-build;
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
  name = "wxOCaml-1.0.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "wxOCaml";
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
    sha256 = "1yifj22n0lkyyfy5rl2arrsyj8snvi91gllmmrpgc2n10cl5xh5w";
    url = "https://github.com/OCamlPro/ocplib-wxOCaml/archive/1.0.1.tar.gz";
  };
}

