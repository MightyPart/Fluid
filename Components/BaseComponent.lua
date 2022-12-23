local BaseComponents = {}; BaseComponents.__index = BaseComponents

local PropsParser = require(script.Parent.Parent.PropsParser.PropsParserMain)

local EmptyList = table.create(1)

local function ApplyProps(inst, props)
	for k,v in props do
		if typeof(v) == "table" then
			local subInst = Instance.new(k)
			for k2,v2 in v do
				subInst[k2] = v2
			end
			subInst.Parent = inst

		else
			inst[k] = v
		end
	end
end

local function quickInsert(src: {[any]: any}, items: {[any]: any}, index: number)
	table.move(src, index, #src, index + #items)
	table.move(items, 1, #items, index, src)
end

function BaseComponents:Render(parent, children, embeddedStyles)
	local parsedProps = self.ParsedProps
	local ID, FluidClass = self.ID or "", self.FluidClass
	
	-- filters through the styles and compiles the relevant ones
	local filteredEmbeddedStyles = {}
	for k,v in pairs(embeddedStyles) do
		if not (k == string.format("#%s", ID) or k == string.format("@%s", FluidClass)) then continue end
		quickInsert(filteredEmbeddedStyles, {v}, #filteredEmbeddedStyles)
	end
	
	local inst = Instance.new(self.RobloxClass)
	
	for _,v in pairs(filteredEmbeddedStyles) do ApplyProps(inst, v) end
	if parsedProps then ApplyProps(inst, parsedProps) end
	
	if typeof(children) == "table" then
		for k,v in children do
			if typeof(k) == "table" then k:Render(inst, v, embeddedStyles)
			else v:Render(inst, EmptyList, embeddedStyles)  end
		end
	end
	
	inst.Parent = parent
end

return function (robloxClass, fluidClass, props)	
	local parsedProps = props and PropsParser(props) 
	local ID = props and props["ID"]
	
	return setmetatable({
		RobloxClass = robloxClass,
		FluidClass = fluidClass,
		Props = props,
		ParsedProps = parsedProps,
		ID = ID,
		Children = {}
	}, BaseComponents)
end