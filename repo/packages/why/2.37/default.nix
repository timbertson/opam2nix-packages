world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      conf-autoconf = opamSelection.conf-autoconf;
      frama-c = opamSelection.frama-c;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      why3 = opamSelection.why3;
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
  name = "why-2.37";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "why";
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
    sha256 = "00xr8aq6zwln0ccfs1ng610j70r6ia6wqdyaqs9iqibqfa1scr3m";
    url = "http://why.lri.fr/download/why-2.37.tar.gz";
  };
}

