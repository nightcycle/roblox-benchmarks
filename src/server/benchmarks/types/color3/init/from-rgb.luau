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
		Benchmark.Parameter.Integer.new("r", 0, 255),
		Benchmark.Parameter.Integer.new("g", 0, 255),
		Benchmark.Parameter.Integer.new("b", 0, 255),
	},
	function(r: number, g: number, b: number)
		return Color3.fromRGB(r, g, b)
	end :: any,
	100_000,
	1_000
)
