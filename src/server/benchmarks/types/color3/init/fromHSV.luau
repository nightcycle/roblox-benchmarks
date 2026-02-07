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
		Benchmark.Parameter.Integer.new("h", 0, 255),
		Benchmark.Parameter.Integer.new("s", 0, 255),
		Benchmark.Parameter.Integer.new("v", 0, 255),
	},
	function(h: number, s: number, v: number)
		return Color3.fromHSV(h, s, v)
	end :: any,
	100_000,
	1_000
)
