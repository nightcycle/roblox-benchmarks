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
local a = {
	b = function() end,
}
-- Class
return Benchmark.new(
	{},
	function()
		a.b()
		return nil
	end :: any,
	100_000,
	1_000
)
