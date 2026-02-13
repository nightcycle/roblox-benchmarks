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
		TAGS.OPERATIONS.MOD,
		TAGS.TYPES.NUMBER,
	},
	{
		Benchmark.Parameter.Float.new("value"),
	},
	function(value: number)
		local m = value % 1
		if m >= 0.5 then
			return value - m + 1
		else
			return value - m
		end
	end :: any,
	100_000,
	1_000
)
