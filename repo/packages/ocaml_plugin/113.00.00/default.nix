world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      async = opamSelection.async;
      bin_prot = opamSelection.bin_prot;
      camlp4 = opamSelection.camlp4;
      comparelib = opamSelection.comparelib;
      fieldslib = opamSelection.fieldslib;
      herelib = opamSelection.herelib;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      sexplib = opamSelection.sexplib;
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
  name = "ocaml_plugin-113.00.00";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ocaml_plugin";
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
    sha256 = "0vlfgvbj1dk8zlcbr1h2bf1b1w8d1d5wq7p175i5z0c7jv37vs90";
    url = "https://ocaml.janestreet.com/ocaml-core/113.00/files/ocaml_plugin-113.00.00.tar.gz";
  };
}

