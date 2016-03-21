world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cryptokit = opamSelection.cryptokit;
      extlib = opamSelection.extlib or null;
      extlib-compat = opamSelection.extlib-compat or null;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ocamlnet = opamSelection.ocamlnet;
      ocurl = opamSelection.ocurl;
      ounit = opamSelection.ounit or null;
      pa_monad_custom = opamSelection.pa_monad_custom or null;
      xmlm = opamSelection.xmlm;
      yojson = opamSelection.yojson;
    };
    opamSelection = world.opamSelection;
    pkgs = world.pkgs;
in
pkgs.stdenv.mkDerivation 
{
  buildInputs = inputs;
  buildPhase = "${opam2nix}/bin/opam2nix invoke build";
  configurePhase = "true";
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "gapi-ocaml-0.2.9";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "gapi-ocaml";
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
    sha256 = "1kj8g65xq4hpqkqmh5ai8pxxn0fgjdw33bydj1ib7hnjpvcbjfxl";
    url = "https://forge.ocamlcore.org/frs/download.php/1600/gapi-ocaml-0.2.9.tar.gz";
  };
}

