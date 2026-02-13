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
local a = {
	b = function(self) end,
}
-- Class
return Benchmark.new(
	{
		TAGS.TYPES.FUNCTION,
		TAGS.TYPES.TABLE,
		TAGS.OPERATIONS.CALL,
	},
	{},
	function()
		a:b()
		return nil
	end :: any,
	100_000,
	1_000
)
