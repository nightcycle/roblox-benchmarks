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
		TAGS.TYPES.ARRAY,
		TAGS.TYPES.TABLE,
		TAGS.OPERATIONS.WRITE,
		TAGS.OPERATIONS.ASSIGN,
	},
	{
		Benchmark.Parameter.Integer.new("a", 1),
		Benchmark.Parameter.Integer.new("b", 1),
		Benchmark.Parameter.Integer.new("c", 1),
	},
	function(a: number, b: number, c: number)
		local _1, _2, _3 = a, b, c
	end :: any,
	100_000,
	1_000
)
