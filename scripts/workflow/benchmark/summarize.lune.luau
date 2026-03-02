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

do
	local summaryCSC: CSV = {
		headers = {
			["bench.path"] = 1,
			["bench.duration"] = 2,
			["bench.samples"] = 3,
			["bench.repeats"] = 4,
			["stats.mean"] = 5,
			["stats.median"] = 6,
			["stats.p90"] = 7,
			["stats.p99"] = 8,
		},
	}
end
