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
			local pA = position / CONSTANTS.MAX_EDITABLE_IMAGE_DIM
			local sA = size / CONSTANTS.MAX_EDITABLE_IMAGE_DIM
			position = (image.Size * pA):Ceil()
			size = Vector2.min((image.Size * sA):Ceil(), image.Size - Vector2.one * 2)

			local minX = math.clamp(math.round(position.X - size.X / 2), 1, image.Size.X)
			local maxX = math.clamp(math.round(position.X + size.X / 2), 1, image.Size.X)
			local minY = math.clamp(math.round(position.Y - size.Y / 2), 1, image.Size.Y)
			local maxY = math.clamp(math.round(position.Y + size.Y / 2), 1, image.Size.Y)
			local min = Vector2.new(minX, minY)
			local max = Vector2.new(maxX, maxY)

			position = min
			size = max - min

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
