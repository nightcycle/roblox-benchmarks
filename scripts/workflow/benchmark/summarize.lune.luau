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

type StatResponse = {
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
	local function summarize(data: { number }) end
end
