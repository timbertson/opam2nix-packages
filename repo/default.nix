world:
	let
	fix = f: let result = f result; in result;
	extend = rattrs: f: self: let super = rattrs self; in super // f { inherit self super; };
	defaultOverrides = import ./overrides;
	packageDefs = import ./packages;
	userOverrides = world.overrides or ({super, self}: {});
	format_version = import ./format_version.nix;
	basePackages = self: world // { opamPackages = packageDefs self; };
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
