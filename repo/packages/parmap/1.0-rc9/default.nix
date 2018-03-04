world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      conf-aclocal = opamSelection.conf-aclocal;
      conf-autoconf = opamSelection.conf-autoconf;
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
  name = "parmap-1.0-rc9";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "parmap";
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
    sha256 = "0sp1r74qacxqg6617r484y1hzgsawszif4cqmgk7lnwmkqkdpk4b";
    url = "https://github.com/rdicosmo/parmap/archive/1.0-rc9.tar.gz";
  };
}

