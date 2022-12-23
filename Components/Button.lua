local BaseComponent = require(script.Parent.BaseComponent)

return function(props)
	local button = BaseComponent("TextButton", "Button", props)

	return button
end
