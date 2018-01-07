world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([ (pkgs.libsnmp-dev or null) (pkgs.libsnmp30 or null)
        (pkgs.net-snmp-dev or null) (pkgs.net-snmp-devel or null)
        (pkgs.net-snmp-libs or null) ] ++ (lib.attrValues opamDeps));
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
  name = "conf-netsnmp-1.0.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "conf-netsnmp";
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
    sha256 = "14vjdl8db93gqz3k73s8xdaqi3qiq15b2kyrl9w5crp691dcg4v9";
    url = "https://www.github.com/stevebleazard/ocaml-conf-netsnmp/releases/download/v1.0.0/conf-netsnmp-1.0.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

