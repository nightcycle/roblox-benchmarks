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
local function a() end
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
	100_000,
	1_000
)
