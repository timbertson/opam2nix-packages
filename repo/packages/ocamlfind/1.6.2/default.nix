world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      conf-m4 = opamSelection.conf-m4;
      conf-ncurses = opamSelection.conf-ncurses;
      ocaml = opamSelection.ocaml;
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
  name = "ocamlfind-1.6.2";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "ocamlfind";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  postUnpack = "cp -r ${./files}/* \"$sourceRoot/\"";
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "0in9cjqvi5mz9hz307y2icbm921v0bf1mv4zkw46dfzz891r05rr";
    url = "http://download.camlcity.org/download/findlib-1.6.2.tar.gz";
  };
}

