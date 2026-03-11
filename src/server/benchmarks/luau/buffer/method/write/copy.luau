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
		Benchmark.Parameter.Integer.new("targetOffset", 0, CONSTANTS.DEFAULT_BUFFER_SIZE_BYTES / 4 - 1),
		Benchmark.Parameter.Buffer.new(
			"source",
			CONSTANTS.DEFAULT_BUFFER_SIZE_BYTES / 4,
			CONSTANTS.DEFAULT_BUFFER_SIZE_BYTES / 2
		),
		Benchmark.Parameter.Integer.new("sourceOffset", 0, CONSTANTS.DEFAULT_BUFFER_SIZE_BYTES / 8 - 1),
		Benchmark.Parameter.Integer.new("count", 0, CONSTANTS.DEFAULT_BUFFER_SIZE_BYTES / 8 - 1),
	},
	function(target: buffer, targetOffset: number, source: buffer, sourceOffset: number, count: number)
		return buffer.copy(target, targetOffset, source, sourceOffset, count)
	end :: any,
	10_000,
	100
)
