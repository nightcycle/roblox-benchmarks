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
	read _Parameters: { Parameter },
	read Method: (...any) -> (),
	flatten: (self: Benchmark) -> { Parameter },
	generate: (self: Benchmark, rng: Random) -> { any },
}
-- Constants
local CONSTANTS = require(game.ReplicatedStorage.Shared.CONSTANTS)
-- Variables
-- References
-- Private Functions
function flattenParameters(params: { Parameter }): { Parameter }
	local unpackedParams: { any } = {}
	for _, param in params do
		if param.Type == "Tuple" then
			local tupleValues = flattenParameters(param.ValueTypes)
			for i = 1, #tupleValues do
				table.insert(unpackedParams, tupleValues[i])
			end
		else
			table.insert(unpackedParams, param)
		end
	end
	return unpackedParams
end
-- Class
local Benchmark = {}

Benchmark.Parameter = Parameter

function Benchmark.new(parameters: { Parameter }, method: (...any) -> (), repeats: number?, samples: number?)
	return {
		Parameters = parameters,
		Method = method,
		Repeats = repeats or CONSTANTS.DEFAULT_REPEATS,
		Samples = samples or CONSTANTS.DEFAULT_SAMPLES,
		flatten = function(self: Benchmark): { Parameter }
			return flattenParameters(self._Parameters, {}, 1)
		end,
		generate = function(self: Benchmark, rng: Random): { any }
			local generatedParams: { any } = table.create(#self:flatten())
			local index = 1
			local function generateParams(params: { Parameter })
				for _, param in params do
					if param.Type == "Tuple" then
						local tupleValues = { Parameter.Any.generate(param, rng) }
						for i = 1, #flattenParameters(param.ValueTypes) do
							generatedParams[index] = tupleValues[i]
							index += 1
						end
					else
						generatedParams[index] = Parameter.Any.generate(param, rng)
						index += 1
					end
				end
			end
			generateParams(self._Parameters)
			return generatedParams
		end,
	}
end

return Benchmark
