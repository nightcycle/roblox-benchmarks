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
		TAGS.LIBRARIES.MATH,
		TAGS.OPERATIONS.FLOOR,
		TAGS.TYPES.NUMBER,
	},
	{
		Benchmark.Parameter.Float.new("value"),
	},
	function(value: number)
		return math.floor(value)
	end :: any,
	100_000,
	1_000
)
