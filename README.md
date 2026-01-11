## Example

```lua
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Tutorial = require(ReplicatedStorage.Tutorial)

Players.PlayerAdded:Connect(function(player)
	local newTutorial = Tutorial.Start(player)
	
	newTutorial:Objective(workspace.Test, "Go to the part")
	
	workspace.Test.Touched:Connect(function()
		newTutorial:Objective(workspace.Test2, "Trigger the prompt on other part")
	end)
	
	workspace.Test2.ProximityPrompt.Triggered:Connect(function()
		if newTutorial.CurrentObjective == workspace.Test2 then
			newTutorial:End()
		end
	end)
end)
```
