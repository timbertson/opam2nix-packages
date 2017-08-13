world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      anycache = opamSelection.anycache;
      async_kernel = opamSelection.async_kernel;
      async_unix = opamSelection.async_unix;
      base-bytes = opamSelection.base-bytes;
      core = opamSelection.core;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      topkg-jbuilder = opamSelection.topkg-jbuilder;
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
  name = "anycache-async-0.7.4";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "anycache-async";
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
    sha256 = "0133aw9pswd0j8k9w3h5cjmm2r31bhdhky6dyayiq1fr8k8xiby4";
    url = "https://gitlab.com/edwintorok/ocaml-anycache/uploads/47d27fb2e3ac835994d7b546872b12cb/anycache-0.7.4.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

