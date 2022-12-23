local FluidMain = {}

-- MODULES
local PropsParser = require(script.Parent.PropsParser.PropsParserMain)
local View = require(script.Parent.View.ViewMain)

-- COMPONENTS
local Components = script.Parent.Components
FluidMain.Frame = require(Components.Frame)
FluidMain.Button = require(Components.Button)

function FluidMain:CreateView(props)
	local view = Instance.new("ScreenGui")
	
	view.Parent = game:GetService("StarterGui")
	
	local styles, newProps = {},{}
	
	for k,v in props do
		if typeof(k) == "string" and k:match("^FluidStyles") then
			local newK = k:gsub("FluidStyles_", "")
			styles[newK] = v
			
		elseif typeof(k) == "table" then newProps[k] = v end
	end
	
	-- parses all of the styles
	local parsedStyles = table.create(#styles)
	for k,v in styles do
		parsedStyles[k] = PropsParser(v)
	end
	
	return setmetatable({
		Props = newProps,
		Styles = parsedStyles,
		Instance = view
	}, View)
end

function FluidMain.Styles(id)
	return string.format("FluidStyles_%s", id)
end

return FluidMain