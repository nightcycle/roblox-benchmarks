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
		Benchmark.Parameter.HexString.new("hex"),
	},
	function(hex: string)
		return Color3.fromHex(hex)
	end :: any,
	100_000,
	1_000
)
