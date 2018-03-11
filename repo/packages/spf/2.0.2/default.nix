world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.epel-release or null) (pkgs.libspf2 or null)
        (pkgs.libspf2-dev or null) (pkgs.libspf2-devel or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      jbuilder = opamSelection.jbuilder;
      ocaml = opamSelection.ocaml;
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
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "spf-2.0.2";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "spf";
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
    sha256 = "03asg60j2j7yh859pa8qkdzg29id9qbcxq1aksrigiqdqfh6jgix";
    url = "https://github.com/andrenth/ocaml-spf/archive/2.0.2.tar.gz";
  };
}

