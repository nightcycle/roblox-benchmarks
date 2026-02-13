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
		TAGS.FINDINGS.FOR_LOOP_ITERATORS_ARE_SLOW,
		TAGS.FINDINGS.FOR_LOOP_IS_SLOWEST_LOOP,
	},
	{
		Benchmark.Parameter.Array.new("array", Benchmark.Parameter.Integer.new("value"), true, 1, 1),
	},
	function(array: { number })
		for i = 1, #array do
			local _ = array[i]
		end
		return nil
	end :: any,
	100_000,
	1_000
)
