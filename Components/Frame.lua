local BaseComponent = require(script.Parent.BaseComponent)

return function(props)
	local frame = BaseComponent("Frame", "Frame", props)
	
	return frame
end
