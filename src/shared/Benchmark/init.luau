--!strict
-- Services
-- Packages
-- Modules
local Parameter = require(script.Parameter)
-- Types
export type Parameter = Parameter.Parameter
export type Benchmark = {
	read Repeats: number, -- how many times to re-run with the same parameters
	read Samples: number, -- how many times the benchmark is run
	read Parameters: { Parameter },
	read Method: (...any) -> (),
	generate: (self: Benchmark, rng: Random) -> { any },
}
-- Constants
local CONSTANTS = require(game.ReplicatedStorage.Shared.CONSTANTS)
-- Variables
-- References
-- Private Functions
-- Class
local Benchmark = {}

Benchmark.Parameter = Parameter

function Benchmark.new(
	parameters: { Parameter },
	method: (...any) -> (),
	repeats: number?,
	samples: number?
)
	return {
		Parameters = parameters,
		Method = method,
		Repeats = repeats or CONSTANTS.DEFAULT_REPEATS,
		Samples = samples or CONSTANTS.DEFAULT_SAMPLES,
		generate = function(self: Benchmark, rng: Random): { any }
			local generatedParams: { any } = table.create(#self.Parameters)
			for i, param in self.Parameters do
				generatedParams[i] = Parameter.Any.generate(param, rng)
			end
			return generatedParams
		end,
	}
end

return Benchmark
