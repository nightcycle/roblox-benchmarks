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
		Benchmark.Parameter.Tuple.new({
			Benchmark.Parameter.EditableImage.new("image"),
			Benchmark.Parameter.Vector2.new("Start", Vector2.one, Vector2.one * CONSTANTS.MAX_EDITABLE_IMAGE_DIM),
			Benchmark.Parameter.Vector2.new("Finish", Vector2.one, Vector2.one * CONSTANTS.MAX_EDITABLE_IMAGE_DIM),
		}, function(image: EditableImage, start: Vector2, finish: Vector2)
			start = Vector2.max(Vector2.min(image.Size - Vector2.one, start), Vector2.one):Ceil()
			finish = Vector2.max(Vector2.min(image.Size - Vector2.one, finish), Vector2.one):Ceil()
			if start == finish then
				if start == image.Size - Vector2.one then
					start -= Vector2.one
				else
					start = Vector2.min(image.Size - Vector2.one, finish + Vector2.one)
				end
			end
			return image, start, finish
		end),
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
	1,
	1_000
)
