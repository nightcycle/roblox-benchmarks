--!strict
-- Services
-- Packages
-- Modules
local Benchmark = require(game.ReplicatedStorage.Shared.Benchmark)
-- Types
-- Constants
local CONSTANTS = require(game.ReplicatedStorage.Shared.CONSTANTS)
-- Variables
-- References
-- Private Functions
-- Class
return Benchmark.new(
	{
		Benchmark.Parameter.EditableImage.new("image"),
		Benchmark.Parameter.Vector2.new(
			"Position",
			Vector2.one * CONSTANTS.MAX_EDITABLE_IMAGE_DIM * 0.25,
			Vector2.one * CONSTANTS.MAX_EDITABLE_IMAGE_DIM * 0.75,
			Vector2.one
		),
		Benchmark.Parameter.Vector2.new(
			"Size",
			Vector2.one,
			Vector2.one * (CONSTANTS.MAX_EDITABLE_IMAGE_DIM * 0.5 - 1),
			Vector2.one
		),
		Benchmark.Parameter.Color3.new("Color3"),
		Benchmark.Parameter.Float.new("Transparency", 0, 1, 0.1),
		Benchmark.Parameter.EnumItem.new("ImageCombineType", Enum.ImageCombineType),
	},
	function(
		image: EditableImage,
		position: Vector2,
		size: Vector2,
		color: Color3,
		transparency: number,
		imageCombineType: Enum.ImageCombineType
	)
		return image:DrawRectangle(position, size, color, transparency, imageCombineType)
	end :: any,
	20,
	10_000
)
