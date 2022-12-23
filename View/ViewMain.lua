local View = {}; View.__index = View

local function quickInsert(src: {[any]: any}, items: {[any]: any}, index: number)
	table.move(src, index, #src, index + #items)
	table.move(items, 1, #items, index, src)
end

function View:Refresh()
	--local currParent = nil
	for k,children in self.Props do
		k:Render(self.Instance, children, self.Styles)
	end
end

return View