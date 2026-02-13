--!strict
-- Services
-- Packages
-- Modules
local Benchmark = require(game.ReplicatedStorage.Shared.Benchmark)
-- Types
-- Constants
local TAGS = require(game.ReplicatedStorage.Shared.TAGS)
-- Variables
-- References
-- Private Functions
-- Class
return Benchmark.new(
	{
		TAGS.PATTERNS.LOOP,
		TAGS.FINDINGS.FOR_LOOP_IS_SLOWEST_LOOP,
	},
	{
		Benchmark.Parameter.Array.new("array", Benchmark.Parameter.Integer.new("value"), true, 1, 1),
	},
	function(array: { number })
		local a
		repeat
			a = array[1]
		until a
		return nil
	end :: any,
	100_000,
	1_000
)
