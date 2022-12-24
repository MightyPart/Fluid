# Fluid
This is currently a prototype/proof of concept. It is not indended to be used for non-testing purposes.

# Example

```lua
local Fluid = require(game:GetService("ServerStorage").Fluid.Main)

View = Fluid:CreateView {
	[Fluid.Styles "#BASE"] = {
		Width="50%"; Height="50%";
		PosX="50%"; PosY="50%"; Anchor="center";
		AspectRatio=.95; DominantAxis="Height";
		Padding="15px";
		CornerRadius="15px";
		Background="Institutional white"
	},
	[Fluid.Styles "@Button"] = {
		Width="100%"; Height="55px";
		PosX="50%"; PosY="100%"; Anchor="center bottom";
		Content="Hello There"; ContentScaled=true;
		Padding="15px";
		CornerRadius="10px";
		Background="Baby blue";
	},
	
	
	[Fluid.Frame { ID="BASE" }] = {
		Fluid.Button()
	}
}

View:Refresh()
```

![image](https://user-images.githubusercontent.com/66361859/209414350-efe70969-29f3-4ae8-a945-ef43b13c456e.png)
