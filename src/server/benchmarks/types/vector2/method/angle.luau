--!strict
-- Services
-- Packages
-- Modules
local Benchmark = require(game.ReplicatedStorage.Shared.Benchmark)
-- Types
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
return Benchmark.new(
	{
		Benchmark.Parameter.Vector2.new("a"),
		Benchmark.Parameter.Vector2.new("b"),
		Benchmark.Parameter.Boolean.new("isSigned"),
	},
	function(a: Vector2, b: Vector2, isSigned: boolean)
		return a:Angle(b, isSigned)
	end :: any,
	100_000,
	1_000
)
