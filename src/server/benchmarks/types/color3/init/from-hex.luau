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
		TAGS.OPERATIONS.INIT,
	},
	{
		Benchmark.Parameter.HexString.new("hex"),
	},
	function(hex: string)
		return Color3.fromHex(hex)
	end :: any,
	100_000,
	1_000
)
