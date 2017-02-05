world:
let
    inputs = lib.filter (dep: dep != true && dep != null)
    ([
        (pkgs."https://gist.githubusercontent.com/fdopen/cbfb14114f4ec423a1a4/raw/6ba4cef74e94a7307391bddb7ff20db5d8065bfe/install-libuv.sh" or null)
        (pkgs.libuv or null) (pkgs.libuv-dev or null)
        (pkgs.libuv-devel or null) (pkgs.libuv1-dev or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      conf-pkg-config = opamSelection.conf-pkg-config;
      ocaml = opamSelection.ocaml;
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
  name = "conf-libuv-1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "conf-libuv";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  propagatedBuildInputs = inputs;
  unpackPhase = "true";
}

