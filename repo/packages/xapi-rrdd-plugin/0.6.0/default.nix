world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind or null;
      rpc = opamSelection.rpc;
      xapi-forkexecd = opamSelection.xapi-forkexecd;
      xapi-idl = opamSelection.xapi-idl;
      xapi-libs-transitional = opamSelection.xapi-libs-transitional;
      xapi-rrd-transport = opamSelection.xapi-rrd-transport;
      xapi-stdext = opamSelection.xapi-stdext;
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
  name = "xapi-rrdd-plugin-0.6.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "xapi-rrdd-plugin";
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
    sha256 = "1xzlr4vr08rimj9zgqpyalgb44x1y1zw50jx2ixrk7j2i6adwl9k";
    url = "https://github.com/xapi-project/ocaml-rrdd-plugin/archive/0.6.0.tar.gz";
  };
}

