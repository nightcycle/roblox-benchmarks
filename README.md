# luau-benchmarks

A set of luau benchmarks for operations, helping developers understand where they might be throwing away performance.

## data

You can access the most recent data [here](https://github.com/nightcycle/roblox-benchmarks-data), as well as engage with it in a more useful form via the dashboard [here](https://nightcycle.github.io/roblox-benchmarks/).

## acknowledgements

A quick moment to acknowledge some of the shoulders of giants I stand on:

- [Benchmarker](https://boatbomber.itch.io/benchmarker) by @boatbomber, which largely introduced formal benchmarking to Roblox Devs, including myself. Many high level implementation decisions were informed by my experiences with his excellent plugin.
- [rstest](https://docs.rs/rstest/latest/rstest/) which introduced me to the concept of defining parameters for embedded tests and inspired the actual structure of the benchmarks

## benchmarking process

### 1. Defining a Benchmark

A module is created by a developer defining some operation they wish to benchmark.

```lua
--!strict
local Benchmark = require(game.ReplicatedStorage.Shared.Benchmark)
return Benchmark.new(
  {
    Benchmark.Parameter.Float.new("x"), -- can be futher configured / replaced to give more specific inputs
    Benchmark.Parameter.Float.new("y"),
  },
  function(x: number, y: number) -- actual test, return does nothing but I didn't want to skew with assigning a variable
    return math.noise(x, y)
  end,
  150000, -- repeats
  100 -- sample count, h
)
```

If you think the parameter system is cool, check out [nightcycle/simple-test](https://github.com/nightcycle/simple-test) for a more realized version of it with permutation support, bundled in a lightweight unit testing wally package designed to make CI/CD unit testing easier.

### 2. Triggering GitHub Action

Ideally, this will be triggered automatically when the Roblox engine or benchmarking system updates - but for now we just dispatch it manually. If a new directory has been added (or you suspect things will take longer than the 300s limited by github actions for the entire existing directory) update `scripts/workflow/benchmark/all.sh`. If you provide a `benchmark-filter` it will target those directly, allowing for the adding of new benchmarks to datasets without re-running the entire dataset.

### 3. Test is Run

The workflow builds an rbxl using `scripts/build/init.sh` then publishes it.

From there, it runs a series of luau execution sessions (currently 50x). This is because the actual performance of the server will vary between calls, so a lot of work has to go into un-skewing benchmarks to be generalizable. As most of your players likely won't be enjoying your game from a server farm, **these benchmarks ought to be used for their comparative value (X is faster than Y) rather than as an exact speed (X takes 20 microseconds)**.

The runs are then appended to a .csv with the respective path name. It includes the parameters used (serialized within reason) per sample, the duration, as well as various bits of metadata regarding the run itself.

### 4. Summarizing

After all the benchmark running is done, a data processing script at `scripts/workflow/benchmark/summarize.lune.luau` is run via lune. It constructs a high level summary at [src/summary.csv](https://github.com/nightcycle/roblox-benchmarks-data/blob/main/src/summary.csv) of the benchmarks for people who want a portable version, as well as a currently ~40mb version which dumps all the data into a single csv at [src/all.csv](https://github.com/nightcycle/roblox-benchmarks-data/blob/main/src/all.csv).

### 5. Data is Committed to a new Branch

After each successful test, it commits the data to the branch specified at dispatch.

### 6. Branch is Merged into Main

After the run is successful, a pull request is made (currently manually by a human) and merged into the main branch if everything looks good.

### 7. Dashboard Updates

The [dashboard](https://nightcycle.github.io/roblox-benchmarks/), which highlights our most interesting findings, is powered primarily off the raw text of [all.csv](https://github.com/nightcycle/roblox-benchmarks-data/blob/main/src/all.csv). It can take a few minutes, but it *should* update automatically when the file changes.

## development

### setting up

things to know if you want to contribute

- running code in the vscode bash terminal
- basic fluency with bash scripts, rojo, and rokit
- familiarity with roblox cloud APIs

tools you need to install to run `init.sh` (currently only windows only):

- [rokit](https://github.com/rojo-rbx/rokit)
- [chocolatey](https://chocolatey.org/install)

tools added by init.sh (you will have to install manually if not windows):

- all tools under rokit.toml
- jq
- gh
- git

you will also need to create a `.env` file with the following keys:

```toml
RBX_API_KEY="your luau execution and place publishing open cloud api key here"
```

you may also override any default keys in the `.env` file.

### building

to convert this project into an rbxl you can run `sh scripts/build/init.sh` which will by default build it to `build.rbxl`. You can then connect to it via [rojo](https://github.com/rojo-rbx/rojo) with `rojo serve`

### running

#### in cloud

you can run a directory of benchmarks with `sh scripts/workflow/benchmark/init.sh "$BENCHMARK_PATH"`. For example you could run the [noise benchmarks](https://github.com/nightcycle/roblox-benchmarks/tree/main/src/server/benchmarks/luau/math/noise) with:

```sh
sh scripts/workflow/benchmark/init.sh "src/server/benchmarks/luau/math/noise"
```

it will build, deploy, and run the benchmarks. The results will then be written to the respective path under the `data` submodule

if you want to update `summary.csv` or `all.csv`, simply put `--sumarize` at the end of the call. In this case:

```sh
sh scripts/workflow/benchmark/init.sh "src/server/benchmarks/luau/math/noise" --summarize
```

the full workflow is currently triggered by a dispatch github action, with the data created in another branch. If you want general runs to catch a new test, you may need to add it under `scripts/workflow/benchmark/all.sh` in the relevant spot. These are all listed out manually to allow for easier tuning.

#### locally

you can run benchmarks directly on your machine (helpful for debugging issues live). Currently it runs off of [hoarcekat](https://github.com/Kampfkarren/hoarcekat) combined with [file-util](https://github.com/nightcycle/file-util) (a basic io server tool in desperate need of a remake, currently windows only).

1. in the terminal call `file-util run` to start the server.
2. edit the [boot.story module](https://github.com/nightcycle/roblox-benchmarks/blob/main/src/shared/Main/boot.story.luau) to target whatever directory you're interested in
3. run the story using hoarcekat

this workflow is not used as frequently now that the bulk of the core internals have stabilized, so it might fall out of date over time.

### contributing

#### guidelines

- only return 1 test per script
- keep the names lower kebab case
- all _G usage must be run through the `src/shared/ENV.luau` module for type safety.
- all tests must be strictly typed
- new parameters shouldn't generate tuples, makes unpacking / repacking weird
- to keep the stack simple we're avoiding adding wally for now

#### benchmark bounties

These areas are considered high value due to how often developers engage with in high performance systems.

##### libraries

- table

##### types

- Noise
- CFrame
- NumberRange
- Ray
- Region3
- ColorSequence
- NumberSequence

##### instances

- any EditableImage methods
- any EditableMesh methods
- workspace:BulkMoveTo vs other move methods
- Instance construction / destruction methods (clone, debris, etc)

#### services

- HttpService:JSONEncode, JSONDecode, and GenerateGUID
- EncodingService

#### roadmap

v0.4:

- improve coverage of tostring support across types, especially around including size metadata when it's not directly serializable.
- create localized versions of `all.csv` for tests with matching parameters to be parsed together with the parameter columns included.

v0.5:

- add permutation benchmark logic for generating new test benchmarks off of params (for example, definining a single draw-line benchmark that is then permuted into every viable canvas size)
- add an optional "reject param combo" step to allow for bad combinations to be rejected
- add a parameter that has the prior parameters passed into it
- split the parameter module into sub-modules

v0.6:

- benchmark various performance minded open source packages, such as [rbx-bufferize](https://github.com/EgoMoose/rbx-bufferize), [msgpack-luau](https://github.com/cipharius/msgpack-luau), and [noise](https://github.com/nightcycle/noise).
- automate the opening of a pull request for data branches, as well as maybe the automated merging of it should the automated tests pass
- have it automatically re-run whenever a new test is added + checks pass, or the roblox client / packe updates

v0.7:

- boot the power bi dashboard off of a `.pbip` file to allow others to contribute
- create a coverage dashboard aiming for every luau and engine API - maybe even a [Roblox API Ref](https://robloxapi.github.io/ref/index.html) style library

v0.8:

- compile a list of 0 downsides optimizations any developer can make immediately with a copy / paste
