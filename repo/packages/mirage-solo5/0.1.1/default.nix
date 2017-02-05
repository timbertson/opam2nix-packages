world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cstruct = opamSelection.cstruct;
      lwt = opamSelection.lwt;
      mirage-profile = opamSelection.mirage-profile;
      ocaml = opamSelection.ocaml;
      ocaml-freestanding = opamSelection.ocaml-freestanding;
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
  name = "mirage-solo5-0.1.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mirage-solo5";
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
    sha256 = "07j4cxc3g8bqmiqaaqz9af0vpjqisiyr23sbhwhp34bb5jyyq08j";
    url = "https://github.com/mirage/mirage-solo5/archive/v0.1.1.tar.gz";
  };
}

