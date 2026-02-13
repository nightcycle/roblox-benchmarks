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
		TAGS.TYPES.COLOR3,
		TAGS.OPERATIONS.LERP,
	},
	{
		Benchmark.Parameter.Color3.new("a"),
		Benchmark.Parameter.Color3.new("b"),
		Benchmark.Parameter.Float.new("alpha", 0, 1),
	},
	function(a: Color3, b: Color3, alpha: number)
		return a:Lerp(b, alpha)
	end :: any,
	100_000,
	1_000
)
