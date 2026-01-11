local Tutorial = {}

local function CreateGuide(char: Model)
	local Att0 = Instance.new("Attachment", char.HumanoidRootPart)
	local Att1 = Instance.new("Attachment", char.HumanoidRootPart)
	
	local beam = script.Guide:Clone()
	beam.Parent = char.HumanoidRootPart
	beam.Attachment0 = Att0
	beam.Attachment1 = Att1
	return {Beam = beam, Attachment0 = Att0, Attachment1 = Att1}
end

function Tutorial.Start(player: Player)
	print("Tutorial Started")
	
	local character = player.Character or player.CharacterAdded:Wait()
	if character.HumanoidRootPart:FindFirstChild("Guide") then 
		return warn("Cannot start tutorial - in progress") 
	end
	
	local self = setmetatable(Tutorial, {})

	-- reload beam after death
	player.CharacterAppearanceLoaded:Connect(function(newCharacter)
		local newGuide = CreateGuide(newCharacter)
		
		self.GuideInfo = newGuide
		self.Character = newCharacter
		
		if self.CurrentObjective then
			self.GuideInfo.Attachment1.Parent = self.CurrentObjective
		end
	end)
	
	local newGuide = CreateGuide(character)
	
	self.GuideInfo = newGuide
	self.Character = character
	self.CurrentObjective = nil

	return self
end

function Tutorial:Objective(location: Part, Text: string, callback)
	local Attachment1 = self.GuideInfo.Attachment1
	Attachment1.Parent = location
	self.CurrentObjective = location
	if Text then
		script.Text.Value = Text
	end
	if callback then
		callback()
	end
	return Attachment1
end

function Tutorial:End(player: Player)
	print("Tutorial Ended")
	
	local Beam = self.GuideInfo.Beam
	local Attachment0 = self.GuideInfo.Attachment0
	local Attachment1 = self.GuideInfo.Attachment1
	Attachment0:Destroy()
	Attachment1:Destroy()
	Beam:Destroy()
	
	script.Text.Value = script.Text:GetAttribute("EndingText")
	task.delay(1, function()
		script.Text.Value = ""
	end)
	self = nil
end

return Tutorial
