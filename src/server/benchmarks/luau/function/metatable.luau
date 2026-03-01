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
local a = {}
a.__index = a
a.b = function(self) end
local c = setmetatable({}, a)
-- Class
return Benchmark.new(
	{
		TAGS.OPERATIONS.METATABLE,
		TAGS.OPERATIONS.CALL,
		TAGS.TYPES.FUNCTION,
		TAGS.TYPES.TABLE,
	},
	{},
	function()
		c:b()
		return nil
	end :: any,
	100_000,
	1_000
)
