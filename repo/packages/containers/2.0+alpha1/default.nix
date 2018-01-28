world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-bytes = opamSelection.base-bytes;
      base-threads = opamSelection.base-threads or null;
      base-unix = opamSelection.base-unix or null;
      jbuilder = opamSelection.jbuilder;
      oUnit = opamSelection.oUnit or null;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      odoc = opamSelection.odoc or null;
      qcheck = opamSelection.qcheck or null;
      qtest = opamSelection.qtest or null;
      result = opamSelection.result;
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
  name = "containers-2.0+alpha1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "containers";
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
    sha256 = "0ii60ixssb9klgdlhx0lly96l7bdj6va5j13da75rcblr57zs19y";
    url = "https://github.com/c-cube/ocaml-containers/archive/2.0+alpha1.tar.gz";
  };
}

