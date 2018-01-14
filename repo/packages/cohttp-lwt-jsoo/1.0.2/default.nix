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
      cohttp-lwt = opamSelection.cohttp-lwt;
      jbuilder = opamSelection.jbuilder;
      js_of_ocaml = opamSelection.js_of_ocaml;
      js_of_ocaml-lwt = opamSelection.js_of_ocaml-lwt;
      js_of_ocaml-ppx = opamSelection.js_of_ocaml-ppx;
      lwt = opamSelection.lwt;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
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
  name = "cohttp-lwt-jsoo-1.0.2";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "cohttp-lwt-jsoo";
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
    sha256 = "1x87laql7ksfq9324iq3yrx81dfjdm0knd40h880d02ny6g299v4";
    url = "https://github.com/mirage/ocaml-cohttp/releases/download/v1.0.2/cohttp-1.0.2.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

