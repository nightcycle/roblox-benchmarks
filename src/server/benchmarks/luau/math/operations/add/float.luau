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
		TAGS.OPERATIONS.ADD,
		TAGS.TYPES.VECTOR2,
	},
	{
		Benchmark.Parameter.Float.new("a"),
		Benchmark.Parameter.Float.new("b"),
	},
	function(a: number, b: number)
		return a + b
	end :: any,
	100_000,
	1_000
)
