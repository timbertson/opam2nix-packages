world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      astring = opamSelection.astring;
      cohttp = opamSelection.cohttp;
      conduit = opamSelection.conduit;
      lwt = opamSelection.lwt;
      magic-mime = opamSelection.magic-mime;
      mirage-channel-lwt = opamSelection.mirage-channel-lwt;
      mirage-conduit = opamSelection.mirage-conduit;
      mirage-flow-lwt = opamSelection.mirage-flow-lwt;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      result = opamSelection.result;
      topkg = opamSelection.topkg;
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
  name = "mirage-http-3.1.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mirage-http";
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
    sha256 = "0s75jnijn5j93y2j9v2xka5ll2xi5ak8nzl6lm0fqwhxnx2rp59d";
    url = "https://github.com/mirage/mirage-http/releases/download/3.1.0/mirage-http-3.1.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

