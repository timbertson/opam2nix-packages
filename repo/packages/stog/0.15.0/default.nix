world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      higlo = opamSelection.higlo;
      js_of_ocaml = opamSelection.js_of_ocaml or null;
      lwt = opamSelection.lwt or null;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      ocamlnet = opamSelection.ocamlnet;
      ocf = opamSelection.ocf;
      ojs-base = opamSelection.ojs-base or null;
      ppx_blob = opamSelection.ppx_blob;
      sha = opamSelection.sha or null;
      websocket = opamSelection.websocket or null;
      xmldiff = opamSelection.xmldiff or null;
      xmlm = opamSelection.xmlm;
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
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "stog-0.15.0";
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
  postUnpack = "cp -r ${./files}/* \"$sourceRoot/\"";
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "1mwipcfbbfq0w6cqzdg1mpkdqmfpp5f4andw055c3d116dm3jv5g";
    url = "http://zoggy.github.com/stog/stog-0.15.0.tar.gz";
  };
}

