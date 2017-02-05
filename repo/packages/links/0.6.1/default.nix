world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      base64 = opamSelection.base64;
      cgi = opamSelection.cgi;
      cohttp = opamSelection.cohttp;
      deriving = opamSelection.deriving;
      lwt = opamSelection.lwt;
      mysql = opamSelection.mysql or null;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      postgresql = opamSelection.postgresql or null;
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
  name = "links-0.6.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "links";
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
    sha256 = "1z8apn6ymg0kk74w8vz5di54avry08qpw92d4sps9cg1ixqj3m94";
    url = "https://github.com/links-lang/links/archive/gorgie_0_6_1.tar.gz";
  };
}

