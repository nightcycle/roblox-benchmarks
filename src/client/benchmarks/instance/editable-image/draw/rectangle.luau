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
			Benchmark.Parameter.Vector2.new("Position", Vector2.one, Vector2.one * CONSTANTS.MAX_EDITABLE_IMAGE_DIM),
			Benchmark.Parameter.Vector2.new("Size", Vector2.one, Vector2.one * CONSTANTS.MAX_EDITABLE_IMAGE_DIM),
		}, function(image: EditableImage, position: Vector2, size: Vector2)
			local start = (position - size / 2):Floor()
			local finish = (position + size / 2):Ceil()
			start = Vector2.max(Vector2.min(image.Size - Vector2.one * 2, start), Vector2.one * 2):Ceil()
			finish = Vector2.max(Vector2.min(image.Size - Vector2.one * 2, finish), Vector2.one * 2):Ceil()
			if start == finish then
				if start == image.Size - Vector2.one * 2 then
					start -= Vector2.one * 2
				else
					start = Vector2.min(image.Size - Vector2.one * 2, finish + Vector2.one * 2)
				end
			end
			size = finish - start
			position = (size * 0.5 + start):Ceil()
			return image, position, size
		end),
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
	1,
	1_000
)
