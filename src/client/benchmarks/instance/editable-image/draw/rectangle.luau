--!strict
-- Services
-- Packages
-- Modules
local Benchmark = require(game.ReplicatedStorage.Shared.Benchmark)
-- Types
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
return Benchmark.new(
	{
		Benchmark.Parameter.Tuple.new({
			Benchmark.Parameter.EditableImage.new("image"),
			Benchmark.Parameter.Vector2.new("Position"),
			Benchmark.Parameter.Vector2.new("Size", Vector2.one),
		}, function(image: EditableImage, position: Vector2, size: Vector2)
			local start = (position - size / 2):Floor()
			local finish = (position + size / 2):Ceil()
			if start == finish then
				if finish == image.Size then
					finish = Vector2.one:Max(finish - Vector2.one)
				else
					finish = image.Size:Min(finish + Vector2.one)
				end
			end
			local max = image.Size:Min(start:Max(finish))
			local min = Vector2.one:Max(start:Min(finish))
			start = (start:Max(min)):Min(max)
			finish = (finish:Max(min)):Min(max)
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
	20,
	10_000
)
