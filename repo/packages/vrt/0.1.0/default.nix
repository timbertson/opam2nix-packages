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
      async_extra = opamSelection.async_extra;
      async_find = opamSelection.async_find;
      async_shell = opamSelection.async_shell;
      async_unix = opamSelection.async_unix;
      core = opamSelection.core;
      core_extended = opamSelection.core_extended;
      ocaml = opamSelection.ocaml;
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
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "vrt-0.1.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "vrt";
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
    sha256 = "1c2h0gkv2zhy0wl56rsf4jkgv6b29l2is1i9jksqr84ad5jhwspq";
    url = "https://github.com/afiniate/vrt/archive/0.1.0.tar.gz";
  };
}

