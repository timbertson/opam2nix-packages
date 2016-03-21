world:
let
    inputs = lib.filter (dep: dep != true && dep != null)
    ([
        (pkgs."https://gist.githubusercontent.com/fdopen/cbfb14114f4ec423a1a4/raw/1d4144f16aa2c65d39a1be5aae39911dc5e53ef6/install-libuv.sh" or null)
        (pkgs.libuv or null) (pkgs.pkg-config or null) (pkgs.pkgconf or null) ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      ocaml = opamSelection.ocaml;
    };
    opamSelection = world.opamSelection;
    pkgs = world.pkgs;
in
pkgs.stdenv.mkDerivation 
{
  buildInputs = inputs;
  buildPhase = "true";
  installPhase = "mkdir -p $out";
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

