world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      cryptokit = opamSelection.cryptokit or null;
      higlo = opamSelection.higlo;
      js_of_ocaml = opamSelection.js_of_ocaml or null;
      lwt = opamSelection.lwt;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ocf = opamSelection.ocf;
      ojs-base = opamSelection.ojs-base or null;
      omd = opamSelection.omd;
      ppx_blob = opamSelection.ppx_blob;
      ptime = opamSelection.ptime;
      uri = opamSelection.uri;
      uutf = opamSelection.uutf;
      websocket = opamSelection.websocket or null;
      xmldiff = opamSelection.xmldiff or null;
      xtmpl = opamSelection.xtmpl;
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
  name = "stog-0.17.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "stog";
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
    sha256 = "1kg1g05v4zrfj249xls5dld0wgqpw7nbh9plzn83zjs7v37a9fm3";
    url = "https://zoggy.github.io/stog/stog-0.17.1.tar.gz";
  };
}

