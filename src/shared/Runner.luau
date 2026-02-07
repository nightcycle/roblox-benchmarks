--!strict
-- Services
-- Packages
-- Modules
local Benchmark = require(game.ReplicatedStorage.Shared.Benchmark)
local SaveUtil = require(game.ReplicatedStorage.Shared.SaveUtil)
local Logger = require(game.ReplicatedStorage.Shared.Logger)
-- Types
type Benchmark = Benchmark.Benchmark
type Sample = {
	Inputs: { any },
	Elapsed: number, -- pico seconds
}
export type Summary = {
	read Benchmark: Benchmark,
	read Data: { Sample }, -- pico seconds,normalized by benchmark re-runs
	read Stats: { -- pico seconds (x1_000_000_000_000)
		Min: number,
		Max: number,
		Mean: number,
		StandardDeviation: number,
		P10: number,
		P50: number,
		P90: number,
	},
	toCSVRow: (self: Summary) -> string, -- for summary CSV
	exportToCSV: (self: Summary) -> string, -- for finding trends in parameters
}
export type Runner = {
	read Target: ModuleScript,
	load: (self: Runner) -> Benchmark,
	solve: (self: Runner, rng: Random) -> Summary,
	save: (self: Runner, summary: Summary, isFlat: boolean) -> (),
}
-- Constants
local CONSTANTS = require(game.ReplicatedStorage.Shared.CONSTANTS)
local SUMMARY_PATH = "summary.csv"
local SUMMARY_CSV_HEADER =
	"bench.path,bench.duration,bench.samples,bench.repeats,stats.mean,stats.stddev,stats.p10,stats.p50,stats.p90,stats.min,stats.max"
-- Variables
-- References
-- Private Functions
function toBasePath(fullName: string, separator: string): string
	local basePath = fullName:gsub("%.", separator)
	local foundBenchmark = false
	local parts = {}
	local serviceName: string?
	for i, segment in
		if separator == "/"
			then basePath:split("/")
			elseif separator == "." then basePath:split("%.")
			else basePath:split(separator)
	do
		if i == 1 then
			serviceName = segment
		end
		if segment == "benchmarks" then
			foundBenchmark = true
			continue
		end
		if foundBenchmark then
			table.insert(parts, segment)
		end
	end
	assert(serviceName, `bad serviceName: "{serviceName}"`)
	if serviceName == "ReplicatedStorage" then
		table.insert(parts, 1, "client")
	elseif serviceName == "ServerScriptService" then
		table.insert(parts, 1, "server")
	else
		error(`unknown serviceName: "{serviceName}"`)
	end

	basePath = table.concat(parts, separator)
	return basePath
end
-- Get the standard deviation of a table
-- Class
local Runner = {}

function Runner.new(target: ModuleScript): Runner
	Logger.log(`constructed runner for {target:GetFullName()}`)
	return {
		Target = target,
		load = function(self: Runner): Benchmark
			local benchmarkModule = require(self.Target) :: Benchmark
			return benchmarkModule
		end,
		solve = function(self: Runner, rng: Random): Summary
			Logger.log(`solving {target:GetFullName()}`)

			local testStart = os.clock()
			local benchmark = self:load()
			local data: { Sample } = {}

			local sampleParameters = table.create(benchmark.Samples)

			for sample = 1, benchmark.Samples do
				sampleParameters[sample] = benchmark:generate(rng)
			end
			table.freeze(sampleParameters)
			local function run(...: any): Sample
				local minElapsed = 0
				do
					local startTime = os.clock()
					for repeatIndex = 1, benchmark.Repeats do
						-- empty run
					end
					local stopTime = os.clock()
					minElapsed = stopTime - startTime
				end
				local startTime = os.clock()
				for repeatIndex = 1, benchmark.Repeats do
					benchmark.Method(...)
				end
				local stopTime = os.clock()
				local elapsed = stopTime - startTime - minElapsed
				assert(
					elapsed > 0,
					`target "{self.Target:GetFullName()}" ran in 0 or less time ({elapsed} s), increase the number of repeats for such a low-level benchmark`
				)
				local normalized = math.ceil((elapsed / benchmark.Repeats) * 1_000_000_000_000) -- pico seconds
				return {
					Inputs = { ... },
					Elapsed = normalized,
				}
			end

			local count = benchmark.Samples
			for sample = 1, count do
				if sample % CONSTANTS.PAUSE_EVERY_N_SAMPLES == 0 then
					task.wait()
				end
				local params = sampleParameters[sample]
				data[sample] = run(table.unpack(params :: any, 1, #benchmark.Parameters))
			end
			Logger.log(`\tsolve - summarizing {target:GetFullName()}`)

			do
				local min = math.huge
				local max = -math.huge
				local mean: number
				do
					local sum = 0
					for i, sample in data do
						min = math.min(min, sample.Elapsed)
						max = math.max(max, sample.Elapsed)
						sum += sample.Elapsed
					end
					mean = sum / count
				end
				local standardDeviation: number
				do --http://lua-users.org/wiki/SimpleStats
					local variance = 0
					for i, sample in data do
						local vm = sample.Elapsed - mean
						variance += vm * vm
					end
					standardDeviation = math.sqrt(variance / (count - 1))
				end

				local p10: number, p50: number, p90: number
				do -- https://gist.github.com/ZeroStride/3485c35e2583e5aca3978d54f2004399
					local temp: { number } = {}

					-- deep copy table so that when we sort it, the original is unchanged
					-- also weed out any non numbers
					for k, v in pairs(data) do
						table.insert(temp, v.Elapsed)
					end

					table.sort(temp)

					local function percentile(p: number): number
						local index = p * #temp
						local percentile = temp[math.ceil(index)]
						if index == math.ceil(index) then
							percentile = (temp[index] + temp[index + 1]) / 2
						end
						return percentile
					end
					p10 = percentile(0.1)
					p50 = percentile(0.5)
					p90 = percentile(0.9)
				end
				local testStop = os.clock()
				Logger.log(`\tsolve - finished {target:GetFullName()} in {testStop - testStart}s`)
				return {
					Benchmark = benchmark,
					Data = data,
					Stats = {
						Min = min,
						Max = max,
						Mean = math.ceil(mean),
						StandardDeviation = math.ceil(standardDeviation),
						P10 = math.ceil(p10),
						P50 = math.ceil(p50),
						P90 = math.ceil(p90),
					},
					toCSVRow = function(self: Summary): string
						-- "bench.path,bench.start,bench.stop,bench.samples,bench.repeats,stats.min,stats.max,stats.mean,stats.stddev,stats.p10,stats.p50,stats.p90"
						local moduleKey = toBasePath(target:GetFullName(), "/")
						return table.concat({
							moduleKey,
							testStop - testStart,
							benchmark.Samples,
							benchmark.Repeats,
							math.ceil(mean),
							math.ceil(standardDeviation),
							math.ceil(p10),
							math.ceil(p50),
							math.ceil(p90),
							min,
							max,
						}, ",")
					end,
					exportToCSV = function(self: Summary): string
						local rows = {}
						local headers = { "elapsed.ps", "repeats.n" }
						for i, param in self.Benchmark.Parameters do
							table.insert(headers, ("param." .. param.Key .. "." .. param.Type):lower())
						end
						table.insert(rows, table.concat(headers, ","))
						for j = 1, self.Benchmark.Samples do
							local data = self.Data[j]
							local row: { string } = {
								tostring(data.Elapsed),
								tostring(self.Benchmark.Repeats),
							}
							for i, param in self.Benchmark.Parameters do
								local paramValue = data.Inputs[i]
								if param.Type == "Array" then
									paramValue = `array<{param.ValueType.Type:lower()}>[{#(paramValue :: { any })}]`
								elseif param.Type == "Map" then
									paramValue =
										`map<{param.KeyType.Type:lower()},{param.ValueType.Type:lower()}>[{if param.MaxLength
												and param.MaxLength == param.MinLength
											then param.MaxLength
											else ""}]`
								end
								local str = tostring(paramValue):gsub(",", ";") -- escape commas
								table.insert(row, str)
							end
							table.insert(rows, table.concat(row, ","))
						end
						return table.concat(rows, "\n")
					end,
				}
			end
		end,
		save = function(self: Runner, summary: Summary, isFlat: boolean): ()
			-- no-op
			local separator = if isFlat then "-" else "/"
			local basePath = toBasePath(self.Target:GetFullName(), separator)

			do
				SaveUtil.appendCSV(SUMMARY_PATH, summary:toCSVRow(), SUMMARY_CSV_HEADER)
			end
			do
				local detailedCSVPath = basePath .. ".csv"
				SaveUtil.saveCSV(detailedCSVPath, summary:exportToCSV())
			end
		end,
	}
end

return Runner
