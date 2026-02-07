--!strict
-- Services
-- Packages
-- Modules
-- Types
-- Constants
local CONSTANTS = require(game.ReplicatedStorage.Shared.CONSTANTS)
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

type CustomParameter = {
	read Key: string,
	read Type: "Custom",
	read Method: (Random) -> any?,
	read ToString: ((CustomParameter) -> string)?,
}
Parameter.Custom = {
	new = function(key: string, method: (Random) -> any?, toString: ((CustomParameter) -> string)?): CustomParameter
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
	tostring = function(param: CustomParameter): string
		if param.ToString then
			return param.ToString(param)
		end
		return string.format("Custom<%s>", param.Key)
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
}

type MapParameter = {
	read Key: string,
	read Type: "Map",
	read ValueType: Parameter,
	read KeyType: Parameter,
	read MinLength: number?,
	read MaxLength: number?,
}
Parameter.Map = {
	new = function(
		key: string,
		keyType: Parameter,
		valueType: Parameter,
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
		return result
	end :: (any, Random) -> { [any]: any },
}

type NullableParameter = {
	read Key: string,
	read Type: "Nullable",
	read ChanceNull: number?,
	read ValueType: Parameter,
}
Parameter.Nullable = {
	new = function(key: string, valueType: Parameter, chanceNull: number?): NullableParameter
		return {
			Key = key,
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
}

type StaticParameter = {
	read Key: string,
	read Type: "Static",
	read Value: any?,
}
Parameter.Static = {
	new = function(key: string, value: any?): StaticParameter
		return {
			Key = key,
			Type = "Static",
			Value = value,
		}
	end,
	generate = function(param: StaticParameter, rng: Random): any?
		return param.Value
	end :: (any, Random) -> any?,
}

Parameter.Any = {}
Parameter.Any.new = function(): Parameter
	error("Parameter.Any cannot be instantiated directly")
end
Parameter.Any.generate = function(param: Parameter, rng: Random): any?
	local solver = Parameter[param.Type]
	assert(solver, `bad solver: "{param.Type}"`)
	return solver.generate(param, rng)
end :: (any, Random) -> any?

return Parameter
