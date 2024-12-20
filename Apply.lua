local Game											= game
local Services										= setmetatable({}, { __index = function(Self, Service) return Game.GetService(Game, Service) end })

return function(Character, Type, Mode, FX)		
	if not Character then return { Success = false, Message = string.format("Character Argument: %s Does not exist.", Character) } end
	if typeof(Character) ~= "Instance" then return { Success = false, Message = string.format("Character Argument: Not an instance, but %s.", typeof(Character)) } end
	if not Character:IsA("Model") then return { Success = false, Message = string.format("Character Argument: Not an model, but %s.", Character.ClassName) } end
	
	local TypeCheck									= Type and script.Rigs:FindFirstChild(Type)
	local ModeCheck									= TypeCheck and script.Rigs:FindFirstChild(Type):FindFirstChild(Mode)

	if not TypeCheck then return { Success = false, Message = string.format("Type Argument: %s Does not exist.", Type) } end
	if not ModeCheck then return { Success = false, Message = string.format("Mode Argument: %s Does not exist.", Mode) } end
		
	if not Character then return { Success = false, Message = string.format("Character Does not exist.") } end
	if typeof(Character) ~= "Instance" then return { Success = false, Message = string.format("Character is not an instance.") } end
	
	if Character:FindFirstChild("Body") then Character:FindFirstChild("Body"):Destroy() end
	
	if FX then FX.Smoke(Character) end
		
	local Rig										= script.Rigs:FindFirstChild(Type):FindFirstChild(Mode):FindFirstChild("Body"):Clone()
	Rig.Parent										= Character
	
	local Folder									= Character:FindFirstChild("Clothing") or Instance.new("Folder")
	Folder.Parent									= Character
	Folder.Name										= "Clothing"
	
	local Head										= Character:FindFirstChild("Head")
	local Torso										= Character:FindFirstChild("Torso")
	
	local LeftArm									= Character:FindFirstChild("Left Arm")
	local RightArm									= Character:FindFirstChild("Right Arm")
	
	local LeftLeg									= Character:FindFirstChild("Left Leg")
	local RightLeg									= Character:FindFirstChild("Right Leg")

	local Shirt										= Character:FindFirstChild("Shirt") or Folder:FindFirstChild("Shirt") or nil
	local Pants										= Character:FindFirstChild("Pants") or Folder:FindFirstChild("Pants") or nil
	local TShirt									= Character:FindFirstChild("Shirt Graphic") or Folder:FindFirstChild("Shirt Graphic") or nil
	local Colors									= Character:FindFirstChild("Body Colors") or {
		HeadColor3									= Head.Color,
		TorsoColor3									= Torso.Color,
		
		RightArmColor3								= RightArm.Color,
		LeftArmColor3								= LeftArm.Color,
		
		RightLegColor3								= RightLeg.Color,
		LeftLegColor3								= LeftLeg.Color,
	}
	
	local Hue, Saturation, Value 					= Colors["TorsoColor3"]:ToHSV() Value = math.clamp(Value - 0.2, 0, 1)
	local Saturated 								= Color3.fromHSV(Hue, Saturation, Value)
	
	if Mode == "Naked" then if Shirt then Shirt.Parent = Folder end if Pants then Pants.Parent = Folder end if TShirt then TShirt.Parent = Folder end end 
	if Mode == "Clothed" then if Shirt then Shirt.Parent = Character end if Pants then Pants.Parent = Character end if TShirt then TShirt.Parent = Character end end 
	
	do
		Head.Transparency							= 0
		Torso.Transparency							= 0
		
		LeftArm.Transparency						= 0
		RightArm.Transparency						= 0
		
		LeftLeg.Transparency						= 0
		RightLeg.Transparency						= 0
	end
	
	for i, BodyPart in next, Character:GetChildren() do
		if not BodyPart:IsA("Part") then continue end
		if not Rig:FindFirstChild(string.format("%s Weld", BodyPart.Name)) then continue end
		
		local Weld									= Rig:FindFirstChild(string.format("%s Weld", BodyPart.Name))
		local Body									= Rig:FindFirstChild(string.format("%s Body", BodyPart.Name))
		
		BodyPart.Transparency						= BodyPart.Name:find("Arm") and 0 or 1
		Body.CFrame									= BodyPart.CFrame
		Body.Color									= Colors[string.format("%sColor3", string.gsub(BodyPart.Name, " ", ""))]
		
		Weld.Part0									= BodyPart
		Weld.Part1									= Body
		Weld.Enabled								= true
	end
	
	for i, Object in next, Rig:GetChildren() do
		if Object.Name == "Ass" then
			Object["Left MCheek"].Color				= Colors["TorsoColor3"]
			Object["Right MCheek"].Color			= Colors["TorsoColor3"]
		end
		
		if Object.Name == "Dick" then
			Object.Balls.Color						= Colors["TorsoColor3"]
			Object.Body.Color						= Colors["TorsoColor3"]
			Object.Tip.Color						= Saturated
		end
		
		if Object.Name == "Pussy" then
			Object.PrimaryPussy.Color				= Colors["TorsoColor3"]
			Object.Dot.Color						= Saturated
			Object.Outer.Color						= Saturated
			Object.Inner.Color						= Saturated
		end

		if Object.Name == "Boobs" then
			local Overlay							= Object.Overlay
			local Main								= Object.Main

			if Mode == "Clothed" then
				Overlay.BoobsShirt.Texture			= Shirt and Shirt.ShirtTemplate or "rbxassetid://0"
				Overlay.BoobsPants.Texture			= Pants and Pants.PantsTemplate or "rbxassetid://0"
			end

			Main.Color								= Colors["TorsoColor3"] 
			Main.Front.Color3						= Saturated
			
			if getcustomasset then Main.Front.Texture = getcustomasset("Fondra-Physics/Nipple") end
		end
		
		if not Object:IsA("Motor6D") then continue end
		
		Object.Part0								= Torso
		Object.Part1								= Object.Part1
		
		Object:SetAttribute("OriginalC0", Object.C0)
	end
	
	for i, Object in next, Rig:GetDescendants() do				
		if string.find(Object.Name, "Cloth") then
			if Mode == "Naked" then
				Object.Transparency = 1 continue
			end
			
			if Mode == "Clothed" then
				if string.find(Object.Name, "A Cloth") and Shirt then Object.TextureID = Shirt.ShirtTemplate continue end	
				if string.find(Object.Name, "L Cloth") and Pants then Object.TextureID = Pants.PantsTemplate continue end	
				
				if string.find(Object.Name, "A Cloth") and not Shirt then Object.Transparency = 1 continue end	
				if string.find(Object.Name, "L Cloth") and not Pants then Object.Transparency = 1 continue end	
				
				if string.find(Object.Name, "RA Cloth") then Object.Color = Colors["RightArmColor3"] continue end	
				if string.find(Object.Name, "LA Cloth") then Object.Color = Colors["LeftArmColor3"] continue end
				
				if string.find(Object.Name, "RL Cloth") then Object.Color = Colors["RightLegColor3"] continue end	
				if string.find(Object.Name, "LL Cloth") then Object.Color = Colors["LeftLegColor3"] continue end
			end
		end
		
		if Mode == "Naked" then
			if Object.Name == "Shirt" and Object:IsA("MeshPart") then
				Object.Transparency = 1 continue
			end
			
			if Object.Name == "Pants" and Object:IsA("MeshPart") then
				Object.Transparency = 1 continue
			end
		end
		
		if Mode == "Clothed" then 			
			-- Shirt
			if Shirt and Object.Name == "Shirt" and Object:IsA("MeshPart") then
				Object.TextureID = Shirt.ShirtTemplate continue
			end
			
			if not Shirt and Object.Name == "Shirt" and Object:IsA("MeshPart") then
				Object.Transparency = 1 continue
			end	
			
			-- Pants
			if Pants and Object.Name == "Pants" and Object:IsA("MeshPart") then
				Object.TextureID = Pants.PantsTemplate continue
			end
			
			if not Pants and Object.Name == "Pants" and Object:IsA("MeshPart") then
				Object.Transparency = 1 continue
			end	
		end
		
		-- T-Shirt
		if TShirt and Object.Name == "TShirtDecal" and Object:IsA("Decal") then				
			Object.Texture = TShirt.Graphic continue
		end

		if not TShirt and Object.Name == "TShirtDecal" and Object:IsA("Decal") then
			Object.Transparency = 1 continue
		end	
	end
		
	return { Success = true, Message = string.format("Successfully applied a %s %s rig on %s's", Mode, Type, Character.Name) }, Rig
end