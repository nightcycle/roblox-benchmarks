local fs = require("@lune/fs")

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
	local content = fs.readFile(path)
	local lines = content:split("\n")
	local headerList = parseHeader(lines[1])
	table.remove(lines, 1)
	local rows = {}
	for _, line in ipairs(lines) do
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

type StatInfo = {
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
			"tags",
		}, ",")),
	}
	local function summarize(data: { number }): StatInfo
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

		local p10: number, p50: number, p90: number, p99: number
		local median, q1, q3: number
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
			q1 = percentile(0.25)
			p50 = percentile(0.5)
			median = p50
			q3 = percentile(0.75)
			p90 = percentile(0.9)
			p99 = percentile(0.99)
		end
		return {
			mean = mean,
			stddev = standardDeviation,
			p10 = p10,
			p50 = p50,
			p90 = p90,
			p99 = p99,
			min = min,
			max = max,
			median = median,
			q1 = q1,
			q3 = q3,
		}
	end
end
