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
		TAGS.TYPES.VECTOR2,
		TAGS.OPERATIONS.INIT,
		TAGS.FINDINGS.VECTOR2_IS_SLOW,
	},
	{},
	function()
		return Vector2.new()
	end :: any,
	100_000,
	1_000
)
