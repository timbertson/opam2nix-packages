world:
let
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.libpcre-devel or null) (pkgs.libpcre3-dev or null)
        (pkgs.pcre or null) (pkgs.pcre-dev or null) (pkgs.pcre-devel or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      conf-pkg-config = opamSelection.conf-pkg-config;
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
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "conf-libpcre-1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "conf-libpcre";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  propagatedBuildInputs = inputs;
  unpackPhase = "true";
}

