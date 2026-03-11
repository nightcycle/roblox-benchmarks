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
		Benchmark.Parameter.Buffer.new("target", CONSTANTS.DEFAULT_BUFFER_SIZE_BYTES / 2),
		Benchmark.Parameter.Integer.new("targetOffset", 0, CONSTANTS.DEFAULT_BUFFER_SIZE_BYTES / 2 - 1),
		Benchmark.Parameter.Integer.new("value", 0, 2 ^ 8 - 1),
		Benchmark.Parameter.Integer.new("count", 0, CONSTANTS.DEFAULT_BUFFER_SIZE_BYTES / 2 - 1),
	},
	function(target: buffer, targetOffset: number, value: number, count: number)
		return buffer.fill(target, targetOffset, value, count)
	end :: any,
	10_000,
	100
)
