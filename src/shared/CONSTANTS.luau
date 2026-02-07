local CONSTANTS = {
	BIGGEST_INTEGER = 9_007_199_254_740_992,
	BIGGEST_FLOAT = 1.7976931348623157e+308,
	BIGGEST_VEC_FLOAT = 3.402823466e+38,
	DEFAULT_TABLE_SIZE = 100_000,
	DEFAULT_SAMPLES = 10_000, -- how many times the benchmark is run
	DEFAULT_REPEATS = 100, -- how many times to re-run with the same parameters
	PAUSE_EVERY_N_SAMPLES = 10, -- how many iterations to run before yielding to a new thread
	DEFAULT_STRING_LENGTH = 32,
}
table.freeze(CONSTANTS)
return CONSTANTS
