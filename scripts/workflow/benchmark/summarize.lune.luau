local fs = require("@fs")

type CSVHeader = {
	name: string,
}
type CSV = {
	headers: { string },
	rows: { { [string]: string } },
}

function summarizeAsRow(path: string): CSV end
