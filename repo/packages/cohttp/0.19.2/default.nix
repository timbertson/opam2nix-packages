world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      async = opamSelection.async or null;
      base-bytes = opamSelection.base-bytes;
      base64 = opamSelection.base64;
      cmdliner = opamSelection.cmdliner;
      conduit = opamSelection.conduit;
      fieldslib = opamSelection.fieldslib;
      js_of_ocaml = opamSelection.js_of_ocaml or null;
      lwt = opamSelection.lwt or null;
      magic-mime = opamSelection.magic-mime;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      re = opamSelection.re;
      sexplib = opamSelection.sexplib;
      stringext = opamSelection.stringext;
      uri = opamSelection.uri;
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
  name = "cohttp-0.19.2";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "cohttp";
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "0kj177l3j5i36qaybpm0vq166qxibya7ypwdax42vgdrd4b7788l";
    url = "https://github.com/mirage/ocaml-cohttp/archive/v0.19.2.tar.gz";
  };
}

