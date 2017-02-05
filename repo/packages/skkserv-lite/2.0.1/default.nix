world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base-unix = opamSelection.base-unix;
      camomile = opamSelection.camomile;
      lwt = opamSelection.lwt;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      sqlite3 = opamSelection.sqlite3 or null;
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
  name = "skkserv-lite-2.0.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "skkserv-lite";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  prePatch = "cp -r ${./files}/* ./";
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "0vlw4k9scxpqvari0iy3ppadib4hw8x9igjlqvgmmlja9yyfbb5d";
    url = "https://github.com/anyakichi/ocaml-skkserv-lite/archive/2.0.1.tar.gz";
  };
}

