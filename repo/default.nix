world:
	let
	lib = world.pkgs.lib;
	fix = f: let result = f result; in result;
	extend = rattrs: f: self: let super = rattrs self; in super // f { inherit self super; };
	defaultOverrides = import ./overrides;
	packageDefs = import ./packages;
	userOverrides = world.overrides or ({super, self}: {});
	format_version = import ./format_version.nix;

	# packages have structure <name>.<version> - we want to combine all versions across
	# repos without merging the derivation attributes of individual versions
	mergeTwoLevels = lib.recursiveUpdateUntil (parent: l: r: (lib.length parent) == 1);
	mergePackageSets = sources: self: lib.foldl (acc: p: mergeTwoLevels acc (p self)) {} sources;
	basePackages = self: world // {
		overrideOcaml = world.pkgs.callPackage ./overrides/ocaml.nix {};
		opamPackages = mergePackageSets ([ packageDefs ] ++ (world.extraPackages or [])) self;
	};

	addSelection = ({super, self}: { opamSelection = world.select self; });
in
	assert format_version == world.format_version;
	assert format_version == world.opam2nix.format_version;
	fix
	(extend
		(extend
			(extend
				basePackages
				defaultOverrides)
			addSelection)
		userOverrides)
