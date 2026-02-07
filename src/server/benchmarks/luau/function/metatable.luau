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
local a = {}
a.__index = a
a.b = function(self) end
local c = setmetatable({}, a)
-- Class
return Benchmark.new(
	{},
	function()
		c:b()
		return nil
	end :: any,
	100_000,
	1_000
)
