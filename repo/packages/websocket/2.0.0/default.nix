world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cohttp = opamSelection.cohttp;
      conduit = opamSelection.conduit;
      containers = opamSelection.containers;
      lwt = opamSelection.lwt;
      nocrypto = opamSelection.nocrypto;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind or null;
      ocplib-endian = opamSelection.ocplib-endian;
      ppx_deriving = opamSelection.ppx_deriving;
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
  name = "websocket-2.0.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "websocket";
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
    sha256 = "182bmwyfm5yc8c6yylrzpm3a3x27zbpvnqgb1miy4nsprqk0qlw5";
    url = "https://github.com/vbmithr/ocaml-websocket/archive/2.0.0.tar.gz";
  };
}

