local Functions = require(script.Parent.Functions)

local EmptyUDim2 = UDim2.new()

return function(props)
	local parsedProps = table.create(#props)
	local width, height, posX, posY = EmptyUDim2, EmptyUDim2, EmptyUDim2, EmptyUDim2
	
	for k,v in props do
		if not Functions[k] then continue end

		local parsedKey, parsedValue, subInstName = Functions[k](v)

		-- continues if width or height
		if parsedKey == "Width" then width = parsedValue; continue end
		if parsedKey == "Height" then height = parsedValue; continue end
		-- continues if posX or posY
		if parsedKey == "PosX" then posX = parsedValue; continue end
		if parsedKey == "PosY" then posY = parsedValue; continue end
		
		-- if prop is of a sub instance (UIAspectRatioConstraint for example)
		if subInstName then
			if not parsedProps[subInstName] then parsedProps[subInstName] = {} end

			if typeof(parsedKey) == "table" then
				for k2,v2 in parsedKey do parsedProps[subInstName][v2] = parsedValue end
			else
				parsedProps[subInstName][parsedKey] = parsedValue
			end
			
		-- if prop is not part of a sub instance
		else
			if typeof(parsedKey) == "table" then
				for k2,v2 in parsedKey do parsedProps[v2] = parsedValue end
			else
				parsedProps[parsedKey] = parsedValue
			end
		end
	end

	if width ~= EmptyUDim2 and height ~= EmptyUDim2 then parsedProps["Size"] = width+height end
	if posX ~= EmptyUDim2 and posY ~= EmptyUDim2 then parsedProps["Position"] = posX+posY end
	
	return parsedProps
end