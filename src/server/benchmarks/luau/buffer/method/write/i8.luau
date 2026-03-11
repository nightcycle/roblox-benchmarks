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
		Benchmark.Parameter.Buffer.new(
			"b",
			CONSTANTS.DEFAULT_BUFFER_SIZE_BYTES / 2,
			CONSTANTS.DEFAULT_BUFFER_SIZE_BYTES
		),
		Benchmark.Parameter.Integer.new("offset", 0, (CONSTANTS.DEFAULT_BUFFER_SIZE_BYTES / 2) - 1),
		Benchmark.Parameter.Integer.new("value", -128, 127),
	},
	function(b: buffer, offset: number, value: number)
		return buffer.writei8(b, offset, value)
	end :: any,
	10_000,
	100
)
