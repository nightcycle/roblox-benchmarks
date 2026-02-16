# luau-benchmarks

A set of luau benchmarks for operations, helping developers understand where they might be throwing away performance.

## data

You can access the data [here](https://github.com/nightcycle/roblox-benchmarks-data), it gets automatically updated when the rbx client updates. All benchmarks use picoseconds to allow their storage as integers, I usually convert them to microseconds when visualizing them.

## development

### initialization

to run it locally:

- run `sh scripts/init.sh` to setup the dev env, it will boot up a local server allowing you to write files to your os. Use `ctrl+c` in terminal to kill it when you're done or close the terminal.
- feel free to sync via `rojo serve` in a new terminal window
- use a form of [hoarcekat](https://github.com/Kampfkarren/hoarcekat) to run `ServerScriptService/server/run/run.story`

### contributing

some basic rules:

- you can only have 1 test per module
- keep the names lower kebab case
- all _G usage must be run through the `src/shared/ENV.luau` module for type safety
- all tests must be strictly typed
- new parameters shouldn't generate tuples, makes unpacking / repacking weird
- to keep the stack simple we're avoiding adding wally for now

### goals

short term:

- make this publicly information accessible
- have it automatically re-run whenever a new test is added, or the roblox client updates
- build out higher level operation benchmarking

long term:

- decouple the parameter generator + build a unit test system off of it
- dashboards / data visualizations
- create a progress dashboard aiming for the benchmarking of every luau and engine API
- a tool that analyzes a codeblock and estimates runtime from recognized patterns
- darklua style cli tool that applies known optimizations (maybe just a fork? not sure)

