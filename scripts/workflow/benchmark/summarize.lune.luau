--!strict
local fs = require("@lune/fs")
local process = require("@lune/process")

local DATA_DIR = process.args[1]
assert(DATA_DIR, `bad arg1 / DATA_DIR`)
local OUT_PATH = DATA_DIR .. "/summary.csv"
type CSV = {
	headers: { [string]: number },
	rows: { { [string]: string } },
}

function parseHeader(header: string): { [string]: number }
	local headers = header:split(",")
	local result = {}
	for i, name in ipairs(headers) do
		result[name] = i
	end
	return result
end

function parseCSV(path: string): CSV
	local content = fs.readFile(path):gsub("\r", "")
	local lines = content:split("\n")
	local headerList = parseHeader(lines[1])
	table.remove(lines, 1)
	local rows = {}
	for i, line in ipairs(lines) do
		if line == "" and i == #lines then
			break
		end
		local values = line:split(",")
		local row = {}
		for headerName, headerIndex in pairs(headerList) do
			row[headerName] = values[headerIndex] or ""
		end
		table.insert(rows, row)
	end
	return {
		headers = headerList,
		rows = rows,
	}
end
function bakeCSV(csv: CSV): string
	local out = {}
	local headers = {}
	for headerName, i in pairs(csv.headers) do
		headers[i] = headerName
	end
	table.insert(out, table.concat(headers, ","))
	for _, row in ipairs(csv.rows) do
		local line: { string } = {}
		for _, headerName in ipairs(headers) do
			local value = row[headerName] or ""
			value = value:gsub(",", ";") -- escape commas
			table.insert(line, value)
		end
		table.insert(out, table.concat(line, ","))
	end
	return table.concat(out, "\n")
end
type DataRow = {
	["runner.index.n"]: number,
	["runner.baseline.ps"]: number,
	["elapsed.ps"]: number,
	["repeats.n"]: number,
}
function unpackData(csv: CSV): { DataRow }
	local out = {}
	for _, row in ipairs(csv.rows) do
		local runnerIndex = tonumber(row["runner.index.n"] or row["runner.index"])
		assert(runnerIndex, `bad runnerIndex`)
		local baseline = tonumber(row["runner.baseline.ps"])
		assert(baseline, `bad baseline`)
		local elapsed = tonumber(row["elapsed.ps"])
		assert(elapsed, `bad elapsed`)
		local repeats = tonumber(row["repeats.n"])
		assert(repeats, `bad repeats`)
		local dataRow: DataRow = {
			["runner.index.n"] = runnerIndex,
			["runner.baseline.ps"] = baseline,
			["elapsed.ps"] = elapsed,
			["repeats.n"] = repeats,
		}
		table.insert(out, dataRow)
	end
	return out
end
function getAverageBaseline(dataSets: { [any]: { DataRow } }): number
	local total: { number } = {}
	for _, dataSet in pairs(dataSets) do
		local runDataSets: { { number } } = {}
		for _, dataRow in pairs(dataSet) do
			local runnerIndex = dataRow["runner.index.n"]
			if not runDataSets[runnerIndex] then
				runDataSets[runnerIndex] = {}
			end
			table.insert(runDataSets[runnerIndex], dataRow["runner.baseline.ps"])
		end
		for i, runDataSet in pairs(runDataSets) do
			local sum = 0
			for _, baseline in pairs(runDataSet) do
				sum += baseline
			end
			table.insert(total, sum / #runDataSet)
		end
	end
	local sum = 0
	local count = 0
	for _, v in pairs(total) do
		sum += v
		count += 1
	end
	assert(count > 0, `empty dataset`)
	return sum / count
end
function normalizeData(avgBaseline: number, dataSet: { DataRow }): { number }
	local out: { number } = {}
	for _, dataRow in ipairs(dataSet) do
		local relativeSpeed = dataRow["runner.baseline.ps"] / avgBaseline
		table.insert(out, (dataRow["elapsed.ps"] - dataRow["runner.baseline.ps"]) / relativeSpeed)
	end
	return out
end

type StatInfo = {
	count: number,
	mean: number,
	stddev: number,
	p10: number,
	p50: number,
	p90: number,
	p99: number,
	min: number,
	max: number,
	median: number,
	q1: number,
	q3: number,
}

do
	local summaryCSV: CSV = {
		headers = parseHeader(table.concat({
			"bench.path",
			"bench.runs",
			"bench.samples",
			"bench.repeats",
			"stats.mean",
			"stats.stddev",
			"stats.p10",
			"stats.p50",
			"stats.p90",
			"stats.p99",
			"stats.min",
			"stats.max",
			"stats.median",
			"stats.q1",
			"stats.q3",
		}, ",")),
		rows = {},
	}
	local function summarize(data: { number }): StatInfo
		local count = #data
		local min = math.huge
		local max = -math.huge
		local mean: number
		do
			local sum = 0
			for i, v in data do
				min = math.min(min, v)
				max = math.max(max, v)
				sum += v
			end
			mean = sum / count
		end
		local standardDeviation: number
		do --http://lua-users.org/wiki/SimpleStats
			local variance = 0
			for i, v in data do
				local vm = v - mean
				variance += vm * vm
			end
			standardDeviation = math.sqrt(variance / (count - 1))
		end

		local p10: number, p50: number, p90: number, p99: number
		local median, q1, q3: number
		do -- https://gist.github.com/ZeroStride/3485c35e2583e5aca3978d54f2004399
			local temp: { number } = {}

			-- deep copy table so that when we sort it, the original is unchanged
			-- also weed out any non numbers
			for k, v in pairs(data) do
				table.insert(temp, v)
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
			q1 = percentile(0.25)
			p50 = percentile(0.5)
			median = p50
			q3 = percentile(0.75)
			p90 = percentile(0.9)
			p99 = percentile(0.99)
		end
		return {
			count = count,
			mean = math.ceil(mean),
			stddev = math.ceil(standardDeviation),
			p10 = math.ceil(p10),
			p50 = math.ceil(p50),
			p90 = math.ceil(p90),
			p99 = math.ceil(p99),
			min = math.ceil(min),
			max = math.ceil(max),
			median = math.ceil(median),
			q1 = math.ceil(q1),
			q3 = math.ceil(q3),
		}
	end
	local function addSummaryRow(benchPath: string, avgBaseline: number, dataSet: { DataRow })
		local data = normalizeData(avgBaseline, dataSet)
		local runCount: number = 0
		local repeatCount: number = 0
		for _, dataRow in ipairs(dataSet) do
			runCount = math.max(runCount, dataRow["runner.index.n"])
			assert(repeatCount == 0 or repeatCount == dataRow["repeats.n"])
			repeatCount = dataRow["repeats.n"]
		end
		local statsInfo = summarize(data)
		table.insert(
			summaryCSV.rows,
			{
				["bench.path"] = benchPath,
				["bench.runs"] = tostring(runCount),
				["bench.samples"] = tostring(#dataSet),
				["bench.repeats"] = tostring(repeatCount),
				["stats.mean"] = tostring(statsInfo.mean),
				["stats.stddev"] = tostring(statsInfo.stddev),
				["stats.p10"] = tostring(statsInfo.p10),
				["stats.p50"] = tostring(statsInfo.p50),
				["stats.p90"] = tostring(statsInfo.p90),
				["stats.p99"] = tostring(statsInfo.p99),
				["stats.min"] = tostring(statsInfo.min),
				["stats.max"] = tostring(statsInfo.max),
				["stats.median"] = tostring(statsInfo.median),
				["stats.q1"] = tostring(statsInfo.q1),
				["stats.q3"] = tostring(statsInfo.q3),
			} :: { [string]: string }
		)
	end

	local dataSets: { [string]: { DataRow } } = {}
	local function searchForData(dir: string)
		for _, file in ipairs(fs.readDir(dir)) do
			local path = dir .. "/" .. file
			if fs.isDir(path) then
				searchForData(path)
			else
				local csv = parseCSV(path)
				local data = unpackData(csv)
				print(`got {#data} rows of data for {path}`)
				dataSets[path] = data
			end
		end
	end
	if fs.isFile(OUT_PATH) then
		print(`removing old summary at {OUT_PATH}`)
		fs.removeFile(OUT_PATH)
	end
	searchForData(DATA_DIR)
	local averageBaseline = getAverageBaseline(dataSets)
	print(`average baseline is {averageBaseline} picoseconds`)
	for path, dataSet in pairs(dataSets) do
		print(`summarizing {path}`)
		addSummaryRow(path:sub(#DATA_DIR + 2), averageBaseline, dataSet)
	end
	print(`writing summary to {OUT_PATH}`)
	fs.writeFile(OUT_PATH, bakeCSV(summaryCSV))
end
