--!strict
-- Services
-- Packages
-- Modules
local Benchmark = require(game.ReplicatedStorage.Shared.Benchmark)
local SaveUtil = require(game.ReplicatedStorage.Shared.SaveUtil)
local Logger = require(game.ReplicatedStorage.Shared.Logger)
local ENV = require(game.ReplicatedStorage.Shared.ENV)
-- Types
type Benchmark = Benchmark.Benchmark
type Sample = {
	Inputs: { any },
	Elapsed: number, -- pico seconds
}
export type Overview = {
	read Benchmark: Benchmark,
	read Data: { Sample }, -- pico seconds,normalized by benchmark re-runs
	exportToCSV: (self: Overview) -> string, -- for finding trends in parameters
}
export type Runner = {
	read Target: ModuleScript,
	load: (self: Runner) -> Benchmark,
	solve: (self: Runner, rng: Random) -> Overview,
	save: (self: Runner, overview: Overview, isFlat: boolean) -> (),
}
-- Constants
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
			Logger.log(`\t - load - loading {target:GetFullName()}`)
			local benchmarkModule = require(self.Target) :: Benchmark
			return benchmarkModule
		end,
		solve = function(self: Runner, rng: Random): Overview
			Logger.log(`\t - solve - starting {target:GetFullName()}`)

			local testStart = os.clock()
			local benchmark = self:load()
			local data: { Sample } = {}

			local sampleParameters = table.create(benchmark.Samples)
			Logger.log(`\tsolve - generating parameters for {target:GetFullName()}`)
			for sample = 1, benchmark.Samples do
				sampleParameters[sample] = benchmark:generate(rng)
			end
			table.freeze(sampleParameters)
			task.wait()
			local minElapsed = 0
			do
				local startTime = os.clock()
				for repeatIndex = 1, benchmark.Repeats do
					-- empty run
				end
				local stopTime = os.clock()
				minElapsed = stopTime - startTime
			end
			local baseline = math.ceil((minElapsed / benchmark.Repeats) * 1_000_000_000_000)
			local function run(...: any): Sample
				local startTime = os.clock()
				for repeatIndex = 1, benchmark.Repeats do
					benchmark.Method(...)
				end
				local stopTime = os.clock()
				local elapsed = (stopTime - startTime)
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
			Logger.log(`\tsolve - running {count} samples for {target:GetFullName()}`)
			for sample = 1, count do
				local params = sampleParameters[sample]
				data[sample] = run(table.unpack(params :: any, 1, #benchmark.Parameters))
			end
			Logger.log(`\tsolve - summarizing {target:GetFullName()}`)
			for i, v in sampleParameters do
				if typeof(v) == "Instance" then
					pcall(function(...)
						v:Destroy()
					end)
				end
			end
			do
				local testStop = os.clock()
				Logger.log(`\tsolve - finished {target:GetFullName()} in {testStop - testStart}s`)
				return {
					Benchmark = benchmark,
					Data = data,
					exportToCSV = function(self: Overview): string
						local rows = {}
						local headers = { "runner.index", "runner.baseline.ps", "elapsed.ps", "repeats.n" }
						for i, param in self.Benchmark.Parameters do
							table.insert(headers, ("param." .. param.Key .. "." .. param.Type):lower())
						end
						table.insert(rows, table.concat(headers, ","))
						for j = 1, self.Benchmark.Samples do
							local data = self.Data[j]
							local row: { string } = {
								tostring(ENV.RUNNER_INDEX),
								tostring(baseline),
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
		save = function(self: Runner, overview: Overview, isFlat: boolean): ()
			-- no-op
			local separator = if isFlat then "-" else "/"
			local basePath = toBasePath(self.Target:GetFullName(), separator)

			do
				local detailedCSVPath = basePath .. ".csv"
				local rawCSV = overview:exportToCSV()
				local lines = rawCSV:split("\n")
				local header = lines[1]
				table.remove(lines, 1)
				rawCSV = table.concat(lines, "\n")
				SaveUtil.appendCSV(detailedCSVPath, rawCSV, header)
			end
		end,
	}
end

return Runner
