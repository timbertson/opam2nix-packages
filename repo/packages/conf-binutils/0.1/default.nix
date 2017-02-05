world:
let
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.arm-aout-binutils or null) (pkgs.arm-elf-binutils or null)
        (pkgs.arm-none-eabi-binutils or null) (pkgs.binutils or null)
        (pkgs.binutils-multiarch or null) (pkgs.i386-elf-binutils or null)
        (pkgs.i386-mingw32-binutils or null)
        (pkgs.x86_64-elf-binutils or null) ] ++ (lib.attrValues opamDeps));
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
  buildPhase = "${opam2nix}/bin/opam2nix invoke build";
  configurePhase = "true";
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "conf-binutils-0.1";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "conf-binutils";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  prePatch = "cp -r ${./files}/* ./";
  propagatedBuildInputs = inputs;
  unpackPhase = "true";
}

