world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      calendar = opamSelection.calendar;
      cohttp = opamSelection.cohttp or null;
      cryptokit = opamSelection.cryptokit;
      iri = opamSelection.iri;
      jsonm = opamSelection.jsonm;
      lwt = opamSelection.lwt or null;
      menhir = opamSelection.menhir;
      mysql = opamSelection.mysql or null;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      pcre = opamSelection.pcre;
      postgresql = opamSelection.postgresql or null;
      sedlex = opamSelection.sedlex;
      uri = opamSelection.uri;
      uuidm = opamSelection.uuidm;
      uutf = opamSelection.uutf;
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
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "rdf-0.11.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "rdf";
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
    sha256 = "0nqqf9v53yy8v0pac1vphkys79q2ganrra8zd8wq4y43yxxmd6y1";
    url = "https://zoggy.github.io/ocaml-rdf/ocaml-rdf-0.11.0.tar.gz";
  };
}

