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
		Benchmark.Parameter.Buffer.new("b"),
	},
	function(b: buffer)
		return buffer.tostring(b)
	end :: any,
	10_000,
	100
)
