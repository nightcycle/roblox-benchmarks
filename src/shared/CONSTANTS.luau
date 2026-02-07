local CONSTANTS = {
	BIGGEST_INTEGER = 9_007_199_254_740_992,
	BIGGEST_FLOAT = 1.7976931348623157e+308,
	DEFAULT_TABLE_SIZE = 100_000,
	DEFAULT_SAMPLES = 10_000, -- how many times the benchmark is run
	DEFAULT_REPEATS = 100, -- how many times to re-run with the same parameters
}
table.freeze(CONSTANTS)
return CONSTANTS
