local ParseProps = {}

local BrickColors = require(script.Parent.Parent.Utils.BrickColors)

opsBasic = {"+", "++", "--", "+-", "-"}
ops = {"+", "-", "/", "*"}
opsReplace = {
	["%+"]= "",
	["%+%+"]= "",
	["%-%-"]= "",
	["%+%-"]= "-",
	["%-"]= "-"
}

local function GmatchCount(gmatch) local count = 0 for m in gmatch do count+=1 end return count end
local function Strip(str) return str:gsub("^%s+", ""):gsub("%s+$", "") end
local function WsConds(str) return str:gsub("%s+", " ") end
local function StartsWithBasicOp(str) return (str:match("^+") or str:match("^-")) and true or false end
local function ReplaceOps(str) for k,v in opsReplace do str = str:gsub(k, v) end return str end
local function ScaleOrOffset(str) if GmatchCount(str:gmatch("%%$")) >= 1 then return "scale", 100 elseif GmatchCount(str:gmatch("px$")) >= 1 then return "offset", 1 end end
function StripNonNumExprr(str) return str:gsub("[^%d.%-]+", "") end

local function ParseScaleAndOffset(value)
	-- turns the value into a list
	value = WsConds(value); local values = value:split(" ")
	
	local parsedValues, scaleVals, offsetVals = {},{}, {}
	
	-- iterates through values and parses them
	for k,v in values do
		-- combines v with the previous operator
		if not StartsWithBasicOp(v) then
			local prevV = values[math.max(k-1, 0)]
			if table.find(opsBasic, prevV) then
				v = prevV..v
			end
		end
		
		table.insert(parsedValues, v)
	end
	
	-- converts operators and adds numbers to the correct table
	for k,v in parsedValues do
		-- determines if the value is a scale or an offset
		local scaleOrOffset, divAmount = ScaleOrOffset(v)
		if not scaleOrOffset then continue end
		
		v = StripNonNumExprr(ReplaceOps(v))
		v = tonumber(v)/divAmount
		
		
		-- inserts value into correct table
		if scaleOrOffset == "scale" then table.insert(scaleVals, v)
		else table.insert(offsetVals, v) end
	end
	
	-- adds all of the scales together, and all of the offsets together
	local scale, offset = 0,0
	table.foreach(scaleVals, function(i, v) scale += v end)
	table.foreach(offsetVals, function(i, v) offset += v end)
	
	return scale, offset
end

ParseProps.Width = function(value)
	local scale, offset = ParseScaleAndOffset(value)
	return "Width", UDim2.new(scale,offset, 0,0)
end
ParseProps.Height = function(value)
	local scale, offset = ParseScaleAndOffset(value)
	return "Height", UDim2.new(0,0, scale,offset)
end

ParseProps.PosX = function(value)
	local scale, offset = ParseScaleAndOffset(value)
	return "PosX", UDim2.new(scale,offset, 0,0)
end
ParseProps.PosY = function(value)
	local scale, offset = ParseScaleAndOffset(value)
	return "PosY", UDim2.new(0,0, scale,offset)
end

anchorPointConvertor = {
	["center"] = .5,
	["left"] = 0,
	["right"] = 1,
	["top"] = 0,
	["bottom"] = 1,
}
ParseProps.Anchor = function(value)
	-- turns the value into a list
	value = WsConds(value); local values = value:split(" ")
	
	if #values == 1 then
		local convertedValue = anchorPointConvertor[value]
		return "AnchorPoint", Vector2.new(convertedValue, convertedValue)
		
	elseif #values == 2 then
		return "AnchorPoint", Vector2.new(
			anchorPointConvertor[values[1]],
			anchorPointConvertor[values[2]]
		)
	end
end

ParseProps.AspectRatio = function(value)
	value = (typeof(value) ~= "number") and StripNonNumExprr(WsConds(value)) or value
	return "AspectRatio", value, "UIAspectRatioConstraint"
end

ParseProps.DominantAxis = function(value)
	value = (value == "Height" or value == "Width") and value or "Width"
	return "DominantAxis", value, "UIAspectRatioConstraint"
end

ParseProps.Padding = function(value)
	value = StripNonNumExprr(value); value = tonumber(value)
	value = UDim.new(0,value)
	return {"PaddingLeft", "PaddingRight", "PaddingTop", "PaddingBottom"}, value, "UIPadding"
end

ParseProps.CornerRadius = function(value)
	local scale, offset = ParseScaleAndOffset(value)
	return "CornerRadius", UDim.new(scale,offset), "UICorner"
end

ParseProps.Background = function(value)
	value = (BrickColors[value] or BrickColor.new("Medium stone grey")).Color
	return "BackgroundColor3", value
end

ParseProps.Content = function(value)
	if typeof(value) ~= "string" then value = tostring(value) end
	return "Text", value
end
ParseProps.ContentScaled = function(value)
	value = typeof(value) == "boolean" and value or false
	return "TextScaled", value
end

return ParseProps