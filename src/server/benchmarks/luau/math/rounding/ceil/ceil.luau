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
		TAGS.OPERATIONS.CEIL,
		TAGS.TYPES.NUMBER,
	},
	{
		Benchmark.Parameter.Float.new("value"),
	},
	function(value: number)
		return math.ceil(value)
	end :: any,
	50_000,
	2_000
)
