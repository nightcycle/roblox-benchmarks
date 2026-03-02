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
local a = function() end
-- Class
return Benchmark.new(
	{
		TAGS.TYPES.FUNCTION,
		TAGS.OPERATIONS.CALL,
	},
	{},
	function()
		a()
		return nil
	end :: any,
	250_000,
	1_000
)
