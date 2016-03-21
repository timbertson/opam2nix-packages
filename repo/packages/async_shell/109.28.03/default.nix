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
      camlp4 = opamSelection.camlp4;
      core_extended = opamSelection.core_extended;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind or null;
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
  name = "async_shell-109.28.03";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "async_shell";
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
    sha256 = "01f1wsb72qkhd0p91pvrfisjzgsw7jkv13z5brk5lk0jm6z9fi0b";
    url = "https://ocaml.janestreet.com/ocaml-core/109.28.00/individual/async_shell-109.28.03.tar.gz";
  };
}

