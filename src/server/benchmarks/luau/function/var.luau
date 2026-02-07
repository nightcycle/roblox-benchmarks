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
local a = function() end
-- Class
return Benchmark.new(
	{},
	function()
		a()
		return nil
	end :: any,
	100_000,
	1_000
)
