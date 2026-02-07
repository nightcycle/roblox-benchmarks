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
		Benchmark.Parameter.Vector3.new("a"),
	},
	function(a: Vector3)
		return a:Ceil()
	end :: any,
	100_000,
	1_000
)
