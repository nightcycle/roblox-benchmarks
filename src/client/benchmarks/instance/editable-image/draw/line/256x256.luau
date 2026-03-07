--!strict
-- Services
-- Packages
-- Modules
local Benchmark = require(game.ReplicatedStorage.Shared.Benchmark)
-- Types
-- Constants
local SIZE = 256
local HALF_SIZE = SIZE / 2
-- Variables
-- References
-- Private Functions
-- Class
return Benchmark.new(
	{
		Benchmark.Parameter.EditableImage.new("image", Vector2.one * SIZE),
		Benchmark.Parameter.Vector2.new("Start", Vector2.one, Vector2.one * HALF_SIZE, Vector2.one),
		Benchmark.Parameter.Vector2.new("Finish", Vector2.one * (HALF_SIZE + 1), Vector2.one * SIZE, Vector2.one),
		Benchmark.Parameter.Color3.new("Color3"),
		Benchmark.Parameter.Float.new("Transparency", 0, 1, 0.1),
		Benchmark.Parameter.EnumItem.new("ImageCombineType", Enum.ImageCombineType),
	},
	function(
		image: EditableImage,
		start: Vector2,
		finish: Vector2,
		color: Color3,
		transparency: number,
		imageCombineType: Enum.ImageCombineType
	)
		return image:DrawLine(start, finish, color, transparency, imageCombineType)
	end :: any,
	10,
	10_000
)
