-- Services
-- Packages
-- Modules
local Benchmark = require(game.ReplicatedStorage.Shared.Benchmark)
-- Types
-- Constants
local CONSTANTS = require(game.ReplicatedStorage.Shared.CONSTANTS)
-- Variables
-- References
-- Private Functions
-- Class
return Benchmark.new(
	{
		Benchmark.Parameter.Integer.new("len", 1, CONSTANTS.DEFAULT_BUFFER_SIZE_BYTES),
	},
	function(len: number)
		return buffer.create(len)
	end :: any,
	10_000,
	100
)
