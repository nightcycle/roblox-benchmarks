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
			Benchmark.Parameter.Vector2.new("Start"),
			Benchmark.Parameter.Vector2.new("Finish"),
		}, function(image: EditableImage, start: Vector2, finish: Vector2)
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
	20,
	10_000
)
