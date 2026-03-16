--!strict
local AssetService = game:GetService("AssetService")
-- Services
-- Packages
-- Modules
-- Types
-- Constants
local CONSTANTS = require(game.ReplicatedStorage.Shared.CONSTANTS)
local HYDRATION_CACHE_KEY = "_HydratedItem"
-- Variables
-- References
-- Private Functions
-- Class
local Parameter = {}

export type Parameter =
	| IntegerParameter
	| BooleanParameter
	| FloatParameter
	| LiteralParameter
	| Vector2Parameter
	| Vector3Parameter
	| ArrayParameter
	| MapParameter
	| NullableParameter
	| StaticParameter
	| StringParameter
	| HexStringParameter
	| Color3Parameter
	| BrickColorParameter
	| CustomParameter
	| EditableImageParameter
	| EnumItemParameter
	| TupleParameter

type CustomParameter = {
	read Key: string,
	read Type: "Custom",
	read Method: (Random) -> any?,
	read ToString: ((CustomParameter, value: any) -> string)?,
}
Parameter.Custom = {
	new = function(
		key: string,
		method: (Random) -> any?,
		toString: ((CustomParameter, value: any) -> string)?
	): CustomParameter
		return {
			Key = key,
			Type = "Custom",
			Method = method,
			ToString = toString,
		}
	end,
	generate = function(param: CustomParameter, rng: Random): any?
		return param.Method(rng)
	end :: (any, Random) -> any?,
	tostring = function(param: CustomParameter, value: any): string
		if param.ToString then
			return param.ToString(param, value)
		end
		return `Custom<{param.Key}>`
	end,
}

type IntegerParameter = {
	read Key: string,
	read Type: "Integer",
	read Min: number?,
	read Max: number?,
	read Increment: number?,
}
Parameter.Integer = {
	new = function(key: string, min: number?, max: number?, increment: number?): IntegerParameter
		return {
			Key = key,
			Type = "Integer",
			Min = min,
			Max = max,
			Increment = increment,
		}
	end,
	generate = function(param: IntegerParameter, rng: Random): number
		local min = param.Min or -CONSTANTS.BIGGEST_INTEGER
		local max = param.Max or CONSTANTS.BIGGEST_INTEGER
		local value = rng:NextInteger(min, max)
		local increment = param.Increment
		if increment then
			local remainder = value % increment
			value -= remainder
		end
		return value
	end :: (any, Random) -> number,
}

type BufferParameter = {
	read Key: string,
	read Type: "Buffer",
	read MinLength: number?,
	read MaxLength: number?,
}
Parameter.Buffer = {
	new = function(key: string, minLength: number?, maxLength: number?): BufferParameter
		return {
			Key = key,
			Type = "Buffer",
			MinLength = minLength,
			MaxLength = maxLength,
		}
	end,
	generate = function(param: BufferParameter, rng: Random): buffer
		local minLength = math.max(param.MinLength or 1, 1)
		local maxLength = math.max(minLength, param.MaxLength or CONSTANTS.DEFAULT_BUFFER_SIZE_BYTES)
		local length = rng:NextInteger(minLength, maxLength)
		local b = buffer.create(length)
		for i = 0, length - 1 do
			buffer.writeu8(b, i, rng:NextInteger(0, 255))
		end
		return b
	end :: (any, Random) -> buffer,
	tostring = function(param: BufferParameter, value: buffer): string
		return `Buffer[{buffer.len(value)}]`
	end,
}

type FloatParameter = {
	read Key: string,
	read Type: "Float",
	read Min: number?,
	read Max: number?,
	read Increment: number?,
}
Parameter.Float = {
	new = function(key: string, min: number?, max: number?, increment: number?): FloatParameter
		return {
			Key = key,
			Type = "Float",
			Min = min,
			Max = max,
			Increment = increment,
		}
	end,
	generate = function(param: FloatParameter, rng: Random): number
		local min = param.Min or -CONSTANTS.BIGGEST_FLOAT
		local max = param.Max or CONSTANTS.BIGGEST_FLOAT
		local value = rng:NextNumber(min, max)
		local increment = param.Increment
		if increment then
			local remainder = value % increment
			value -= remainder
		end
		return value
	end :: (any, Random) -> number,
}
type BooleanParameter = {
	read Key: string,
	read Type: "Boolean",
	read ChanceTrue: number?,
}
Parameter.Boolean = {
	new = function(key: string, chanceTrue: number?): BooleanParameter
		return {
			Key = key,
			Type = "Boolean",
			ChanceTrue = chanceTrue,
		}
	end,
	generate = function(param: BooleanParameter, rng: Random): boolean
		return rng:NextNumber() < (param.ChanceTrue or 0.5)
	end :: (any, Random) -> boolean,
}

type Vector2Parameter = {
	read Key: string,
	read Type: "Vector2",
	read Min: Vector2?,
	read Max: Vector2?,
	read Increment: Vector2?,
}
Parameter.Vector2 = {
	new = function(key: string, min: Vector2?, max: Vector2?, increment: Vector2?): Vector2Parameter
		return {
			Key = key,
			Type = "Vector2",
			Min = min,
			Max = max,
			Increment = increment,
		}
	end,
	generate = function(param: Vector2Parameter, rng: Random): Vector2
		local min = param.Min or Vector2.new(-CONSTANTS.BIGGEST_VEC_FLOAT, -CONSTANTS.BIGGEST_VEC_FLOAT)
		local max = param.Max or Vector2.new(CONSTANTS.BIGGEST_VEC_FLOAT, CONSTANTS.BIGGEST_VEC_FLOAT)
		local x = rng:NextNumber(min.X, max.X)
		local y = rng:NextNumber(min.Y, max.Y)
		local value = Vector2.new(x, y)
		local increment = param.Increment
		if increment then
			local remainderX = value.X % increment.X
			local remainderY = value.Y % increment.Y
			value -= Vector2.new(remainderX, remainderY)
		end
		return value
	end :: (any, Random) -> Vector2,
	tostring = function(param: Vector2, value: Vector2): string
		return `Vector2({value.X},{value.Y})`
	end,
}

type Vector3Parameter = {
	read Key: string,
	read Type: "Vector3",
	read Min: Vector3?,
	read Max: Vector3?,
	read Increment: Vector3?,
}
Parameter.Vector3 = {
	new = function(key: string, min: Vector3?, max: Vector3?, increment: Vector3?): Vector3Parameter
		return {
			Key = key,
			Type = "Vector3",
			Min = min,
			Max = max,
			Increment = increment,
		}
	end,
	generate = function(param: Vector3Parameter, rng: Random): Vector3
		local min = param.Min
			or Vector3.new(-CONSTANTS.BIGGEST_VEC_FLOAT, -CONSTANTS.BIGGEST_VEC_FLOAT, -CONSTANTS.BIGGEST_VEC_FLOAT)
		local max = param.Max
			or Vector3.new(CONSTANTS.BIGGEST_VEC_FLOAT, CONSTANTS.BIGGEST_VEC_FLOAT, CONSTANTS.BIGGEST_VEC_FLOAT)
		local x = rng:NextNumber(min.X, max.X)
		local y = rng:NextNumber(min.Y, max.Y)
		local z = rng:NextNumber(min.Z, max.Z)
		local value = Vector3.new(x, y, z)
		local increment = param.Increment
		if increment then
			local remainderX = value.X % increment.X
			local remainderY = value.Y % increment.Y
			local remainderZ = value.Z % increment.Z
			value -= Vector3.new(remainderX, remainderY, remainderZ)
		end
		return value
	end :: (any, Random) -> Vector3,
	tostring = function(param: Vector3, value: Vector3): string
		return `Vector3({value.X},{value.Y},{value.Z})`
	end,
}

type LiteralParameter = {
	read Key: string,
	read Type: "Literal",
	read Values: { string },
}
Parameter.Literal = {
	new = function(key: string, values: { string }): LiteralParameter
		return {
			Key = key,
			Type = "Literal",
			Values = values,
		}
	end,
	generate = function(param: LiteralParameter, rng: Random): string
		local index = rng:NextInteger(1, #param.Values)
		return param.Values[index]
	end :: (any, Random) -> string,
	tostring = function(param: LiteralParameter, value: string): string
		return value
	end,
}

type EnumItemParameter = {
	read Key: string,
	read Type: "EnumItem",
	read Enum: Enum,
}
Parameter.EnumItem = {
	new = function(key: string, enum: Enum): EnumItemParameter
		return {
			Key = key,
			Type = "EnumItem",
			Enum = enum,
		}
	end,
	generate = function(param: EnumItemParameter, rng: Random): string
		local index = rng:NextInteger(1, #param.Enum:GetEnumItems())
		return param.Enum:GetEnumItems()[index]
	end :: (any, Random) -> string,
	tostring = function(param: EnumItemParameter, value: EnumItem): string
		return `{value.EnumType}({value.Name})`
	end,
}

type ArrayParameter = {
	read Key: string,
	read Type: "Array",
	read ValueType: Parameter,
	read IsFrozen: boolean?,
	read MinLength: number?,
	read MaxLength: number?,
}
Parameter.Array = {
	new = function(
		key: string,
		valueType: Parameter,
		isFrozen: boolean?,
		minLength: number?,
		maxLength: number?
	): ArrayParameter
		return {
			Key = key,
			Type = "Array",
			ValueType = valueType,
			IsFrozen = isFrozen,
			MinLength = minLength,
			MaxLength = maxLength,
		}
	end,
	generate = function(param: ArrayParameter, rng: Random): { any }
		local minLength = math.max(param.MinLength or 1, 1)
		local maxLength = math.max(minLength, param.MaxLength or CONSTANTS.DEFAULT_TABLE_SIZE)
		local length = rng:NextInteger(minLength, maxLength)
		local result = {}
		for i = 1, length do
			local value = Parameter.Any.generate(param.ValueType, rng)
			result[i] = value
		end
		if param.IsFrozen then
			return table.freeze(result)
		end
		return result
	end :: (any, Random) -> { any },
	tostring = function(param: ArrayParameter, value: { any }): string
		if table.isfrozen(value) then
			return `FrozenArray<{param.ValueType.Type}>[{#value}]`
		else
			return `Array<{param.ValueType.Type}>[{#value}]`
		end
	end,
}

type StringParameter = {
	read Key: string,
	read Type: "String",
	read MinLength: number?,
	read MaxLength: number?,
}
Parameter.String = {
	new = function(key: string, minLength: number?, maxLength: number?): StringParameter
		return {
			Key = key,
			Type = "String",
			MinLength = minLength,
			MaxLength = maxLength,
		}
	end,
	generate = function(param: StringParameter, rng: Random): string
		local minLength = math.max(param.MinLength or 1, 1)
		local maxLength = math.max(minLength, param.MaxLength or CONSTANTS.DEFAULT_STRING_LENGTH)
		local length = rng:NextInteger(minLength, maxLength)
		local chars = {}
		for i = 1, length do
			local charCode = rng:NextInteger(32, 126) -- Printable ASCII range
			chars[i] = string.char(charCode)
		end
		return table.concat(chars)
	end :: (any, Random) -> string,
}
type Color3Parameter = {
	read Key: string,
	read Type: "Color3",
}
Parameter.Color3 = {
	new = function(key: string): Color3Parameter
		return {
			Key = key,
			Type = "Color3",
		}
	end,
	generate = function(param: Color3Parameter, rng: Random): Color3
		return Color3.fromRGB(rng:NextInteger(0, 255), rng:NextInteger(0, 255), rng:NextInteger(0, 255))
	end :: (any, Random) -> string,
	tostring = function(param: Color3Parameter, value: Color3): string
		return `Color3({math.ceil(value.R * 255)},{math.ceil(value.G * 255)},{math.ceil(value.B * 255)})`
	end,
}
type BrickColorParameter = {
	read Key: string,
	read Type: "BrickColor",
}
Parameter.BrickColor = {
	new = function(key: string): BrickColorParameter
		return {
			Key = key,
			Type = "BrickColor",
		}
	end,
	generate = function(param: BrickColorParameter, rng: Random): BrickColor
		return BrickColor.new(rng:NextNumber(), rng:NextNumber(), rng:NextNumber())
	end :: (any, Random) -> string,
	tostring = function(param: BrickColorParameter, value: BrickColor): string
		return `BrickColor({value.Name})`
	end,
}
type HexStringParameter = {
	read Key: string,
	read Type: "HexString",
}
Parameter.HexString = {
	new = function(key: string): HexStringParameter
		return {
			Key = key,
			Type = "HexString",
		}
	end,
	generate = function(param: HexStringParameter, rng: Random): string
		return Color3.fromRGB(rng:NextInteger(0, 255), rng:NextInteger(0, 255), rng:NextInteger(0, 255)):ToHex()
	end :: (any, Random) -> string,
	tostring = function(param: HexStringParameter, value: string): string
		return `HexString({value})`
	end,
}

type MapParameter = {
	read Key: string,
	read Type: "Map",
	read ValueType: Parameter,
	read KeyType: Parameter,
	read MinLength: number?,
	read MaxLength: number?,
	read IsFrozen: boolean?,
}
Parameter.Map = {
	new = function(
		key: string,
		keyType: Parameter,
		valueType: Parameter,
		isFrozen: boolean?,
		minLength: number?,
		maxLength: number?
	): MapParameter
		return {
			Key = key,
			Type = "Map",
			ValueType = valueType,
			KeyType = keyType,
			MinLength = minLength,
			MaxLength = maxLength,
			IsFrozen = isFrozen,
		}
	end,
	generate = function(param: MapParameter, rng: Random): { [any]: any }
		local minLength = math.max(param.MinLength or 1, 1)
		local maxLength = math.max(minLength, param.MaxLength or CONSTANTS.DEFAULT_TABLE_SIZE)
		local length = rng:NextInteger(minLength, maxLength)
		local result = {}
		for i = 1, length do
			local key: any?
			local attemptCount = 0
			local maximumAttempts = math.max(10_000, length ^ 2)
			repeat
				attemptCount += 1
				key = Parameter.Any.generate(param.KeyType, rng)
			until key ~= nil and result[key] == nil and attemptCount < maximumAttempts
			assert(key ~= nil, "Failed to generate unique key for MapParameter")
			assert(
				attemptCount <= maximumAttempts,
				`Exceeded maximum attempts to generate unique key for MapParameter: {attemptCount}/{maximumAttempts} for map of length {length} ({i})`
			)
			local value = Parameter.Any.generate(param.ValueType, rng)
			result[key] = value
		end
		if param.IsFrozen == true then
			table.freeze(result)
		elseif param.IsFrozen == nil and rng:NextNumber() < 0.5 then
			table.freeze(result)
		end
		return result
	end :: (any, Random) -> { [any]: any },
	tostring = function(param: MapParameter, map: { [any]: any }): string
		local count = 0
		for _ in pairs(map) do
			count += 1
		end
		if table.isfrozen(map) then
			return `ForzenMap<{param.KeyType.Type},{param.ValueType.Type}>[{count}]`
		else
			return `Map<{param.KeyType.Type},{param.ValueType.Type}>[{count}]`
		end
	end,
}

type NullableParameter = {
	read Key: string,
	read Type: "Nullable",
	read ChanceNull: number?,
	read ValueType: Parameter,
}
Parameter.Nullable = {
	new = function(valueType: Parameter, chanceNull: number?): NullableParameter
		return {
			Key = valueType.Key,
			Type = "Nullable",
			ChanceNull = chanceNull,
			ValueType = valueType,
		}
	end,
	generate = function(param: NullableParameter, rng: Random): any?
		local chanceNull = param.ChanceNull or 0.5
		if rng:NextNumber() < chanceNull then
			return nil
		else
			return Parameter.Any.generate(param.ValueType, rng)
		end
	end :: (any, Random) -> any?,
	tostring = function(param: NullableParameter, value: any?): string
		if value == nil then
			return "nil"
		else
			return Parameter.Any.tostring(param.ValueType, value)
		end
	end,
}

type StaticParameter = {
	read Key: string,
	read Type: "Static",
	read Value: any?,
	read ToString: ((StaticParameter, value: any?) -> string)?,
}
Parameter.Static = {
	new = function(key: string, value: any?, toString: ((StaticParameter, value: any?) -> string)?): StaticParameter
		return {
			Key = key,
			Type = "Static",
			Value = value,
			ToString = toString,
		}
	end,
	generate = function(param: StaticParameter, rng: Random): any?
		return param.Value
	end :: (any, Random) -> any?,
	tostring = function(param: StaticParameter, value: any?): string
		if param.ToString then
			return param.ToString(param, value)
		end
		return tostring(value)
	end,
}

-- not really something to mass generate due to mem limits
type EditableImageSizePreset = "64x64" | "128x128" | "256x256" | "512x512" | "1024x1024" | "2048x2048"
local SIZE_TO_PRESET: { { Value: number, Preset: EditableImageSizePreset } } = {
	{ Value = 64, Preset = "64x64" },
	{ Value = 128, Preset = "128x128" },
	{ Value = 256, Preset = "256x256" },
	{ Value = 512, Preset = "512x512" },
	{ Value = 1024, Preset = "1024x1024" },
	{ Value = 2048, Preset = "2048x2048" },
}
type EditableImageParameter = {
	read Key: string,
	read Type: "EditableImage",
	read MinDim: number,
	read MaxDim: number,
	[typeof(HYDRATION_CACHE_KEY)]: { [EditableImageSizePreset]: EditableImage },
}
Parameter.EditableImage = {
	new = function(key: string, minDim: number?, maxDim: number?): EditableImageParameter
		return {
			Key = key,
			Type = "EditableImage" :: "EditableImage",
			MinDim = math.max(minDim or 1, 1),
			MaxDim = math.min(maxDim or 2048, 2048),
		}
	end,
	hydrate = function(param: EditableImageParameter)
		assert(param[HYDRATION_CACHE_KEY] == nil, `param "{param.Key}" already hydrated`)
		local hydrationCache = {}
		for i, sizePreset in ipairs(SIZE_TO_PRESET) do
			if param.MinDim <= sizePreset.Value and param.MaxDim >= sizePreset.Value then
				hydrationCache[sizePreset.Preset] = AssetService:CreateEditableImage({
					Size = Vector2.new(sizePreset.Value, sizePreset.Value),
				})
			end
		end
		param[HYDRATION_CACHE_KEY] = hydrationCache
	end,
	generate = function(param: EditableImageParameter, rng: Random)
		assert(param[HYDRATION_CACHE_KEY], `param "{param.Key}" not hydrated`)
		local x = rng:NextInteger(param.MinDim, param.MaxDim)
		local viableSizes = {}
		for _, sizePreset in ipairs(SIZE_TO_PRESET) do
			if sizePreset.Value >= x then
				table.insert(viableSizes, sizePreset.Preset)
			end
		end
		local chosenPreset = viableSizes[rng:NextInteger(1, #viableSizes)]
		local image = param[HYDRATION_CACHE_KEY][chosenPreset]
		assert(image, `no chosen preset at: "{chosenPreset}"`)
		return image
	end :: (any, Random) -> EditableImage,
	clean = function(param: EditableImageParameter)
		local editableImages = param[HYDRATION_CACHE_KEY]
		param[HYDRATION_CACHE_KEY] = nil
		assert(editableImages, `bad editable image`)
		for _, editableImage in pairs(editableImages) do
			editableImage:Destroy()
		end
	end,
	tostring = function(param: EditableImageParameter, value: EditableImage)
		return `EditableImage[{value.Size.X}][{value.Size.Y}]`
	end,
}

type TupleParameter = {
	read Key: string,
	read Type: "Tuple",
	read ValueTypes: { Parameter },
	read Processor: (...any) -> ...any,
}
Parameter.Tuple = {
	new = function(valueTypes: { Parameter }, processor: (...any) -> ...any): TupleParameter
		return {
			Key = "Tuple",
			Type = "Tuple",
			ValueTypes = valueTypes,
			Processor = processor,
		}
	end,
	generate = function(param: TupleParameter, rng: Random): ...any
		local function flattenParameters(params: { Parameter }): { Parameter }
			local unpackedParams: { any } = {}
			for _, param in params do
				if param.Type == "Tuple" then
					local tupleValues = flattenParameters(param.ValueTypes)
					for i = 1, #tupleValues do
						table.insert(unpackedParams, tupleValues[i])
					end
				else
					table.insert(unpackedParams, param)
				end
			end
			return unpackedParams
		end

		local generatedValues = {}
		local flatValueTypes = flattenParameters(param.ValueTypes)
		for i, valueType in ipairs(flatValueTypes) do
			generatedValues[i] = Parameter.Any.generate(valueType, rng)
		end
		return param.Processor(table.unpack(generatedValues, 1, #flatValueTypes))
	end :: (any, Random) -> { any },
	tostring = function(param: TupleParameter, values: { any }): string
		local valueStrings = {}
		for i, value in ipairs(values) do
			valueStrings[i] = Parameter.Any.tostring(param.ValueTypes[i], value)
		end
		return `Tuple({table.concat(valueStrings, ",")})`
	end,
}

Parameter.Any = {}
Parameter.Any.new = function(): Parameter
	error("Parameter.Any cannot be instantiated directly")
end
Parameter.Any.hydrate = function(param: Parameter): ()
	local solver = Parameter[param.Type]
	assert(solver ~= nil, `bad solver: "{param.Type}"`)
	if solver.hydrate then
		solver.hydrate(param)
	end
end
Parameter.Any.clean = function(param: Parameter): ()
	local solver = Parameter[param.Type]
	assert(solver ~= nil, `bad solver: "{param.Type}"`)
	if solver.clean then
		solver.clean(param)
	end
end
Parameter.Any.generate = function(param: Parameter, rng: Random): any?
	local solver = Parameter[param.Type]
	assert(solver ~= nil, `bad solver: "{param.Type}"`)
	return solver.generate(param, rng)
end :: (any, Random) -> any?
Parameter.Any.tostring = function(param: Parameter, value: any): string
	local solver = Parameter[param.Type]
	assert(solver ~= nil, `bad solver: "{param.Type}"`)
	if solver.tostring then
		return solver.tostring(param, value)
	end
	return tostring(value)
end

return Parameter
