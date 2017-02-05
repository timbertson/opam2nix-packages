world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      conf-openssl = opamSelection.conf-openssl;
      conf-which = opamSelection.conf-which;
      ocaml = opamSelection.ocaml;
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
  name = "ssl-0.5.3";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "ssl";
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
    sha256 = "181s46b2m71s47mv6c97jm665j7v8d2x89a64jr0nzxbhgmqxxwy";
    url = "https://github.com/savonet/ocaml-ssl/releases/download/0.5.3/ocaml-ssl-0.5.3.tar.gz";
  };
}

