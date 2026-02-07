--!strict
-- Services
-- Packages
-- Modules
local Benchmark = require(game.ReplicatedStorage.Shared.Benchmark)
-- Types
-- Constants
local RED_VAL = BrickColor.Red().Number
-- Variables
-- References
-- Private Functions
-- Class
return Benchmark.new(
	{},
	function()
		return BrickColor.palette(RED_VAL)
	end :: any,
	100_000,
	1_000
)
