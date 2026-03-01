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
		TAGS.TYPES.STRING,
		TAGS.FINDINGS.BACKTICK_IS_FAST,
	},
	{
		Benchmark.Parameter.Integer.new("value"),
	},
	function(a: number)
		return "" .. a
	end :: any,
	100_000,
	1_000
)
