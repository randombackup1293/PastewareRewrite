repeat task.wait() until game:IsLoaded()
repeat task.wait() until shared.GuiLibrary

local function run(func)
	task.spawn(function()
		local suc, err = pcall(function() func() end)
		if err then warn("[VW687224481.lua Module Error]: "..tostring(debug.traceback(err))) end
	end)
end
local GuiLibrary = shared.GuiLibrary
local store = shared.GlobalStore
local bedwars = shared.GlobalBedwars
local vape = shared.vape
local entitylib = vape.Libraries.entity
local targetinfo = vape.Libraries.targetinfo
local sessioninfo = vape.Libraries.sessioninfo
local uipallet = vape.Libraries.uipallet
local tween = vape.Libraries.tween
local color = vape.Libraries.color
local whitelist = vape.Libraries.whitelist
local prediction = vape.Libraries.prediction
local getfontsize = vape.Libraries.getfontsize
local getcustomasset = vape.Libraries.getcustomasset

local runService = game:GetService("RunService")
local RunService = runService
local runservice = runService

local CustomsAllowed = false

local collectionService = game:GetService("CollectionService")
local CollectionService = collectionService
shared.vapewhitelist = vape.Libraries.whitelist
local playersService = game:GetService("Players")
if (not shared.GlobalBedwars) or (shared.GlobalBedwars and type(shared.GlobalBedwars) ~= "table") or (not shared.GlobalStore) or (shared.GlobalStore and type(shared.GlobalStore) ~= "table") then
	errorNotification("VW-BEDWARS", "Critical! Important connection is missing! Please report this bug to erchodev#0", 10)
	pcall(function()
		function GuiLibrary:Save()
			warningNotification("GuiLibrary.SaveSettings", "Profiles saving is disabled due to error in the code!", 1)
		end
	end)
	local delfile = delfile or function(file) writefile(file, "") end
	if isfile('vape/games/6872274481.lua') then delfile('vape/games/6872274481.lua') end
end
local entityLibrary = entitylib
local VoidwareStore = {
	bedtable = {},
	Tweening = false
}

local networkownerswitch = tick()
-- xylex ._.
local isnetworkowner = function(part)
	local suc, res = pcall(function() return gethiddenproperty(part, "NetworkOwnershipRule") end)
	if suc and res == Enum.NetworkOwnership.Manual then
		sethiddenproperty(part, "NetworkOwnershipRule", Enum.NetworkOwnership.Automatic)
		networkownerswitch = tick() + 8
	end
	return networkownerswitch <= tick()
end

VoidwareFunctions.GlobaliseObject("lplr", game:GetService("Players").LocalPlayer)
VoidwareFunctions.LoadFunctions("Bedwars")

local function BedwarsInfoNotification(mes)
    local bedwars = shared.GlobalBedwars
	local NotificationController = bedwars.NotificationController
	NotificationController:sendInfoNotification({
		message = tostring(mes),
		image = "rbxassetid://18518244636"
	});
end
getgenv().BedwarsInfoNotification = BedwarsInfoNotification
local function BedwarsErrorNotification(mes)
    local bedwars = shared.GlobalBedwars
	local NotificationController = bedwars.NotificationController
	NotificationController:sendErrorNotification({
		message = tostring(mes),
		image = "rbxassetid://18518244636"
	});
end
getgenv().BedwarsErrorNotification = BedwarsErrorNotification

VoidwareFunctions.LoadFunctions("Bedwars")

local gameCamera = game.Workspace.CurrentCamera

local lplr = game:GetService("Players").LocalPlayer

local btext = function(text)
	return text..' '
end
local void = function() end
local runservice = game:GetService("RunService")
local newcolor = function() return {Hue = 0, Sat = 0, Value = 0} end
function safearray()
    local array = {}
    local mt = {}
    function mt:__index(index)
        if type(index) == "number" and (index < 1 or index > #array) then
            return nil
        end
        return array[index]
    end
    function mt:__newindex(index, value)
        if type(index) == "number" and index > 0 then
            array[index] = value
        else
            error("Invalid index for safearray", 2)
        end
    end
    function mt:insert(value)
        table.insert(array, value)
    end
    function mt:remove(index)
        if type(index) == "number" and index > 0 and index <= #array then
            table.remove(array, index)
        else
            error("Invalid index for safearray removal", 2)
        end
    end
    function mt:length()
        return #array
	end
    setmetatable(array, mt)
    return array
end
function getrandomvalue(list)
    local count = #list
    if count == 0 then
        return ''
    end
    local randomIndex = math.random(1, count)
    return list[randomIndex]
end

local vapeConnections
if shared.vapeConnections and type(shared.vapeConnections) == "table" then vapeConnections = shared.vapeConnections else vapeConnections = {} shared.vapeConnections = vapeConnections end

GuiLibrary.SelfDestructEvent.Event:Connect(function()
	for i, v in pairs(vapeConnections) do
		if v.Disconnect then pcall(function() v:Disconnect() end) continue end
		if v.disconnect then pcall(function() v:disconnect() end) continue end
	end
end)
local whitelist = shared.vapewhitelist

task.spawn(function()
    pcall(function()
        local lplr = game:GetService("Players").LocalPlayer
        local char = lplr.Character or lplr.CharacterAdded:wait()
        local displayName = char:WaitForChild("Head"):WaitForChild("Nametag"):WaitForChild("DisplayNameContainer"):WaitForChild("DisplayName")
        repeat task.wait() until shared.vapewhitelist
        repeat task.wait() until shared.vapewhitelist.loaded
        local tag = shared.vapewhitelist:tag(lplr, "", true)
        if displayName.ClassName == "TextLabel" then
            if not displayName.RichText then displayName.RichText = true end
            displayName.Text = tag..lplr.Name
        end
        displayName:GetPropertyChangedSignal("Text"):Connect(function()
            if displayName.Text ~= tag..lplr.Name then
                displayName.Text = tag..lplr.Name
            end
        end)
    end)
end)

local GetEnumItems = function() return {} end
	GetEnumItems = function(enum)
		local fonts = {}
		for i,v in next, Enum[enum]:GetEnumItems() do 
			table.insert(fonts, v.Name) 
		end
		return fonts
	end

--[[run(function()
	local ChosenPack = {Value = "Realistic Pack"}
	local TexturePacks = {Enabled = false}
	TexturePacks = vape.Categories.Utility:CreateModule({
		Name = "Texture Packs",
		Tooltip = "Replaces the boring sword with a better texture pack.",
		Function = function(callback)
			if callback then 
				task.spawn(function()
					repeat task.wait() until store.matchState ~= 0
					local function killPlayer(player)
						local character = player.Character
						if character then
							local humanoid = character:FindFirstChildOfClass("Humanoid")
							if humanoid then
								humanoid.Health = 0
							end
						end
					end
					local canRespawn = function() end
					canRespawn = function()
						local success, response = pcall(function() 
							return lplr.leaderstats.Bed.Value == '✅' 
						end)
						return success and response 
					end
					warningNotification("Texture packs", "Reset for the pack to work", 3)
					--if canRespawn() then warningNotification("Texture packs", "Resetting for the texture to get applied", 5) killPlayer(lplr) else warningNotification("Texture packs", "Unable to reset your chatacter! Please do it manually", 3) end
					TexturePacks.Enabled = false 
					TexturePacks.Enabled = true 
					if ChosenPack.Value == "Realistic Pack" then
						local Services = {
							Storage = game:GetService("ReplicatedStorage"),
							Workspace = game:GetService("Workspace"),
							Players = game:GetService("Players")
						}
						
						local ASSET_ID = "rbxassetid://14431940695"
						local PRIMARY_ROTATION = CFrame.Angles(0, -math.pi/4, 0)
						
						local ToolMaterials = {
							sword = {"wood", "stone", "iron", "diamond", "emerald"},
							pickaxe = {"wood", "stone", "iron", "diamond"},
							axe = {"wood", "stone", "iron", "diamond"}
						}
						
						local Offsets = {
							sword = CFrame.Angles(0, -math.pi/2, -math.pi/2),
							pickaxe = CFrame.Angles(0, -math.pi, -math.pi/2),
							axe = CFrame.Angles(0, -math.pi/18, -math.pi/2)
						}
						
						local ToolIndex = {}
						
						local function initializeToolIndex(asset)
							for toolType, materials in pairs(ToolMaterials) do
								for _, material in ipairs(materials) do
									local identifier = material .. "_" .. toolType
									local toolModel = asset:FindFirstChild(identifier)
						
									if toolModel then
										--print("Found tool in initializeToolIndex:", identifier)
										table.insert(ToolIndex, {
											Name = identifier,
											Offset = Offsets[toolType],
											Model = toolModel
										})
									else
										--warn("Model for " .. identifier .. " not found in initializeToolIndex!")
									end
								end
							end
						end
						
						local function adjustAppearance(part)
							if part:IsA("BasePart") then
								part.Transparency = 1
							end
						end
						
						local function attachModel(target, data, modifier)
							local clonedModel = data.Model:Clone()
							clonedModel.CFrame = target:FindFirstChild("Handle").CFrame * data.Offset * PRIMARY_ROTATION * (modifier or CFrame.new())
							clonedModel.Parent = target
						
							local weld = Instance.new("WeldConstraint", clonedModel)
							weld.Part0 = clonedModel
							weld.Part1 = target:FindFirstChild("Handle")
						end
						
						local function processTool(tool)
							if not tool:IsA("Accessory") then return end
						
							for _, toolData in ipairs(ToolIndex) do
								if toolData.Name == tool.Name then
									for _, child in pairs(tool:GetDescendants()) do
										adjustAppearance(child)
									end
									attachModel(tool, toolData)
						
									local playerTool = Services.Players.LocalPlayer.Character:FindFirstChild(tool.Name)
									if playerTool then
										for _, child in pairs(playerTool:GetDescendants()) do
											adjustAppearance(child)
										end
										attachModel(playerTool, toolData, CFrame.new(0.4, 0, -0.9))
									end
								end
							end
						end
						
						
						local loadedTools = game:GetObjects(ASSET_ID)
						local mainAsset = loadedTools[1]
						mainAsset.Parent = Services.Storage
						
						wait(1)
						
						
						for _, child in pairs(mainAsset:GetChildren()) do
							--print("Found tool in asset:", child.Name)
						end
						
						initializeToolIndex(mainAsset)
						Services.Workspace:WaitForChild("Camera").Viewmodel.ChildAdded:Connect(processTool)
					elseif ChosenPack.Value == "32x Pack" then 
						local Services = {
							Storage = game:GetService("ReplicatedStorage"),
							Workspace = game:GetService("Workspace"),
							Players = game:GetService("Players")
						}
						
						local ASSET_ID = "rbxassetid://14421314747"
						local PRIMARY_ROTATION = CFrame.Angles(0, -math.pi/4, 0)
						
						local ToolMaterials = {
							sword = {"wood", "stone", "iron", "diamond", "emerald"},
							pickaxe = {"wood", "stone", "iron", "diamond"},
							axe = {"wood", "stone", "iron", "diamond"}
						}
						
						local Offsets = {
							sword = CFrame.Angles(0, -math.pi/2, -math.pi/2),
							pickaxe = CFrame.Angles(0, -math.pi, -math.pi/2),
							axe = CFrame.Angles(0, -math.pi/18, -math.pi/2)
						}
						
						local ToolIndex = {}
						
						local function initializeToolIndex(asset)
							for toolType, materials in pairs(ToolMaterials) do
								for _, material in ipairs(materials) do
									local identifier = material .. "_" .. toolType
									local toolModel = asset:FindFirstChild(identifier)
						
									if toolModel then
										--print("Found tool in initializeToolIndex:", identifier)
										table.insert(ToolIndex, {
											Name = identifier,
											Offset = Offsets[toolType],
											Model = toolModel
										})
									else
										--warn("Model for " .. identifier .. " not found in initializeToolIndex!")
									end
								end
							end
						end
						
						local function adjustAppearance(part)
							if part:IsA("BasePart") then
								part.Transparency = 1
							end
						end
						
						local function attachModel(target, data, modifier)
							local clonedModel = data.Model:Clone()
							clonedModel.CFrame = target:FindFirstChild("Handle").CFrame * data.Offset * PRIMARY_ROTATION * (modifier or CFrame.new())
							clonedModel.Parent = target
						
							local weld = Instance.new("WeldConstraint", clonedModel)
							weld.Part0 = clonedModel
							weld.Part1 = target:FindFirstChild("Handle")
						end
						
						local function processTool(tool)
							if not tool:IsA("Accessory") then return end
						
							for _, toolData in ipairs(ToolIndex) do
								if toolData.Name == tool.Name then
									for _, child in pairs(tool:GetDescendants()) do
										adjustAppearance(child)
									end
									attachModel(tool, toolData)
						
									local playerTool = Services.Players.LocalPlayer.Character:FindFirstChild(tool.Name)
									if playerTool then
										for _, child in pairs(playerTool:GetDescendants()) do
											adjustAppearance(child)
										end
										attachModel(playerTool, toolData, CFrame.new(0.4, 0, -0.9))
									end
								end
							end
						end
						
						
						local loadedTools = game:GetObjects(ASSET_ID)
						local mainAsset = loadedTools[1]
						mainAsset.Parent = Services.Storage
						
						wait(1)
						
						
						for _, child in pairs(mainAsset:GetChildren()) do
							--print("Found tool in asset:", child.Name)
						end
						
						initializeToolIndex(mainAsset)
						Services.Workspace:WaitForChild("Camera").Viewmodel.ChildAdded:Connect(processTool)
					elseif ChosenPack.Value == "16x Pack" then 
						local Services = {
							Storage = game:GetService("ReplicatedStorage"),
							Workspace = game:GetService("Workspace"),
							Players = game:GetService("Players")
						}
						
						local ASSET_ID = "rbxassetid://14474879594"
						local PRIMARY_ROTATION = CFrame.Angles(0, -math.pi/4, 0)
						
						local ToolMaterials = {
							sword = {"wood", "stone", "iron", "diamond", "emerald"},
							pickaxe = {"wood", "stone", "iron", "diamond"},
							axe = {"wood", "stone", "iron", "diamond"}
						}
						
						local Offsets = {
							sword = CFrame.Angles(0, -math.pi/2, -math.pi/2),
							pickaxe = CFrame.Angles(0, -math.pi, -math.pi/2),
							axe = CFrame.Angles(0, -math.pi/18, -math.pi/2)
						}
						
						local ToolIndex = {}
						
						local function initializeToolIndex(asset)
							for toolType, materials in pairs(ToolMaterials) do
								for _, material in ipairs(materials) do
									local identifier = material .. "_" .. toolType
									local toolModel = asset:FindFirstChild(identifier)
						
									if toolModel then
										--print("Found tool in initializeToolIndex:", identifier)
										table.insert(ToolIndex, {
											Name = identifier,
											Offset = Offsets[toolType],
											Model = toolModel
										})
									else
										--warn("Model for " .. identifier .. " not found in initializeToolIndex!")
									end
								end
							end
						end
						
						local function adjustAppearance(part)
							if part:IsA("BasePart") then
								part.Transparency = 1
							end
						end
						
						local function attachModel(target, data, modifier)
							local clonedModel = data.Model:Clone()
							clonedModel.CFrame = target:FindFirstChild("Handle").CFrame * data.Offset * PRIMARY_ROTATION * (modifier or CFrame.new())
							clonedModel.Parent = target
						
							local weld = Instance.new("WeldConstraint", clonedModel)
							weld.Part0 = clonedModel
							weld.Part1 = target:FindFirstChild("Handle")
						end
						
						local function processTool(tool)
							if not tool:IsA("Accessory") then return end
						
							for _, toolData in ipairs(ToolIndex) do
								if toolData.Name == tool.Name then
									for _, child in pairs(tool:GetDescendants()) do
										adjustAppearance(child)
									end
									attachModel(tool, toolData)
						
									local playerTool = Services.Players.LocalPlayer.Character:FindFirstChild(tool.Name)
									if playerTool then
										for _, child in pairs(playerTool:GetDescendants()) do
											adjustAppearance(child)
										end
										attachModel(playerTool, toolData, CFrame.new(0.4, 0, -0.9))
									end
								end
							end
						end
						
						
						local loadedTools = game:GetObjects(ASSET_ID)
						local mainAsset = loadedTools[1]
						mainAsset.Parent = Services.Storage
						
						wait(1)
						
						
						for _, child in pairs(mainAsset:GetChildren()) do
							--print("Found tool in asset:", child.Name)
						end
						
						initializeToolIndex(mainAsset)
						Services.Workspace:WaitForChild("Camera").Viewmodel.ChildAdded:Connect(processTool)
					elseif ChosenPack.Value == "Garbage" then 
						local Services = {
							Storage = game:GetService("ReplicatedStorage"),
							Workspace = game:GetService("Workspace"),
							Players = game:GetService("Players")
						}
						
						local ASSET_ID = "rbxassetid://14336548540"
						local PRIMARY_ROTATION = CFrame.Angles(0, -math.pi/4, 0)
						
						local ToolMaterials = {
							sword = {"wood", "stone", "iron", "diamond", "emerald"},
							pickaxe = {"wood", "stone", "iron", "diamond"},
							axe = {"wood", "stone", "iron", "diamond"}
						}
						
						local Offsets = {
							sword = CFrame.Angles(0, -math.pi/2, -math.pi/2),
							pickaxe = CFrame.Angles(0, -math.pi, -math.pi/2),
							axe = CFrame.Angles(0, -math.pi/18, -math.pi/2)
						}
						
						local ToolIndex = {}
						
						local function initializeToolIndex(asset)
							for toolType, materials in pairs(ToolMaterials) do
								for _, material in ipairs(materials) do
									local identifier = material .. "_" .. toolType
									local toolModel = asset:FindFirstChild(identifier)
						
									if toolModel then
										--print("Found tool in initializeToolIndex:", identifier)
										table.insert(ToolIndex, {
											Name = identifier,
											Offset = Offsets[toolType],
											Model = toolModel
										})
									else
										--warn("Model for " .. identifier .. " not found in initializeToolIndex!")
									end
								end
							end
						end
						
						local function adjustAppearance(part)
							if part:IsA("BasePart") then
								part.Transparency = 1
							end
						end
						
						local function attachModel(target, data, modifier)
							local clonedModel = data.Model:Clone()
							clonedModel.CFrame = target:FindFirstChild("Handle").CFrame * data.Offset * PRIMARY_ROTATION * (modifier or CFrame.new())
							clonedModel.Parent = target
						
							local weld = Instance.new("WeldConstraint", clonedModel)
							weld.Part0 = clonedModel
							weld.Part1 = target:FindFirstChild("Handle")
						end
						
						local function processTool(tool)
							if not tool:IsA("Accessory") then return end
						
							for _, toolData in ipairs(ToolIndex) do
								if toolData.Name == tool.Name then
									for _, child in pairs(tool:GetDescendants()) do
										adjustAppearance(child)
									end
									attachModel(tool, toolData)
						
									local playerTool = Services.Players.LocalPlayer.Character:FindFirstChild(tool.Name)
									if playerTool then
										for _, child in pairs(playerTool:GetDescendants()) do
											adjustAppearance(child)
										end
										attachModel(playerTool, toolData, CFrame.new(0.4, 0, -0.9))
									end
								end
							end
						end
						
						
						local loadedTools = game:GetObjects(ASSET_ID)
						local mainAsset = loadedTools[1]
						mainAsset.Parent = Services.Storage
						
						wait(1)
						
						
						for _, child in pairs(mainAsset:GetChildren()) do
							--print("Found tool in asset:", child.Name)
						end
						
						initializeToolIndex(mainAsset)
						Services.Workspace:WaitForChild("Camera").Viewmodel.ChildAdded:Connect(processTool)
					end
				end)
			end
		end
	})
	ChosenPack = TexturePacks:CreateDropdown({
        Name = "Pack",
        List = {
            "Realistic Pack",
            "32x Pack",
            "16x Pack",
            "Garbage",
        },
        Function = function() end,
    })
end)--]]

run(function()
	local PlayerLevelSet = {Enabled = false}
	local PlayerLevel = {Value = 100}
	PlayerLevelSet = vape.Categories.Misc:CreateModule({
		Name = 'SetPlayerLevel',
		Tooltip = 'Sets your player level to 100 (client sided)',
		Function = function(calling)
			if calling then 
				warningNotification("SetPlayerLevel", "This is client sided (only u will see the new level)", 3)
				game.Players.LocalPlayer:SetAttribute("PlayerLevel", PlayerLevel.Value)
			end
		end
	})
	PlayerLevel = PlayerLevelSet:CreateSlider({
		Name = 'Sets your desired player level',
		Function = function() if PlayerLevelSet.Enabled then game.Players.LocalPlayer:SetAttribute("PlayerLevel", PlayerLevel.Value) end end,
		Min = 1,
		Max = 100,
		Default = 100
	})
end)

run(function()
    local QueueDisplayConfig = {
        ActiveState = false,
        GradientControl = {Enabled = true},
        ColorSettings = {
            Gradient1 = {Hue = 0, Saturation = 0, Brightness = 1},
            Gradient2 = {Hue = 0, Saturation = 0, Brightness = 0.8}
        },
        Animation = {Speed = 0.5, Progress = 0}
    }

    local DisplayUtils = {
        createGradient = function(parent)
            local gradient = parent:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")
            gradient.Parent = parent
            return gradient
        end,
        updateColor = function(gradient, config)
            local time = tick() * config.Animation.Speed
            local interp = (math.sin(time) + 1) / 2
            local h = config.ColorSettings.Gradient1.Hue + (config.ColorSettings.Gradient2.Hue - config.ColorSettings.Gradient1.Hue) * interp
            local s = config.ColorSettings.Gradient1.Saturation + (config.ColorSettings.Gradient2.Saturation - config.ColorSettings.Gradient1.Saturation) * interp
            local b = config.ColorSettings.Gradient1.Brightness + (config.ColorSettings.Gradient2.Brightness - config.ColorSettings.Gradient1.Brightness) * interp
            gradient.Color = ColorSequence.new(Color3.fromHSV(h, s, b))
        end
    }

	local CoreConnection

    local function enhanceQueueDisplay()
		pcall(function() 
			CoreConnection:Disconnect()
		end)
        local success, err = pcall(function()
            if not lplr.PlayerGui:FindFirstChild('QueueApp') then return end
            
            for attempt = 1, 3 do
                if QueueDisplayConfig.GradientControl.Enabled then
                    local queueFrame = lplr.PlayerGui.QueueApp['1']
                    queueFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    
                    local gradient = DisplayUtils.createGradient(queueFrame)
                    gradient.Rotation = 180
                    
                    local displayInterface = {
                        module = vape.watermark,
                        gradient = gradient,
                        GetEnabled = function()
                            return QueueDisplayConfig.ActiveState
                        end,
                        SetGradientEnabled = function(state)
                            QueueDisplayConfig.GradientControl.Enabled = state
                            gradient.Enabled = state
                        end
                    }
                    --vape.whitelistedlines["enhancedQueueDisplay"] = displayInterface
                    CoreConnection = game:GetService("RunService").RenderStepped:Connect(function()
                        if QueueDisplayConfig.ActiveState and QueueDisplayConfig.GradientControl.Enabled then
                            DisplayUtils.updateColor(gradient, QueueDisplayConfig)
                        end
                    end)
                end
                task.wait(0.1)
            end
        end)
        
        if not success then
            warn("Queue display enhancement failed: " .. tostring(err))
        end
    end

    local QueueDisplayEnhancer
    QueueDisplayEnhancer = vape.Categories.Utility:CreateModule({
        Name = 'QueueCardMods',
        Tooltip = 'Enhances the QueueApp display with dynamic gradients',
        Function = function(enabled)
            QueueDisplayConfig.ActiveState = enabled
            if enabled then
                enhanceQueueDisplay()
                QueueDisplayEnhancer:Clean(lplr.PlayerGui.ChildAdded:Connect(enhanceQueueDisplay))
			else
				pcall(function() 
					CoreConnection:Disconnect()
				end)
			end
        end
    })

   	QueueDisplayEnhancer:CreateSlider({
        Name = "Animation Speed",
        Function = function(speed)
            QueueDisplayConfig.Animation.Speed = math.clamp(speed, 0.1, 5)
        end,
        Min = 1,
        Max = 5,
        Default = 5
    })

    QueueDisplayEnhancer:CreateColorSlider({
        Name = "Color 1",
        Function = function(h, s, v)
            QueueDisplayConfig.ColorSettings.Gradient1 = {Hue = h, Saturation = s, Brightness = v}
        end
    })

    QueueDisplayEnhancer:CreateColorSlider({
        Name = "Color 2",
        Function = function(h, s, v)
            QueueDisplayConfig.ColorSettings.Gradient2 = {Hue = h, Saturation = s, Brightness = v}
        end
    })
end)

--[[run(function()
	task.spawn(function()
		pcall(function()
			GuiLibrary.RemoveObject("SetEmote")
			local SetEmote = {}
			local SetEmoteList = {Value = ''}
			local oldemote
			local emo2 = {}
			local credits
			SetEmote = vape.Categories.Utility:CreateModule({
				Name = 'SetEmote',
				Tooltip = "Sets your emote",
				Function = function(calling)
					if calling then
						oldemote = lplr:GetAttribute('EmoteTypeSlot1')
						lplr:SetAttribute('EmoteTypeSlot1', emo2[SetEmoteList.Value])
					else
						if oldemote then 
							lplr:GetAttribute('EmoteTypeSlot1', oldemote)
							oldemote = nil 
						end
					end
					SetEmote:Clean(lplr.PlayerGui.ChildAdded:Connect(function(v)
						local anim
						if tostring(v) == 'RoactTree' and isAlive(lplr, true) and not emoting then 
							v:WaitForChild('1'):WaitForChild('1')
							if not v['1']:IsA('ImageButton') then 
								return 
							end
							v['1'].Visible = false
							emoting = true
							bedwars.Client:Get('Emote'):CallServer({emoteType = lplr:GetAttribute('EmoteTypeSlot1')})
							local oldpos = lplr.Character:WaitForChild("HumanoidRootPart").Position 
							if tostring(lplr:GetAttribute('EmoteTypeSlot1')):lower():find('nightmare') then 
								anim = Instance.new('Animation')
								anim.AnimationId = 'rbxassetid://9191822700'
								anim = lplr.Character:WaitForChild("Humanoid").Animator:LoadAnimation(anim)
								task.spawn(function()
									repeat 
										anim:Play()
										anim.Completed:Wait()
									until not anim
								end)
							end
							repeat task.wait() until ((lplr.Character:WaitForChild("HumanoidRootPart").Position - oldpos).Magnitude >= 0.3 or not isAlive(lplr, true))
							pcall(function() anim:Stop() end)
							anim = nil
							emoting = false
							bedwars.Client:Get('EmoteCancelled'):CallServer({emoteType = lplr:GetAttribute('EmoteTypeSlot1')})
						end
					end))
				end
			})
			local emo = {}
			for i,v in pairs(bedwars.EmoteMeta) do 
				table.insert(emo, v.name)
				emo2[v.name] = i
			end
			table.sort(emo, function(a, b) return a:lower() < b:lower() end)
			SetEmoteList = SetEmote:CreateDropdown({
				Name = 'Emote',
				List = emo,
				Function = function(emote)
					if SetEmote.Enabled then 
						lplr:SetAttribute('EmoteTypeSlot1', emo2[emote])
					end
				end
			})
		end)
	end)
end)--]]

--[[if shared.TestingMode then
	pcall(function()
		run(function()
			local SessionInfo = {Enabled = false}
			local BackgroundColor = {Hue = 0, Sat = 0, Value = 0}
			local lplr = game:GetService("Players").LocalPlayer
			local plrgui = lplr.PlayerGui
			local deathCount = 0
			local regionDisplayText = plrgui:WaitForChild("ServerRegionDisplay").ServerRegionText.Text
			local playerDead = false 
			local debounce = false
		
			SessionInfo = vape.Categories.Utility:CreateModule({
				Name = "SessionInfo Custom",
				Tooltip = "Customizable session info.",
				Function = function(call)
					if call then 
						local function extractValue(text, pattern)
							return text:match(pattern)
						end

						local components = {
							Gui = Instance.new("ScreenGui"),
							Background = Instance.new("Frame"),
							UICorner = Instance.new("UICorner"),
							SessionInfoLabel = Instance.new("TextLabel"),
							TimePlayed = Instance.new("TextLabel"),
							Kills = Instance.new("TextLabel"),
							Deaths = Instance.new("TextLabel"),
							Region = Instance.new("TextLabel"),
							DropShadowHolder = Instance.new("Frame"),
							DropShadow = Instance.new("ImageLabel")
						}
						
						local function setupLabel(label, text, positionY)
							label.Font = Enum.Font.SourceSans
							label.Text = text
							label.TextColor3 = Color3.fromRGB(255, 255, 255)
							label.TextScaled = true
							label.TextWrapped = true
							label.TextXAlignment = Enum.TextXAlignment.Left
							label.BackgroundTransparency = 1
							label.Position = UDim2.new(0.04, 0, positionY, 0)
							label.Size = UDim2.new(1, 0, 0.17, 0)
							label.Parent = components.Background
						end
		
						components.Gui.Name = "SessionInfo"
						components.Gui.Parent = plrgui
						components.Gui.ResetOnSpawn = false
		
						components.Background.Name = "Background"
						components.Background.Parent = components.Gui
						components.Background.BackgroundColor3 = Color3.fromHSV(0, 0, 0)
						components.Background.BackgroundTransparency = 0.8
						components.Background.Size = UDim2.new(0.13, 0, 0.16, 0)
						components.Background.Position = UDim2.new(0.01, 0, 0.38, 0)
						components.UICorner.Parent = components.Background
		
						setupLabel(components.SessionInfoLabel, "Session Info", 0)
						setupLabel(components.TimePlayed, "Time Played: 00:00", 0.28)
						setupLabel(components.Kills, "Kills: 0", 0.45)
						setupLabel(components.Deaths, "Deaths: 0", 0.62)
						setupLabel(components.Region, "Region: " .. extractValue(regionDisplayText, "REGION:%s*([^<]+)"), 0.79)
		
						components.DropShadowHolder.Parent = components.Background
						components.DropShadowHolder.BackgroundTransparency = 1
						components.DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
						components.DropShadow.Name = "DropShadow"
						components.DropShadow.Parent = components.DropShadowHolder
						components.DropShadow.Image = "rbxassetid://6014261993"
						components.DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
						components.DropShadow.ImageTransparency = 0.5
						components.DropShadow.ScaleType = Enum.ScaleType.Slice
						components.DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
						components.DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
						components.DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
						components.DropShadow.Size = UDim2.new(1, 47, 1, 47)
		
						local function updateTimer()
							while enabled do
								wait()
								local timerText = plrgui.TopBarAppGui.TopBarApp["2"]["5"].Text
								components.TimePlayed.Text = "Time Played: " .. extractValue(timerText, "<b>(%d+:%d+)</b>")
							end
						end
		
						local function updateKills()
							while enabled do
								wait()
								local killsText = plrgui.TopBarAppGui.TopBarApp["3"]["5"].Text
								components.Kills.Text = "Kills: " .. extractValue(killsText, "<b>(%d+)</b>")
							end
						end
		
						local function trackDeaths()
							lplr.Character:WaitForChild("Humanoid").HealthChanged:Connect(function(health)
								if debounce then return end
								debounce = true
								if health <= 0 and not playerDead then
									deathCount += 1
									components.Deaths.Text = "Deaths: " .. deathCount
									playerDead = true
								elseif health > 0 then
									playerDead = false
								end
								debounce = false
							end)
						end
						
						task.spawn(updateTimer)
						task.spawn(updateKills)
						task.spawn(trackDeaths)
						
					else
						if plrgui:FindFirstChild("SessionInfo") then 
							plrgui.SessionInfo:Destroy()
						else 
							errorNotification("SessionInfo", "Session Info not found, please DM erchodev#0 about this.", 3)
						end
					end
				end
			})
		
			BackgroundColor = SessionInfo:CreateColorSlider({
				Name = "Background Color",
				Function = function(h, s, v) 
					local sessionInfo = game.Players.LocalPlayer.PlayerGui:FindFirstChild("SessionInfo")
					if sessionInfo then 
						sessionInfo.Background.BackgroundColor3 = Color3.fromHSV(h, s, v)
					else
						print("No SessionInfo found.")
					end
				end
			})
		end)		
	end)
else
	run(function()
		local lplr = game.Players.LocalPlayer
		local plrgui = lplr.PlayerGui
		local deathscounter = 0
		local regiondisplay = plrgui:WaitForChild("ServerRegionDisplay").ServerRegionText.Text
		local playerded = false 
		local debouncegaming = false
		local SessionInfo = vape.Categories.Utility:CreateModule({
			Name = "SessionInfo Custom",
			Tooltip = "Customizable session info.",
			Function = function(callback)
				if callback then 
					local function extractnumber(text)
						local number = text:match("<b>(%d+)</b>")
						return tonumber(number)
					end
					local function extracttimer(text)
						local minutes, seconds = text:match("<b>(%d+:%d+)</b>")
						return minutes
					end
					local function extractregion(text)
						local region = text:match("REGION:%s*([^<]+)")
						return region
					end
					
					local Converted = {
						["_SessionInfo"] = Instance.new("ScreenGui");
						["_Background"] = Instance.new("Frame");
						["_UICorner"] = Instance.new("UICorner");
						["_SessionInfoLabel"] = Instance.new("TextLabel");
						["_TimePlayed"] = Instance.new("TextLabel");
						["_Kills"] = Instance.new("TextLabel");
						["_Deaths"] = Instance.new("TextLabel");
						["_Region"] = Instance.new("TextLabel");
						["_DropShadowHolder"] = Instance.new("Frame");
						["_DropShadow"] = Instance.new("ImageLabel");
					}
					
					Converted["_SessionInfo"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
					Converted["_SessionInfo"].Name = "SessionInfo"
					Converted["_SessionInfo"].Parent = plrgui
					Converted["_SessionInfo"].ResetOnSpawn = false
					
					Converted["_Background"].BackgroundColor3 = Color3.fromHSV(0, 0, 0)
					Converted["_Background"].BackgroundTransparency = 0.800000011920929
					Converted["_Background"].BorderColor3 = Color3.fromRGB(0, 0, 0)
					Converted["_Background"].BorderSizePixel = 0
					Converted["_Background"].Position = UDim2.new(0.0116598075, 0, 0.375, 0)
					Converted["_Background"].Size = UDim2.new(0.128257886, 0, 0.16310975, 0)
					Converted["_Background"].Name = "Background"
					Converted["_Background"].Parent = Converted["_SessionInfo"]
					
					Converted["_UICorner"].Parent = Converted["_Background"]
					
					Converted["_SessionInfoLabel"].Font = Enum.Font.SourceSansBold
					Converted["_SessionInfoLabel"].Text = "Session Info"
					Converted["_SessionInfoLabel"].TextColor3 = Color3.fromRGB(255, 255, 255)
					Converted["_SessionInfoLabel"].TextScaled = true
					Converted["_SessionInfoLabel"].TextSize = 14
					Converted["_SessionInfoLabel"].TextWrapped = true
					Converted["_SessionInfoLabel"].TextXAlignment = Enum.TextXAlignment.Left
					Converted["_SessionInfoLabel"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Converted["_SessionInfoLabel"].BackgroundTransparency = 1
					Converted["_SessionInfoLabel"].BorderColor3 = Color3.fromRGB(0, 0, 0)
					Converted["_SessionInfoLabel"].BorderSizePixel = 0
					Converted["_SessionInfoLabel"].Position = UDim2.new(0.0374331549, 0, 0, 0)
					Converted["_SessionInfoLabel"].Size = UDim2.new(1, 0, 0.242990658, 0)
					Converted["_SessionInfoLabel"].Name = "SessionInfoLabel"
					Converted["_SessionInfoLabel"].Parent = Converted["_Background"]
					
					Converted["_TimePlayed"].Font = Enum.Font.SourceSans
					Converted["_TimePlayed"].Text = "Time Played: 00:00" 
					Converted["_TimePlayed"].TextColor3 = Color3.fromRGB(255, 255, 255)
					Converted["_TimePlayed"].TextScaled = true
					Converted["_TimePlayed"].TextSize = 14
					Converted["_TimePlayed"].TextWrapped = true
					Converted["_TimePlayed"].TextXAlignment = Enum.TextXAlignment.Left
					Converted["_TimePlayed"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Converted["_TimePlayed"].BackgroundTransparency = 1
					Converted["_TimePlayed"].BorderColor3 = Color3.fromRGB(0, 0, 0)
					Converted["_TimePlayed"].BorderSizePixel = 0
					Converted["_TimePlayed"].Position = UDim2.new(0.0374331549, 0, 0.275288522, 0)
					Converted["_TimePlayed"].Size = UDim2.new(1, 0, 0.168224305, 0)
					Converted["_TimePlayed"].Name = "TimePlayed"
					Converted["_TimePlayed"].Parent = Converted["_Background"]
					
					Converted["_Kills"].Font = Enum.Font.SourceSans
					Converted["_Kills"].Text = "Kills: 0" 
					Converted["_Kills"].TextColor3 = Color3.fromRGB(255, 255, 255)
					Converted["_Kills"].TextScaled = true
					Converted["_Kills"].TextSize = 14
					Converted["_Kills"].TextWrapped = true
					Converted["_Kills"].TextXAlignment = Enum.TextXAlignment.Left
					Converted["_Kills"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Converted["_Kills"].BackgroundTransparency = 1
					Converted["_Kills"].BorderColor3 = Color3.fromRGB(0, 0, 0)
					Converted["_Kills"].BorderSizePixel = 0
					Converted["_Kills"].Position = UDim2.new(0.0374331549, 0, 0.445024729, 0)
					Converted["_Kills"].Size = UDim2.new(1, 0, 0.168224305, 0)
					Converted["_Kills"].Name = "Kills"
					Converted["_Kills"].Parent = Converted["_Background"]
					
					Converted["_Deaths"].Font = Enum.Font.SourceSans
					Converted["_Deaths"].Text = "Deaths: 0"
					Converted["_Deaths"].TextColor3 = Color3.fromRGB(255, 255, 255)
					Converted["_Deaths"].TextScaled = true
					Converted["_Deaths"].TextSize = 14
					Converted["_Deaths"].TextWrapped = true
					Converted["_Deaths"].TextXAlignment = Enum.TextXAlignment.Left
					Converted["_Deaths"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Converted["_Deaths"].BackgroundTransparency = 1
					Converted["_Deaths"].BorderColor3 = Color3.fromRGB(0, 0, 0)
					Converted["_Deaths"].BorderSizePixel = 0
					Converted["_Deaths"].Position = UDim2.new(0.0374331549, 0, 0.614760935, 0)
					Converted["_Deaths"].Size = UDim2.new(1, 0, 0.168224305, 0)
					Converted["_Deaths"].Name = "Deaths"
					Converted["_Deaths"].Parent = Converted["_Background"]
					
					Converted["_Region"].Font = Enum.Font.SourceSans
					Converted["_Region"].Text = "Region: "..extractregion(regiondisplay)
					Converted["_Region"].TextColor3 = Color3.fromRGB(255, 255, 255)
					Converted["_Region"].TextScaled = true
					Converted["_Region"].TextSize = 14
					Converted["_Region"].TextWrapped = true
					Converted["_Region"].TextXAlignment = Enum.TextXAlignment.Left
					Converted["_Region"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Converted["_Region"].BackgroundTransparency = 1
					Converted["_Region"].BorderColor3 = Color3.fromRGB(0, 0, 0)
					Converted["_Region"].BorderSizePixel = 0
					Converted["_Region"].Position = UDim2.new(0.0374331549, 0, 0.78298521, 0)
					Converted["_Region"].Size = UDim2.new(1, 0, 0.168224305, 0)
					Converted["_Region"].Name = "Region"
					Converted["_Region"].Parent = Converted["_Background"]
					
					Converted["_DropShadowHolder"].BackgroundTransparency = 1
					Converted["_DropShadowHolder"].BorderSizePixel = 0
					Converted["_DropShadowHolder"].Size = UDim2.new(1, 0, 1, 0)
					Converted["_DropShadowHolder"].ZIndex = 0
					Converted["_DropShadowHolder"].Name = "DropShadowHolder"
					Converted["_DropShadowHolder"].Parent = Converted["_Background"]
					
					Converted["_DropShadow"].Image = "rbxassetid://6014261993"
					Converted["_DropShadow"].ImageColor3 = Color3.fromRGB(0, 0, 0)
					Converted["_DropShadow"].ImageTransparency = 0.5
					Converted["_DropShadow"].ScaleType = Enum.ScaleType.Slice
					Converted["_DropShadow"].SliceCenter = Rect.new(49, 49, 450, 450)
					Converted["_DropShadow"].AnchorPoint = Vector2.new(0.5, 0.5)
					Converted["_DropShadow"].BackgroundTransparency = 1
					Converted["_DropShadow"].BorderSizePixel = 0
					Converted["_DropShadow"].Position = UDim2.new(0.5, 0, 0.5, 0)
					Converted["_DropShadow"].Size = UDim2.new(1, 47, 1, 47)
					Converted["_DropShadow"].ZIndex = 0
					Converted["_DropShadow"].Name = "DropShadow"
					Converted["_DropShadow"].Parent = Converted["_DropShadowHolder"]
					
					local function timerupdate()
						while true do
							wait()
							local timercounter = plrgui.TopBarAppGui.TopBarApp["2"]["5"].Text
							local timergaming = extracttimer(timercounter)
							Converted["_TimePlayed"].Text = "Time Played: " .. timergaming
						end
					end
					
					local function killsupdate()
						while true do
							wait()
							local killscounter = plrgui.TopBarAppGui.TopBarApp["3"]["5"].Text
							local kills = extractnumber(killscounter)
							Converted["_Kills"].Text = "Kills: " .. kills
						end
					end
					
					local function deathcounterfunc()
						local humanoid = lplr.Character:WaitForChild("Humanoid")
						humanoid.HealthChanged:Connect(function(health)
							if not debouncegaming then
								debouncegaming = true
								if health <= 0 and not playerded then
									deathscounter = deathscounter + 1
									Converted["_Deaths"].Text = "Deaths: " .. deathscounter
									playerded = true
									debouncegaming = false
									wait(1) 
								elseif health > 0 and playerded then
									playerded = false
								end
							end
						end)
					end
					
					task.spawn(timerupdate)
					task.spawn(killsupdate)
					task.spawn(deathcounterfunc)	
				else 
					local plrgui = game.Players.LocalPlayer.PlayerGui
					if plrgui:FindFirstChild("SessionInfo") then 
						local sessioninfo = plrgui.SessionInfo
						sessioninfo:Destroy()
					else 
						ErrorWarning("SessionInfo", "Session Info not found, please dm salad about this.", 30)
					end
				end
			end
		})
		SessioninfoBgColor = SessionInfo:CreateColorSlider({
			Name = "Background Color",
			Function = function(h, s, v) 
				if game.Players.LocalPlayer.PlayerGui:FindFirstChild("SessionInfo") then 
					game.Players.LocalPlayer.PlayerGui.SessionInfo.Background.BackgroundColor3 = Color3.fromHSV(h, s, v)
				else
					print("no session info found lol")
				end
			end
		})
	end)
end--]]

run(function()
    local tppos2 = nil
    local TweenSpeed = 0.7
    local HeightOffset = 5
    local BedTP = {}

    local function teleportWithTween(char, destination)
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            destination = destination + Vector3.new(0, HeightOffset, 0)
            local currentPosition = root.Position
            if (destination - currentPosition).Magnitude > 0.5 then
                local tweenInfo = TweenInfo.new(TweenSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                local goal = {CFrame = CFrame.new(destination)}
                local tween = TweenService:Create(root, tweenInfo, goal)
                tween:Play()
                tween.Completed:Wait()
				BedTP:Toggle(false)
            end
        end
    end

    local function killPlayer(player)
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
        end
    end

    local function getEnemyBed(range)
        range = range or math.huge
        local bed = nil
        local player = lplr

        if not isAlive(player, true) then 
            return nil 
        end

        local localPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or Vector3.zero
        local playerTeam = player:GetAttribute('Team')
        local beds = collectionService:GetTagged('bed')

        for _, v in ipairs(beds) do 
            if v:GetAttribute('PlacedByUserId') == 0 then
                local bedTeam = v:GetAttribute('id'):sub(1, 1)
                if bedTeam ~= playerTeam then 
                    local bedPosition = v.Position
                    local bedDistance = (localPos - bedPosition).Magnitude
                    if bedDistance < range then 
                        bed = v
                        range = bedDistance
                    end
                end
            end
        end

        if not bed then 
            warningNotification("BedTP", 'No enemy beds found. Total beds: '..#beds, 5)
        else
            --warningNotification("BedTP", 'Teleporting to bed at position: '..tostring(bed.Position), 3)
			warningNotification("BedTP", 'Teleporting to bed at position: '..tostring(bed.Position), 3)
        end

        return bed
    end

    BedTP = vape.Categories.Blatant:CreateModule({
        ["Name"] = "BedTP",
        ["Function"] = function(callback)
            if callback then
				task.spawn(function()
					repeat task.wait() until vape.Modules.Invisibility
					repeat task.wait() until vape.Modules.GamingChair
					if vape.Modules.Invisibility.Enabled and vape.Modules.GamingChair.Enabled then
						errorNotification("BedTP", "Please turn off the Invisibility and GamingChair module!", 3)
						BedTP:Toggle()
						return
					end
					if vape.Modules.Invisibility.Enabled then
						errorNotification("BedTP", "Please turn off the Invisibility module!", 3)
						BedTP:Toggle()
						return
					end
					if vape.Modules.GamingChair.Enabled then
						errorNotification("BedTP", "Please turn off the GamingChair module!", 3)
						BedTP:Toggle()
						return
					end
					BedTP:Clean(lplr.CharacterAdded:Connect(function(char)
						if tppos2 then 
							task.spawn(function()
								local root = char:WaitForChild("HumanoidRootPart", 9000000000)
								if root and tppos2 then 
									teleportWithTween(char, tppos2)
									tppos2 = nil
								end
							end)
						end
					end))
					local bed = getEnemyBed()
					if bed then 
						tppos2 = bed.Position
						killPlayer(lplr)
					else
						BedTP:Toggle(false)
					end
				end)
            end
        end
    })
end)

run(function()
	local TweenService = game:GetService("TweenService")
	local playersService = game:GetService("Players")
	local lplr = playersService.LocalPlayer
	
	local tppos2
	local deathtpmod = {["Enabled"] = false}
	local TweenSpeed = 0.7
	local HeightOffset = 5

	local function teleportWithTween(char, destination)
		local root = char:FindFirstChild("HumanoidRootPart")
		if root then
			destination = destination + Vector3.new(0, HeightOffset, 0)
			local currentPosition = root.Position
			if (destination - currentPosition).Magnitude > 0.5 then
				local tweenInfo = TweenInfo.new(TweenSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
				local goal = {CFrame = CFrame.new(destination)}
				local tween = TweenService:Create(root, tweenInfo, goal)
				tween:Play()
				tween.Completed:Wait()
			end
		end
	end

	local function killPlayer(player)
		local character = player.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.Health = 0
			end
		end
	end

	local function onCharacterAdded(char)
		if tppos2 then 
			task.spawn(function()
				local root = char:WaitForChild("HumanoidRootPart", 9000000000)
				if root and tppos2 then 
					teleportWithTween(char, tppos2)
					tppos2 = nil
				end
			end)
		end
	end

	vapeConnections[#vapeConnections + 1] = lplr.CharacterAdded:Connect(onCharacterAdded)

	local function setTeleportPosition()
		local UserInputService = game:GetService("UserInputService")
		local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

		if isMobile then
			warningNotification("DeathTP", "Please tap on the screen to set TP position.", 3)
			local connection
			connection = UserInputService.TouchTapInWorld:Connect(function(inputPosition, processedByUI)
				if not processedByUI then
					local mousepos = lplr:GetMouse().UnitRay
					local rayparams = RaycastParams.new()
					rayparams.FilterDescendantsInstances = {game.Workspace.Map, game.Workspace:FindFirstChild("SpectatorPlatform")}
					rayparams.FilterType = Enum.RaycastFilterType.Whitelist
					local ray = game.Workspace:Raycast(mousepos.Origin, mousepos.Direction * 10000, rayparams)
					if ray then 
						tppos2 = ray.Position 
						warningNotification("DeathTP", "Set TP Position. Resetting to teleport...", 3)
						killPlayer(lplr)
					end
					connection:Disconnect()
					deathtpmod["ToggleButton"](false)
				end
			end)
		else
			local mousepos = lplr:GetMouse().UnitRay
			local rayparams = RaycastParams.new()
			rayparams.FilterDescendantsInstances = {game.Workspace.Map, game.Workspace:FindFirstChild("SpectatorPlatform")}
			rayparams.FilterType = Enum.RaycastFilterType.Whitelist
			local ray = game.Workspace:Raycast(mousepos.Origin, mousepos.Direction * 10000, rayparams)
			if ray then 
				tppos2 = ray.Position 
				warningNotification("DeathTP", "Set TP Position. Resetting to teleport...", 3)
				killPlayer(lplr)
			end
			deathtpmod["ToggleButton"](false)
		end
	end

	deathtpmod = vape.Categories.Blatant:CreateModule({
		["Name"] = "DeathTP",
		["Function"] = function(calling)
			if calling then
				task.spawn(function()
					repeat task.wait() until vape.Modules.Invisibility
					repeat task.wait() until vape.Modules.GamingChair
					if vape.Modules.Invisibility.Enabled and vape.Modules.GamingChair.Enabled then
						errorNotification("DeathTP", "Please turn off the Invisibility and GamingChair module!", 3)
						deathtpmod:Toggle()
						return
					end
					if vape.Modules.Invisibility.Enabled then
						errorNotification("DeathTP", "Please turn off the Invisibility module!", 3)
						deathtpmod:Toggle()
						return
					end
					if vape.Modules.GamingChair.Enabled then
						errorNotification("DeathTP", "Please turn off the GamingChair module!", 3)
						deathtpmod:Toggle()
						return
					end
					local canRespawn = function() end
					canRespawn = function()
						local success, response = pcall(function() 
							return lplr.leaderstats.Bed.Value == '✅' 
						end)
						return success and response 
					end
					if not canRespawn() then 
						warningNotification("DeathTP", "Unable to use DeathTP without bed!", 5)
						deathtpmod:Toggle()
					else
						setTeleportPosition()
					end
				end)
			end
		end
	})
end)

local function GetTarget()
	return entitylib.EntityPosition({
		Part = 'RootPart',
		Range = 1000,
		Players = true,
		NPCs = false,
		Wallcheck = false
	})
end

run(function()
	local PlayerTP = {}
	local PlayerTPTeleport = {Value = 'Respawn'}
	local PlayerTPSort = {Value = 'Distance'}
	local PlayerTPMethod = {Value = 'Linear'}
	local PlayerTPAutoSpeed = {}
	local PlayerTPSpeed = {Value = 200}
	local PlayerTPTarget = {Value = ''}
	local playertween
	local oldmovefunc
	local bypassmethods = {
		Respawn = function() 
			if isEnabled('InfiniteFly') then 
				return 
			end
			if not canRespawn() then 
				return 
			end
			for i = 1, 30 do 
				if isAlive(lplr, true) and lplr.Character:WaitForChild("Humanoid"):GetState() ~= Enum.HumanoidStateType.Dead then
					lplr.Character:WaitForChild("Humanoid"):TakeDamage(lplr.Character:WaitForChild("Humanoid").Health)
					lplr.Character:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead)
				end
			end
			lplr.CharacterAdded:Wait()
			repeat task.wait() until isAlive(lplr, true) 
			task.wait(0.1)
			local target = GetTarget(nil, PlayerTPSort.Value == 'Health', true)
			if target.RootPart == nil or not PlayerTP.Enabled then 
				return
			end
			local localposition = lplr.Character:WaitForChild("HumanoidRootPart").Position
			local tweenspeed = (PlayerTPAutoSpeed.Enabled and ((target.RootPart.Position - localposition).Magnitude / 470) + 0.001 * 2 or (PlayerTPSpeed.Value / 1000) + 0.1)
			local tweenstyle = (PlayerTPAutoSpeed.Enabled and Enum.EasingStyle.Linear or Enum.EasingStyle[PlayerTPMethod.Value])
			playertween = tweenService:Create(lplr.Character:WaitForChild("HumanoidRootPart"), TweenInfo.new(tweenspeed, tweenstyle), {CFrame = target.RootPart.CFrame}) 
			playertween:Play() 
			playertween.Completed:Wait()
		end,
		Instant = function() 
			local target = GetTarget(nil, PlayerTPSort.Value == 'Health', true)
			if target.RootPart == nil then 
				return PlayerTP:Toggle()
			end
			lplr.Character:WaitForChild("HumanoidRootPart").CFrame = (target.RootPart.CFrame + Vector3.new(0, 5, 0)) 
			PlayerTP:Toggle()
		end,
		Recall = function()
			if not isAlive(lplr, true) or lplr.Character:WaitForChild("Humanoid").FloorMaterial == Enum.Material.Air then 
				errorNotification('PlayerTP', 'Recall ability not available.', 7)
				return 
			end
			if not bedwars.AbilityController:canUseAbility('recall') then 
				errorNotification('PlayerTP', 'Recall ability not available.', 7)
				return
			end
			pcall(function()
				oldmovefunc = require(lplr.PlayerScripts.PlayerModule).controls.moveFunction 
				require(lplr.PlayerScripts.PlayerModule).controls.moveFunction = function() end
			end)
			bedwars.AbilityController:useAbility('recall')
			local teleported
			PlayerTP:Clean(lplr:GetAttributeChangedSignal('LastTeleported'):Connect(function() teleported = true end))
			repeat task.wait() until teleported or not PlayerTP.Enabled or not isAlive(lplr, true) 
			task.wait()
			local target = GetTarget(nil, PlayerTPSort.Value == 'Health', true)
			if target.RootPart == nil or not isAlive(lplr, true) or not PlayerTP.Enabled then 
				return
			end
			local localposition = lplr.Character:WaitForChild("HumanoidRootPart").Position
			local tweenspeed = (PlayerTPAutoSpeed.Enabled and ((target.RootPart.Position - localposition).Magnitude / 1000) + 0.001 or (PlayerTPSpeed.Value / 1000) + 0.1)
			local tweenstyle = (PlayerTPAutoSpeed.Enabled and Enum.EasingStyle.Linear or Enum.EasingStyle[PlayerTPMethod.Value])
			playertween = tweenService:Create(lplr.Character:WaitForChild("HumanoidRootPart"), TweenInfo.new(tweenspeed, tweenstyle), {CFrame = target.RootPart.CFrame}) 
			playertween:Play() 
			playertween.Completed:Wait()
		end
	}
	PlayerTP = vape.Categories.Blatant:CreateModule({
		Name = 'PlayerTP',
		Tooltip = 'Tweens you to a nearby target.',
		Function = function(calling)
			if calling then 
				task.spawn(function()
					repeat task.wait() until vape.Modules.Invisibility
					repeat task.wait() until vape.Modules.GamingChair
					if vape.Modules.Invisibility.Enabled and vape.Modules.GamingChair.Enabled then
						errorNotification("PlayerTP", "Please turn off the Invisibility and GamingChair module!", 3)
						PlayerTP:Toggle()
						return
					end
					if vape.Modules.Invisibility.Enabled then
						errorNotification("PlayerTP", "Please turn off the Invisibility module!", 3)
						PlayerTP:Toggle()
						return
					end
					if vape.Modules.GamingChair.Enabled then
						errorNotification("PlayerTP", "Please turn off the GamingChair module!", 3)
						PlayerTP:Toggle()
						return
					end
					if GetTarget(nil, PlayerTPSort.Value == 'Health', true) and GetTarget(nil, PlayerTPSort.Value == 'Health', true).RootPart and shared.VapeFullyLoaded then 
						bypassmethods[isAlive() and PlayerTPTeleport.Value or 'Respawn']() 
					else
						InfoNotification("PlayerTP", "No player/s found!", 3)
					end
					if PlayerTP.Enabled then 
						PlayerTP:Toggle()
					end
				end)
			else
				pcall(function() playertween:Disconnect() end)
				if oldmovefunc then 
					pcall(function() require(lplr.PlayerScripts.PlayerModule).controls.moveFunction = oldmovefunc end)
				end
				oldmovefunc = nil
			end
		end
	})
	PlayerTPTeleport = PlayerTP:CreateDropdown({
		Name = 'Teleport Method',
		List = {'Respawn', 'Recall'},
		Function = function() end
	})
	PlayerTPAutoSpeed = PlayerTP:CreateToggle({
		Name = 'Auto Speed',
		Tooltip = 'Automatically uses a "good" tween speed.',
		Default = true,
		Function = function(calling) 
			if calling then 
				pcall(function() PlayerTPSpeed.Object.Visible = false end) 
			else 
				pcall(function() PlayerTPSpeed.Object.Visible = true end) 
			end
		end
	})
	PlayerTPSpeed = PlayerTP:CreateSlider({
		Name = 'Tween Speed',
		Min = 20, 
		Max = 350,
		Default = 200,
		Function = function() end
	})
	PlayerTPMethod = PlayerTP:CreateDropdown({
		Name = 'Teleport Method',
		List = GetEnumItems('EasingStyle'),
		Function = function() end
	})
	PlayerTPSpeed.Object.Visible = false
end)

local GodMode = {Enabled = false}
run(function()
    local antiDeath = {}
    local antiDeathConfig = {
        Mode = {},
        BoostMode = {},
        SongId = {},
        Health = {},
        Velocity = {},
        CFrame = {},
        TweenPower = {},
        TweenDuration = {},
        SkyPosition = {},
        AutoDisable = {},
        Sound = {},
        Notify = {}
    }
    local antiDeathState = {}
    local handlers = {}

    function handlers.new()
        local self = {
			godmode = false,
            boost = false,
            inf = false,
            notify = false,
            id = false,
            hrp = entityLibrary.character.HumanoidRootPart,
            hasNotified = false
        }
        setmetatable(self, { __index = handlers })
        return self
    end

    function handlers:enable()
		antiDeath:Clean(runService.Heartbeat:Connect(function()
			if not isAlive(lplr, true) then
                handlers:disable()
                return
            end

            if getHealth() <= antiDeathConfig.Health.Value and getHealth() > 0 then
                if not handlers.boost then
                    handlers:activateMode()
                    if not handlers.hasNotified and antiDeathConfig.Notify.Enabled then
                        handlers:sendNotification()
                    end
                    handlers:playNotificationSound()
                    handlers.boost = true
                end
            else
                handlers:resetMode()
				pcall(function()
					handlers.hrp = entityLibrary.character.HumanoidRootPart
					handlers.hrp.Anchored = false
				end)
                handlers.boost = false

                if handlers.hasNotified then
                    handlers.hasNotified = false
                end
            end
		end))
    end

    function handlers:disable()
        --RunLoops:UnbindFromHeartbeat('antiDeath')
    end

    function handlers:activateMode()
        local modeActions = {
            Infinite = function() self:enableInfiniteMode() end,
            Boost = function() self:applyBoost() end,
            Sky = function() self:moveToSky() end,
			AntiHit = function() self:enableAntiHitMode() end
        }
		if antiDeathConfig.Mode.Value == "Infinite" then return end
        modeActions[antiDeathConfig.Mode.Value]()
    end

	function handlers:enableAntiHitMode()
		if not GodMode.Enabled then
			GodMode:Toggle(false)
			self.godmode = true
		end
	end

    function handlers:enableInfiniteMode()
        if not vape.Modules.InfiniteFly.Enabled then
            vape.Modules.InfiniteFly:Toggle(true)
            self.inf = true
        end
    end

    function handlers:applyBoost()
        local boostActions = {
            Velocity = function() self.hrp.Velocity += Vector3.new(0, antiDeathConfig.Velocity.Value, 0) end,
            CFrame = function() self.hrp.CFrame += Vector3.new(0, antiDeathConfig.CFrame.Value, 0) end,
            Tween = function()
                tweenService:Create(self.hrp, twinfo(antiDeathConfig.TweenDuration.Value / 10), {
                    CFrame = self.hrp.CFrame + Vector3.new(0, antiDeathConfig.TweenPower.Value, 0)
                }):Play()
            end
        }
        boostActions[antiDeathConfig.BoostMode.Value]()
    end

    function handlers:moveToSky()
        self.hrp.CFrame += Vector3.new(0, antiDeathConfig.SkyPosition.Value, 0)
        self.hrp.Anchored = true
    end

    function handlers:sendNotification()
        InfoNotification('AntiDeath', 'Prevented death. Health is lower than ' .. antiDeathConfig.Health.Value ..
            '. (Current health: ' .. math.floor(getHealth() + 0.5) .. ')', 5)
        self.hasNotified = true
    end

    function handlers:playNotificationSound()
        if antiDeathConfig.Sound.Enabled then
            local soundId = antiDeathConfig.SongId.Value ~= '' and antiDeathConfig.SongId.Value or '7396762708'
            playSound(soundId, false)
        end
    end

    function handlers:resetMode()
        if self.inf then
            if antiDeathConfig.AutoDisable.Enabled then
                if vape.Modules.InfiniteFly.Enabled then
                    vape.Modules.InfiniteFly:Toggle(false)
                end
            end
            self.inf = false
            self.hasNotified = false
        elseif self.godmode then
			if antiDeathConfig.AutoDisable.Enabled then
                if GodMode.Enabled then
                    GodMode:Toggle(false)
                end
            end
            self.godmode = false
            self.hasNotified = false
		end
    end

    local antiDeathStatus = handlers.new()

    antiDeath = vape.Categories.Utility:CreateModule({
        Name = 'AntiDeath',
        Function = function(callback)
            if callback then
                coroutine.wrap(function()
                    antiDeathStatus:enable()
                end)()
            else
                pcall(function()
                    antiDeathStatus:disable()
                end)
            end
        end,
        Default = false,
        Tooltip = btext('Prevents you from dying.'),
        ExtraText = function()
            return antiDeathConfig.Mode.Value
        end
    })

    antiDeathConfig.Mode = antiDeath:CreateDropdown({
        Name = 'Mode',
        List = {'Infinite', 'Boost', 'Sky', 'AntiHit'},
        Default = 'AntiHit',
        Tooltip = btext('Mode to prevent death.'),
        Function = function(val)
            antiDeathConfig.BoostMode.Object.Visible = val == 'Boost'
            antiDeathConfig.SkyPosition.Object.Visible = val == 'Sky'
            antiDeathConfig.AutoDisable.Object.Visible = (val == 'Infinite' or val == 'AntiHit')
            antiDeathConfig.Velocity.Object.Visible = false
            antiDeathConfig.CFrame.Object.Visible = false
            antiDeathConfig.TweenPower.Object.Visible = false
            antiDeathConfig.TweenDuration.Object.Visible = false
        end
    })

    antiDeathConfig.BoostMode = antiDeath:CreateDropdown({
        Name = 'Boost',
        List = { 'Velocity', 'CFrame', 'Tween' },
        Default = 'Velocity',
        Tooltip = btext('Mode to boost your character.'),
        Function = function(val)
            antiDeathConfig.Velocity.Object.Visible = val == 'Velocity'
            antiDeathConfig.CFrame.Object.Visible = val == 'CFrame'
            antiDeathConfig.TweenPower.Object.Visible = val == 'Tween'
            antiDeathConfig.TweenDuration.Object.Visible = val == 'Tween'
        end
    })
    antiDeathConfig.BoostMode.Object.Visible = false

    antiDeathConfig.SongId = antiDeath:CreateTextBox({
        Name = 'SongID',
        TempText = 'Song ID',
        Tooltip = 'ID to play the song.',
        FocusLost = function()
            if antiDeath.Enabled then
                antiDeath:Toggle()
                antiDeath:Toggle()
            end
        end
    })
    antiDeathConfig.SongId.Object.Visible = false

    antiDeathConfig.Health = antiDeath:CreateSlider({
        Name = 'Health Trigger',
        Min = 10,
        Max = 90,
        Tooltip = btext('Health at which AntiDeath will perform its actions.'),
        Default = 50,
        Function = function(val) end
    })

    antiDeathConfig.Velocity = antiDeath:CreateSlider({
        Name = 'Velocity Boost',
        Min = 100,
        Max = 600,
        Tooltip = btext('Power to get boosted in the air.'),
        Default = 600,
        Function = function(val) end
    })
    antiDeathConfig.Velocity.Object.Visible = false

    antiDeathConfig.CFrame = antiDeath:CreateSlider({
        Name = 'CFrame Boost',
        Min = 100,
        Max = 1000,
        Tooltip = btext('Power to get boosted in the air.'),
        Default = 1000,
        Function = function(val) end
    })
    antiDeathConfig.CFrame.Object.Visible = false

    antiDeathConfig.TweenPower = antiDeath:CreateSlider({
        Name = 'Tween Boost',
        Min = 100,
        Max = 1300,
        Tooltip = btext('Power to get boosted in the air.'),
        Default = 1000,
        Function = function(val) end
    })
    antiDeathConfig.TweenPower.Object.Visible = false

    antiDeathConfig.TweenDuration = antiDeath:CreateSlider({
        Name = 'Tween Duration',
        Min = 1,
        Max = 10,
        Tooltip = btext('Duration of the tweening process.'),
        Default = 4,
        Function = function(val) end
    })
    antiDeathConfig.TweenDuration.Object.Visible = false

    antiDeathConfig.SkyPosition = antiDeath:CreateSlider({
        Name = 'Sky Position',
        Min = 100,
        Max = 1000,
        Tooltip = btext('Position to TP in the sky.'),
        Default = 1000,
        Function = function(val) end
    })
    antiDeathConfig.SkyPosition.Object.Visible = false

    antiDeathConfig.AutoDisable = antiDeath:CreateToggle({
        Name = 'Auto Disable',
        Tooltip = btext('Automatically disables InfiniteFly after healing.'),
        Function = function(val) end,
        Default = true
    })
    antiDeathConfig.AutoDisable.Object.Visible = false

    antiDeathConfig.Sound = antiDeath:CreateToggle({
        Name = 'Sound',
        Tooltip = btext('Plays a sound after preventing death.'),
        Function = function(callback)
            antiDeathConfig.SongId.Object.Visible = callback
        end,
        Default = true
    })

    antiDeathConfig.Notify = antiDeath:CreateToggle({
        Name = 'Notification',
        Tooltip = btext('Notifies you when AntiDeath actioned.'),
        Default = true,
        Function = function(callback) end
    })
end)

run(function()
	local TexturePacks = {["Enabled"] = false}
	local packselected = {["Value"] = "OldBedwars"}

	local toolFunction = function() end
	local con

	local packfunctions = {
		SeventhPack = function() 
			task.spawn(function()
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				local objs = game:GetObjects("rbxassetid://14033898270")
				local import = objs[1]
				import.Parent = ReplicatedStorage
				local index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},	
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
					{
						name = "wood_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-190), math.rad(-95)),
						model = import:WaitForChild("Wood_Pickaxe"),
					},
					{
						name = "stone_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-190), math.rad(-95)),
						model = import:WaitForChild("Stone_Pickaxe"),
					},
					{
						name = "iron_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-190), math.rad(-95)),
						model = import:WaitForChild("Iron_Pickaxe"),
					},
					{
						name = "diamond_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(80), math.rad(-95)),
						model = import:WaitForChild("Diamond_Pickaxe"),
					},	
					{
						name = "wood_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Wood_Axe"),
					},	
					{
						name = "stone_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Stone_Axe"),
					},	
					{
						name = "iron_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Iron_Axe"),
					},	
					{
						name = "diamond_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(-95)),
						model = import:WaitForChild("Diamond_Axe"),
					},	
					{
						name = "fireball",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Fireball"),
					},	
					{
						name = "telepearl",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Telepearl"),
					},
				}
				toolFunction = function(tool)	
					if not tool:IsA("Accessory") then return end	
					for _, v in ipairs(index) do	
						if v.name == tool.Name then		
							for _, part in ipairs(tool:GetDescendants()) do
								if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then				
									part.Transparency = 1
								end			
							end		
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							model.Parent = tool			
							local weld = Instance.new("WeldConstraint", model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")			
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)			
							for _, part in ipairs(tool2:GetDescendants()) do
								if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then				
									part.Transparency = 1				
								end			
							end			
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							if v.name:match("sword") or v.name:match("blade") then
								model2.CFrame *= CFrame.new(.5, 0, -1.1) - Vector3.new(0, 0, -.3)
							elseif v.name:match("axe") and not v.name:match("pickaxe") and v.name:match("diamond") then
								model2.CFrame *= CFrame.new(.08, 0, -1.1) - Vector3.new(0, 0, -.9)
							elseif v.name:match("axe") and not v.name:match("pickaxe") and not v.name:match("diamond") then
								model2.CFrame *= CFrame.new(-.2, 0, -2.4) + Vector3.new(0, 0, 2.12)
							else
								model2.CFrame *= CFrame.new(.2, 0, -.09)
							end
							model2.Parent = tool2
							local weld2 = Instance.new("WeldConstraint", model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")
						end
					end
				end
			end)
		end,
		EighthPack = function() 
			task.spawn(function()
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				local objs = game:GetObjects("rbxassetid://14078540433")
				local import = objs[1]
				import.Parent = game:GetService("ReplicatedStorage")
				index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
					{
						name = "rageblade",
						offset = CFrame.Angles(math.rad(0),math.rad(-90),math.rad(90)),
						model = import:WaitForChild("Rageblade"),
					}, 
				}
				toolFunction = function(tool)
					if(not tool:IsA("Accessory")) then return end
					for i,v in pairs(index) do
						if(v.name == tool.Name) then
							for i,v in pairs(tool:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model.Parent = tool
							local weld = Instance.new("WeldConstraint",model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
							for i,v in pairs(tool2:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model2.CFrame *= CFrame.new(.5,0,-.8)
							model2.Parent = tool2
							local weld2 = Instance.new("WeldConstraint",model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")
						end
					end
				end
			end)
		end,
		SixthPack = function() 
			task.spawn(function()
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")

				local objs = game:GetObjects("rbxassetid://13780890894")
				local import = objs[1]
				import.Parent = ReplicatedStorage
				
				local swordIndex = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
				}
				
				local pickaxeIndex = {
					{
						name = "wood_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-190), math.rad(-95)),
						model = import:WaitForChild("Wood_Pickaxe"),
					},
					{
						name = "stone_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-190), math.rad(-95)),
						model = import:WaitForChild("Stone_Pickaxe"),
					},
					{
						name = "iron_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-190), math.rad(-95)),
						model = import:WaitForChild("Iron_Pickaxe"),
					},
					{
						name = "diamond_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(80), math.rad(-95)),
						model = import:WaitForChild("Diamond_Pickaxe"),
					},
				}

				local swordFunction = function(tool)
					if not tool:IsA("Accessory") then
						return
					end
					
					for _, v in pairs(swordIndex) do
						if v.name == tool.Name then
							for _, v in pairs(tool:GetDescendants()) do
								if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
									v.Transparency = 1
								end
							end
							
							local model = v.model:Clone()
							model.CFrame = tool.Handle.CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							model.Parent = tool
							
							local weld = Instance.new("WeldConstraint", model)
							weld.Part0 = model
							weld.Part1 = tool.Handle
							
							local tool2 = Players.LocalPlayer.Character[tool.Name]
							
							for _, v in pairs(tool2:GetDescendants()) do
								if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
									v.Transparency = 1
								end
							end
							
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2.Handle.CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							model2.CFrame *= CFrame.new(0.4, 0, -0.9)
							model2.Parent = tool2
							
							local weld2 = Instance.new("WeldConstraint", model)
							weld2.Part0 = model2
							weld2.Part1 = tool2.Handle
						end
					end
				end

				local pickaxeFunction = function(tool)
					if not tool:IsA("Accessory") then
						return
					end

					for _, v in pairs(pickaxeIndex) do
						if v.name == tool.Name then
							for _, v in pairs(tool:GetDescendants()) do
								if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
									v.Transparency = 1
								end
							end
							local model = v.model:Clone()
							model.CFrame = tool.Handle.CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							model.Parent = tool
							local weld = Instance.new("WeldConstraint", model)
							weld.Part0 = model
							weld.Part1 = tool.Handle
							local tool2 = Players.LocalPlayer.Character[tool.Name]
							for _, v in pairs(tool2:GetDescendants()) do
								if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
									v.Transparency = 1
								end
							end
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2.Handle.CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							model2.CFrame *= CFrame.new(-0.2, 0, -0.08)
							model2.Parent = tool2
							local weld2 = Instance.new("WeldConstraint", model)
							weld2.Part0 = model2
							weld2.Part1 = tool2.Handle
						end
					end
				end

				toolFunction = function(tool)
					task.spawn(function() swordFunction(tool) end)
					task.spawn(function() pickaxeFunction(tool) end)
				end
			end)
		end,
		FifthPack = function() 
			task.spawn(function()
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				
				local objs = game:GetObjects("rbxassetid://13802020264")
				local import = objs[1]
				
				import.Parent = game:GetService("ReplicatedStorage")
				
				index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},
					
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
					
					
				}
				
				toolFunction = function(tool)
					if(not tool:IsA("Accessory")) then return end
					for i,v in pairs(index) do
						if(v.name == tool.Name) then
							for i,v in pairs(tool:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
						
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model.Parent = tool
							
							local weld = Instance.new("WeldConstraint",model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")
							
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
							
							for i,v in pairs(tool2:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model2.CFrame *= CFrame.new(0.8,0,-.9)
							model2.Parent = tool2
							
							local weld2 = Instance.new("WeldConstraint",model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")			
						end
					end
				end
			end)
		end,
		FourthPack = function() 
			task.spawn(function()
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				
				local objs = game:GetObjects("rbxassetid://13801509384")
				local import = objs[1]
				
				import.Parent = game:GetService("ReplicatedStorage")
				
				index = {
				
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},
					
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
					
					{
						name = "rageblade",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-270)),
						model = import:WaitForChild("Rageblade"),
					},
					
					
				}

				toolFunction = function(tool)
					if(not tool:IsA("Accessory")) then return end
					for i,v in pairs(index) do
						if(v.name == tool.Name) then	
							for i,v in pairs(tool:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then	
									v.Transparency = 1
								end
							end
						
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model.Parent = tool
							
							local weld = Instance.new("WeldConstraint",model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")
							
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
							
							for i,v in pairs(tool2:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then	
									v.Transparency = 1	
								end	
							end

							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model2.CFrame *= CFrame.new(0.4,0,-.9)
							model2.Parent = tool2
							
							local weld2 = Instance.new("WeldConstraint",model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")					
						end
					end
				end
			end)
		end,
		SecondPack = function() 
			task.spawn(function()
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				local objs = game:GetObjects("rbxassetid://13801616054")
				local import = objs[1]
				import.Parent = game:GetService("ReplicatedStorage")
				index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(100),math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},
					
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(100),math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(100),math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(100),math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(100),math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
					
					{
						name = "rageblade",
						offset = CFrame.Angles(math.rad(0),math.rad(100),math.rad(-270)),
						model = import:WaitForChild("Rageblade"),
					},
					
					
				}

				toolFunction = function(tool)
					if(not tool:IsA("Accessory")) then return end
					for i,v in pairs(index) do
						if(v.name == tool.Name) then
							for i,v in pairs(tool:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
						
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model.Parent = tool
							
							local weld = Instance.new("WeldConstraint",model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")
							
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
							
							for i,v in pairs(tool2:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model2.CFrame *= CFrame.new(0.8,0,-.9)
							model2.Parent = tool2
							
							local weld2 = Instance.new("WeldConstraint",model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")
						end
					end
				end
			end)
		end,
		FirstPack = function() 
			task.spawn(function()
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				local objs = game:GetObjects("rbxassetid://13783192680")
				local import = objs[1]
				import.Parent = game:GetService("ReplicatedStorage")
				index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},
					
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
					
					
				}
				toolFunction = function(tool)
					if(not tool:IsA("Accessory")) then return end
					for i,v in pairs(index) do
						if(v.name == tool.Name) then
							for i,v in pairs(tool:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model.Parent = tool
							
							local weld = Instance.new("WeldConstraint",model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")
							
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
							
							for i,v in pairs(tool2:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model2.CFrame *= CFrame.new(0.4,0,-.9)
							model2.Parent = tool2
							
							local weld2 = Instance.new("WeldConstraint",model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")
						end
					end
				end
			end)
		end,
		CottonCandy = function() 
			task.spawn(function() 
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				local objs = game:GetObjects("rbxassetid://14161283331")
				local import = objs[1]
				import.Parent = ReplicatedStorage
				local index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},	
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
					{
						name = "rageblade",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(90)),
						model = import:WaitForChild("Rageblade"),
					}, 
					{
						name = "wood_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)),
						model = import:WaitForChild("Wood_Pickaxe"),
					},
					{
						name = "stone_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)),
						model = import:WaitForChild("Stone_Pickaxe"),
					},
					{
						name = "iron_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-18033), math.rad(-95)),
						model = import:WaitForChild("Iron_Pickaxe"),
					},
					{
						name = "diamond_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(80), math.rad(-95)),
						model = import:WaitForChild("Diamond_Pickaxe"),
					},	
					{
						name = "wood_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Wood_Axe"),
					},	
					{
						name = "stone_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Stone_Axe"),
					},	
					{
						name = "iron_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Iron_Axe"),
					},	
					{
						name = "diamond_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-95)),
						model = import:WaitForChild("Diamond_Axe"),
					},	
					{
						name = "fireball",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Fireball"),
					},	
					{
						name = "telepearl",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Telepearl"),
					},
					{
						name = "diamond",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Diamond"),
					},
					{
						name = "iron",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Iron"),
					},
					{
						name = "gold",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Gold"),
					},
					{
						name = "emerald",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Emerald"),
					},
					{
						name = "wood_bow",
						offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)),
						model = import:WaitForChild("Bow"),
					},
					{
						name = "wood_crossbow",
						offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)),
						model = import:WaitForChild("Bow"),
					},
					{
						name = "tactical_crossbow",
						offset = CFrame.Angles(math.rad(0), math.rad(180), math.rad(-90)),
						model = import:WaitForChild("Bow"),
					},
				}
				toolFunction = function(tool)	
					if not tool:IsA("Accessory") then return end	
					for _, v in ipairs(index) do	
						if v.name == tool.Name then		
							for _, part in ipairs(tool:GetDescendants()) do
								if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then				
									part.Transparency = 1
								end			
							end		
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							model.Parent = tool			
							local weld = Instance.new("WeldConstraint", model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")			
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)			
							for _, part in ipairs(tool2:GetDescendants()) do
								if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then				
									part.Transparency = 1				
								end			
							end			
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							if v.name:match("rageblade") then
								model2.CFrame *= CFrame.new(0.7, 0, -1)                           
							elseif v.name:match("sword") or v.name:match("blade") then
								model2.CFrame *= CFrame.new(.6, 0, -1.1) - Vector3.new(0, 0, -.3)
							elseif v.name:match("axe") and not v.name:match("pickaxe") and v.name:match("diamond") then
								model2.CFrame *= CFrame.new(.08, 0, -1.1) - Vector3.new(0, 0, -1.1)
							elseif v.name:match("axe") and not v.name:match("pickaxe") and not v.name:match("diamond") then
								model2.CFrame *= CFrame.new(-.2, 0, -2.4) + Vector3.new(0, 0, 2.12)
							elseif v.name:match("iron") then
								model2.CFrame *= CFrame.new(0, -.24, 0)
							elseif v.name:match("gold") then
								model2.CFrame *= CFrame.new(0, .03, 0)
							elseif v.name:match("diamond") then
								model2.CFrame *= CFrame.new(0, .027, 0)
							elseif v.name:match("emerald") then
								model2.CFrame *= CFrame.new(0, .001, 0)
							elseif v.name:match("telepearl") then
								model2.CFrame *= CFrame.new(.1, 0, .1)
							elseif v.name:match("fireball") then
								model2.CFrame *= CFrame.new(.28, .1, 0)
							elseif v.name:match("bow") and not v.name:match("crossbow") then
								model2.CFrame *= CFrame.new(-.29, .1, -.2)
							elseif v.name:match("wood_crossbow") and not v.name:match("tactical_crossbow") then
								model2.CFrame *= CFrame.new(-.6, 0, 0)
							elseif v.name:match("tactical_crossbow") and not v.name:match("wood_crossbow") then
								model2.CFrame *= CFrame.new(-.5, 0, -1.2)
							else
								model2.CFrame *= CFrame.new(.2, 0, -.2)
							end
							model2.Parent = tool2
							local weld2 = Instance.new("WeldConstraint", model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")
						end
					end
				end   
			end)
		end,
		EgirlPack = function() 
			task.spawn(function() 	
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				local objs = game:GetObjects("rbxassetid://14126814481")
				local import = objs[1]
				import.Parent = game:GetService("ReplicatedStorage")
				index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
					{
						name = "rageblade",
						offset = CFrame.Angles(math.rad(0),math.rad(-90),math.rad(90)),
						model = import:WaitForChild("Rageblade"),
					}, 
				}
				toolFunction = function(tool)
					if(not tool:IsA("Accessory")) then return end
					for i,v in pairs(index) do
						if(v.name == tool.Name) then
							for i,v in pairs(tool:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model.Parent = tool
							local weld = Instance.new("WeldConstraint",model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
							for i,v in pairs(tool2:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model2.CFrame *= CFrame.new(.6,0,-1)
							model2.Parent = tool2
							local weld2 = Instance.new("WeldConstraint",model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")
						end
					end
				end             
			end)
		end,
		GlizzyPack = function() 
			task.spawn(function()
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				local objs = game:GetObjects("rbxassetid://13804645310")
				local import = objs[1]
				import.Parent = game:GetService("ReplicatedStorage")
				index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
					{
						name = "rageblade",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-270)),
						model = import:WaitForChild("Rageblade"),
					},
				}
				toolFunction = function(tool)
					if(not tool:IsA("Accessory")) then return end
					for i,v in pairs(index) do
						if(v.name == tool.Name) then
							for i,v in pairs(tool:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0),math.rad(100),math.rad(0))
							model.Parent = tool
							local weld = Instance.new("WeldConstraint",model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
							for i,v in pairs(tool2:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0),math.rad(-105),math.rad(0))
							model2.CFrame *= CFrame.new(-0.4,0,-0.10)
							model2.Parent = tool2
							local weld2 = Instance.new("WeldConstraint",model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")
						end
					end
				end
			end)
        end,
		PrivatePack = function() 
			task.spawn(function()
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				local objs = game:GetObjects("rbxassetid://14161283331")
				local import = objs[1]
				import.Parent = ReplicatedStorage
				local index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},	
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
					{
						name = "rageblade",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(90)),
						model = import:WaitForChild("Rageblade"),
					}, 
					{
						name = "wood_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)),
						model = import:WaitForChild("Wood_Pickaxe"),
					},
					{
						name = "stone_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)),
						model = import:WaitForChild("Stone_Pickaxe"),
					},
					{
						name = "iron_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-18033), math.rad(-95)),
						model = import:WaitForChild("Iron_Pickaxe"),
					},
					{
						name = "diamond_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(80), math.rad(-95)),
						model = import:WaitForChild("Diamond_Pickaxe"),
					},	
					{
						name = "wood_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Wood_Axe"),
					},	
					{
						name = "stone_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Stone_Axe"),
					},	
					{
						name = "iron_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Iron_Axe"),
					},	
					{
						name = "diamond_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-95)),
						model = import:WaitForChild("Diamond_Axe"),
					},	
					{
						name = "fireball",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Fireball"),
					},	
					{
						name = "telepearl",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Telepearl"),
					},
					{
						name = "diamond",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Diamond"),
					},
					{
						name = "iron",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Iron"),
					},
					{
						name = "gold",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Gold"),
					},
					{
						name = "emerald",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Emerald"),
					},
					{
						name = "wood_bow",
						offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)),
						model = import:WaitForChild("Bow"),
					},
					{
						name = "wood_crossbow",
						offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)),
						model = import:WaitForChild("Bow"),
					},
					{
						name = "tactical_crossbow",
						offset = CFrame.Angles(math.rad(0), math.rad(180), math.rad(-90)),
						model = import:WaitForChild("Bow"),
					},
				}
				toolFunction = function(tool)	
					if not tool:IsA("Accessory") then return end	
					for _, v in ipairs(index) do	
						if v.name == tool.Name then		
							for _, part in ipairs(tool:GetDescendants()) do
								if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then				
									part.Transparency = 1
								end			
							end		
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							model.Parent = tool			
							local weld = Instance.new("WeldConstraint", model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")			
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)			
							for _, part in ipairs(tool2:GetDescendants()) do
								if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then				
									part.Transparency = 1				
								end			
							end			
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							if v.name:match("rageblade") then
								model2.CFrame *= CFrame.new(0.7, 0, -1)                           
							elseif v.name:match("sword") or v.name:match("blade") then
								model2.CFrame *= CFrame.new(.6, 0, -1.1) - Vector3.new(0, 0, -.3)
							elseif v.name:match("axe") and not v.name:match("pickaxe") and v.name:match("diamond") then
								model2.CFrame *= CFrame.new(.08, 0, -1.1) - Vector3.new(0, 0, -1.1)
							elseif v.name:match("axe") and not v.name:match("pickaxe") and not v.name:match("diamond") then
								model2.CFrame *= CFrame.new(-.2, 0, -2.4) + Vector3.new(0, 0, 2.12)
							elseif v.name:match("iron") then
								model2.CFrame *= CFrame.new(0, -.24, 0)
							elseif v.name:match("gold") then
								model2.CFrame *= CFrame.new(0, .03, 0)
							elseif v.name:match("diamond") then
								model2.CFrame *= CFrame.new(0, .027, 0)
							elseif v.name:match("emerald") then
								model2.CFrame *= CFrame.new(0, .001, 0)
							elseif v.name:match("telepearl") then
								model2.CFrame *= CFrame.new(.1, 0, .1)
							elseif v.name:match("fireball") then
								model2.CFrame *= CFrame.new(.28, .1, 0)
							elseif v.name:match("bow") and not v.name:match("crossbow") then
								model2.CFrame *= CFrame.new(-.29, .1, -.2)
							elseif v.name:match("wood_crossbow") and not v.name:match("tactical_crossbow") then
								model2.CFrame *= CFrame.new(-.6, 0, 0)
							elseif v.name:match("tactical_crossbow") and not v.name:match("wood_crossbow") then
								model2.CFrame *= CFrame.new(-.5, 0, -1.2)
							else
								model2.CFrame *= CFrame.new(.2, 0, -.2)
							end
							model2.Parent = tool2
							local weld2 = Instance.new("WeldConstraint", model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")
						end
					end
				end          
			end)
        end,
		DemonSlayerPack = function() 
			task.spawn(function()
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				local objs = game:GetObjects("rbxassetid://14241215869")
				local import = objs[1]
				import.Parent = ReplicatedStorage
				local index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},	
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
					{
						name = "wood_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)),
						model = import:WaitForChild("Wood_Pickaxe"),
					},
					{
						name = "stone_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)),
						model = import:WaitForChild("Stone_Pickaxe"),
					},
					{
						name = "iron_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)),
						model = import:WaitForChild("Iron_Pickaxe"),
					},
					{
						name = "diamond_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(90), math.rad(-95)),
						model = import:WaitForChild("Diamond_Pickaxe"),
					},	
					{
						name = "fireball",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Fireball"),
					},	
					{
						name = "telepearl",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Telepearl"),
					},
					{
						name = "diamond",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(-90)),
						model = import:WaitForChild("Diamond"),
					},
					{
						name = "iron",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Iron"),
					},
					{
						name = "gold",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Gold"),
					},
					{
						name = "emerald",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(-90)),
						model = import:WaitForChild("Emerald"),
					},
					{
						name = "wood_bow",
						offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)),
						model = import:WaitForChild("Bow"),
					},
					{
						name = "wood_crossbow",
						offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)),
						model = import:WaitForChild("Bow"),
					},
					{
						name = "tactical_crossbow",
						offset = CFrame.Angles(math.rad(0), math.rad(180), math.rad(-90)),
						model = import:WaitForChild("Bow"),
					},
					{
						name = "wood_dao",
						offset = CFrame.Angles(math.rad(0), math.rad(89), math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},
					{
						name = "stone_dao",
						offset = CFrame.Angles(math.rad(0), math.rad(89), math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					{
						name = "iron_dao",
						offset = CFrame.Angles(math.rad(0), math.rad(89), math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					{
						name = "diamond_dao",
						offset = CFrame.Angles(math.rad(0), math.rad(89), math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
				}
				toolFunction = function(tool)	
					if not tool:IsA("Accessory") then return end	
					for _, v in ipairs(index) do	
						if v.name == tool.Name then		
							for _, part in ipairs(tool:GetDescendants()) do
								if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then				
									part.Transparency = 1
								end			
							end		
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							model.Parent = tool			
							local weld = Instance.new("WeldConstraint", model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")			
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)			
							for _, part in ipairs(tool2:GetDescendants()) do
								if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then				
									part.Transparency = 1				
								end			
							end			
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							if v.name:match("rageblade") then
								model2.CFrame *= CFrame.new(0.7, 0, -.7)                           
							elseif v.name:match("sword") or v.name:match("blade") then
								model2.CFrame *= CFrame.new(.2, 0, -.8)
							elseif v.name:match("dao") then
								model2.CFrame *= CFrame.new(.7, 0, -1.3)
							elseif v.name:match("axe") and not v.name:match("pickaxe") and v.name:match("diamond") then
								model2.CFrame *= CFrame.new(.08, 0, -1.1) - Vector3.new(0, 0, -1.1)
							elseif v.name:match("axe") and not v.name:match("pickaxe") and not v.name:match("diamond") then
								model2.CFrame *= CFrame.new(-.2, 0, -2.4) + Vector3.new(0, 0, 2.12)
							elseif v.name:match("diamond_pickaxe") then
								model2.CFrame *= CFrame.new(.2, 0, -.26)
							elseif v.name:match("iron") and not v.name:match("iron_pickaxe") then
								model2.CFrame *= CFrame.new(0, -.24, 0)
							elseif v.name:match("gold") then
								model2.CFrame *= CFrame.new(0, .03, 0)
							elseif v.name:match("diamond") or v.name:match("emerald") then
								model2.CFrame *= CFrame.new(0, -.03, 0)
							elseif v.name:match("telepearl") then
								model2.CFrame *= CFrame.new(.1, 0, .1)
							elseif v.name:match("fireball") then
								model2.CFrame *= CFrame.new(.28, .1, 0)
							elseif v.name:match("bow") and not v.name:match("crossbow") then
								model2.CFrame *= CFrame.new(-.2, .1, -.05)
							elseif v.name:match("wood_crossbow") and not v.name:match("tactical_crossbow") then
								model2.CFrame *= CFrame.new(-.5, 0, .05)
							elseif v.name:match("tactical_crossbow") and not v.name:match("wood_crossbow") then
								model2.CFrame *= CFrame.new(-.35, 0, -1.2)
							else
								model2.CFrame *= CFrame.new(.0, 0, -.06)
							end
							model2.Parent = tool2
							local weld2 = Instance.new("WeldConstraint", model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")
						end
					end
				end
			end)
		end,
        FirstHighResPack = function() 
            task.spawn(function()
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				local objs = game:GetObjects("rbxassetid://14224565815")
				local import = objs[1]
				import.Parent = ReplicatedStorage
				local index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
          			{
                        name = "rageblade",
                        offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(90)),
                        model = import:WaitForChild("Rageblade"),
          			},
					{
						name = "wood_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)),
						model = import:WaitForChild("Wood_Pickaxe"),
					},
					{
						name = "stone_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)),
						model = import:WaitForChild("Stone_Pickaxe"),
					},
					{
						name = "iron_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)),
						model = import:WaitForChild("Iron_Pickaxe"),
					},
					{
						name = "diamond_pickaxe",
						offset = CFrame.Angles(math.rad(0), math.rad(90), math.rad(-95)),
						model = import:WaitForChild("Diamond_Pickaxe"),
					},
					{
						name = "wood_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Wood_Axe"),
					},
					{
						name = "stone_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Stone_Axe"),
					},
					{
						name = "iron_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
						model = import:WaitForChild("Iron_Axe"),
					},
					{
						name = "diamond_axe",
						offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-95)),
						model = import:WaitForChild("Diamond_Axe"),
					},
					{
						name = "fireball",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Fireball"),
					},
					{
						name = "telepearl",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Telepearl"),
					},
					{
						name = "diamond",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(-90)),
						model = import:WaitForChild("Diamond"),
					},
					{
						name = "iron",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Iron"),
					},
					{
						name = "gold",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)),
						model = import:WaitForChild("Gold"),
					},
					{
						name = "emerald",
						offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(-90)),
						model = import:WaitForChild("Emerald"),
					},
					{
						name = "wood_bow",
						offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)),
						model = import:WaitForChild("Bow"),
					},
					{
						name = "wood_crossbow",
						offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)),
						model = import:WaitForChild("Bow"),
					},
					{
						name = "tactical_crossbow",
						offset = CFrame.Angles(math.rad(0), math.rad(180), math.rad(-90)),
						model = import:WaitForChild("Bow"),
					},
				}
				toolFunction = function(tool)
					if not tool:IsA("Accessory") then return end
					for _, v in ipairs(index) do
						if v.name == tool.Name then
							for _, part in ipairs(tool:GetDescendants()) do
								if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then
									part.Transparency = 1
								end
							end
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							model.Parent = tool
							local weld = Instance.new("WeldConstraint", model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
							for _, part in ipairs(tool2:GetDescendants()) do
								if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then
									part.Transparency = 1
								end
							end
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
							if v.name:match("rageblade") then
								model2.CFrame *= CFrame.new(0.7, 0, -1)
							elseif v.name:match("sword") or v.name:match("blade") then
								model2.CFrame *= CFrame.new(.6, 0, -1.1) - Vector3.new(0, 0, -.3)
							elseif v.name:match("axe") and not v.name:match("pickaxe") and v.name:match("diamond") then
								model2.CFrame *= CFrame.new(.08, 0, -1.1) - Vector3.new(0, 0, -1.1)
							elseif v.name:match("axe") and not v.name:match("pickaxe") and not v.name:match("diamond") then
								model2.CFrame *= CFrame.new(-.2, 0, -2.4) + Vector3.new(0, 0, 2.12)
							elseif v.name:match("diamond_pickaxe") then
								model2.CFrame *= CFrame.new(.2, 0, -.26)
							elseif v.name:match("iron") and not v.name:match("iron_pickaxe") then
								model2.CFrame *= CFrame.new(0, -.24, 0)
							elseif v.name:match("gold") then
								model2.CFrame *= CFrame.new(0, .03, 0)
							elseif v.name:match("diamond") or v.name:match("emerald") then
								model2.CFrame *= CFrame.new(0, -.03, 0)
							elseif v.name:match("telepearl") then
								model2.CFrame *= CFrame.new(.1, 0, .1)
							elseif v.name:match("fireball") then
								model2.CFrame *= CFrame.new(.28, .1, 0)
							elseif v.name:match("bow") and not v.name:match("crossbow") then
								model2.CFrame *= CFrame.new(-.2, .1, -.05)
							elseif v.name:match("wood_crossbow") and not v.name:match("tactical_crossbow") then
								model2.CFrame *= CFrame.new(-.5, 0, .05)
							elseif v.name:match("tactical_crossbow") and not v.name:match("wood_crossbow") then
								model2.CFrame *= CFrame.new(-.35, 0, -1.2)
							else
								model2.CFrame *= CFrame.new(.2, 0, -.24)
							end
							model2.Parent = tool2
							local weld2 = Instance.new("WeldConstraint", model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")
						end
					end
				end
           end)
		end,
        RandomPack = function() 
            task.spawn(function()  
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				local objs = game:GetObjects("rbxassetid://14282106674")
				local import = objs[1]
				import.Parent = game:GetService("ReplicatedStorage")
				index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-89),math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-89),math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-89),math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-89),math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-89),math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
				}
				toolFunction = function(tool)
					if(not tool:IsA("Accessory")) then return end
					for i,v in pairs(index) do
						if(v.name == tool.Name) then
							for i,v in pairs(tool:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model.Parent = tool
							local weld = Instance.new("WeldConstraint",model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
							for i,v in pairs(tool2:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end            
							end            
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model2.CFrame *= CFrame.new(0.6,0,-.9)
							model2.Parent = tool2
							local weld2 = Instance.new("WeldConstraint",model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")
						end
					end
				end  
           end)
		end,
		SecondHighResPack = function() 
            task.spawn(function()
				local Players = game:GetService("Players")
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local Workspace = game:GetService("Workspace")
				local objs = game:GetObjects("rbxassetid://14078540433")
				local import = objs[1]
				import.Parent = game:GetService("ReplicatedStorage")
				index = {
					{
						name = "wood_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Wood_Sword"),
					},
					{
						name = "stone_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Stone_Sword"),
					},
					{
						name = "iron_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Iron_Sword"),
					},
					{
						name = "diamond_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Diamond_Sword"),
					},
					{
						name = "emerald_sword",
						offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
						model = import:WaitForChild("Emerald_Sword"),
					},
					{
						name = "rageblade",
						offset = CFrame.Angles(math.rad(0),math.rad(-90),math.rad(90)),
						model = import:WaitForChild("Rageblade"),
					}, 
				}
				toolFunction = function(tool)
					if(not tool:IsA("Accessory")) then return end
					for i,v in pairs(index) do
						if(v.name == tool.Name) then
							for i,v in pairs(tool:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							local model = v.model:Clone()
							model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
							model.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model.Parent = tool
							local weld = Instance.new("WeldConstraint",model)
							weld.Part0 = model
							weld.Part1 = tool:WaitForChild("Handle")
							local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
							for i,v in pairs(tool2:GetDescendants()) do
								if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
									v.Transparency = 1
								end
							end
							local model2 = v.model:Clone()
							model2.Anchored = false
							model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
							model2.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
							model2.CFrame *= CFrame.new(.5,0,-.8)
							model2.Parent = tool2
							local weld2 = Instance.new("WeldConstraint",model)
							weld2.Part0 = model2
							weld2.Part1 = tool2:WaitForChild("Handle")
						end
					end
				end
           end)
		end
	}

	if (not TexturePacks.Enabled) then toolFunction = function() end end

	local function refresh()
		pcall(function() con:Disconnect() end)
		con = game:GetService("Workspace"):WaitForChild("Camera").Viewmodel.ChildAdded:Connect(toolFunction)
		for i,v in pairs(game:GetService("Workspace"):WaitForChild("Camera").Viewmodel:GetChildren()) do toolFunction(v) end
	end

	TexturePacks = vape.Categories.Render:CreateModule({
		["Name"] = "TexturePacksV3",
		["Function"] = function(callback) 
			if callback then 
				packfunctions[packselected["Value"]]()
				refresh()
            else 
				toolFunction = function() end
				refresh()
			end
		end
	})
	local list = {}
	for i,v in pairs(packfunctions) do table.insert(list, tostring(i)) end
	packselected = TexturePacks:CreateDropdown({
		["Name"] = "Pack",
		["Function"] = function() if TexturePacks.Enabled then packfunctions[packselected["Value"]](); refresh() end end,
		["List"] = list
	})
end)

--[[run(function()
	local AutoUpgradeEra = {}

	local function invokePurchaseEra(eras)
		for _, era in ipairs(eras) do
			local args = {
				[1] = {
					["era"] = era
				}
			}
			game:GetService("ReplicatedStorage")
				:WaitForChild("rbxts_include")
				:WaitForChild("node_modules")
				:WaitForChild("@rbxts")
				:WaitForChild("net")
				:WaitForChild("out")
				:WaitForChild("_NetManaged")
				:WaitForChild("RequestPurchaseEra")
				:InvokeServer(unpack(args))
			task.wait(0.1) 
		end
	end

	local function invokePurchaseUpgrade(upgrades)
		for _, upgrade in ipairs(upgrades) do
			local args = {
				[1] = {
					["upgrade"] = upgrade
				}
			}
			game:GetService("ReplicatedStorage")
				:WaitForChild("rbxts_include")
				:WaitForChild("node_modules")
				:FindFirstChild("@rbxts")
				:WaitForChild("net")
				:WaitForChild("out")
				:WaitForChild("_NetManaged")
				:WaitForChild("RequestPurchaseTeamUpgrade")
				:InvokeServer(unpack(args))
			task.wait(0.1) 
		end
	end

	AutoUpgradeEra = vape.Categories.Blatant:CreateModule({
		Name = 'AutoUpgradeEra',
		Function = function(calling)
			if calling then 
				task.spawn(function()
					repeat 
						task.wait()
						invokePurchaseEra({"iron_era", "diamond_era", "emerald_era"})
						invokePurchaseUpgrade({"altar_i", "bed_defense_i", "destruction_i", "magic_i", "altar_ii", "destruction_ii", "magic_ii", "altar_iii"})
					until not AutoUpgradeEra.Enabled
				end)
			end
		end
	})
end)--]]

run(function()
    local AdetundeRemote
	local function upgrade(args)
		if not AdetundeRemote then
			AdetundeRemote = game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("UpgradeFrostyHammer")
		end
		return AdetundeRemote:InvokeServer(unpack(args))
	end
    local AdetundeExploit = {}
    local AdetundeExploit_List = { Value = "Shield" }

    local adetunde_remotes = {
        ["Shield"] = function()
            local args = { [1] = "shield" }
            local returning = upgrade(args)
            return returning
        end,

        ["Speed"] = function()
            local args = { [1] = "speed" }
            local returning = upgrade(args)
            return returning
        end,

        ["Strength"] = function()
            local args = { [1] = "strength" }
            local returning = upgrade(args)
            return returning
        end
    }

    local current_upgrador = "Shield"
    local hasnt_upgraded_everything = true
    local testing = 1

    AdetundeExploit = vape.Categories.Blatant:CreateModule({
        Name = 'AdetundeExploit',
        Function = function(calling)
            if calling then 
                -- Check if in testing mode or equipped kit
                -- if tostring(store.queueType) == "training_room" or store.equippedKit == "adetunde" then
                --     AdetundeExploit["ToggleButton"](false) 
                --     current_upgrador = AdetundeExploit_List.Value
                task.spawn(function()
                    repeat
                        local returning_table = adetunde_remotes[current_upgrador]()
                        
                        if type(returning_table) == "table" then
                            local Speed = returning_table["speed"]
                            local Strength = returning_table["strength"]
                            local Shield = returning_table["shield"]

                            print("Speed: " .. tostring(Speed))
                            print("Strength: " .. tostring(Strength))
                            print("Shield: " .. tostring(Shield))
                            print("Current Upgrador: " .. tostring(current_upgrador))

                            if returning_table[string.lower(current_upgrador)] == 3 then
                                if Strength and Shield and Speed then
                                    if Strength == 3 or Speed == 3 or Shield == 3 then
                                        if (Strength == 3 and Speed == 2 and Shield == 2) or
                                           (Strength == 2 and Speed == 3 and Shield == 2) or
                                           (Strength == 2 and Speed == 2 and Shield == 3) then
                                            warningNotification("AdetundeExploit", "Fully upgraded everything possible!", 7)
                                            hasnt_upgraded_everything = false
                                        else
                                            local things = {}
                                            for i, v in pairs(adetunde_remotes) do
                                                table.insert(things, i)
                                            end
                                            for i, v in pairs(things) do
                                                if things[i] == current_upgrador then
                                                    table.remove(things, i)
                                                end
                                            end
                                            local random = things[math.random(1, #things)]
                                            current_upgrador = random
                                        end
                                    end
                                end
                            end
                        else
                            local things = {}
                            for i, v in pairs(adetunde_remotes) do
                                table.insert(things, i)
                            end
                            for i, v in pairs(things) do
                                if things[i] == current_upgrador then
                                    table.remove(things, i)
                                end
                            end
                            local random = things[math.random(1, #things)]
                            current_upgrador = random
                        end
                        task.wait(0.1)
                    until not AdetundeExploit.Enabled or not hasnt_upgraded_everything
                end)
                -- else
                --     AdetundeExploit["ToggleButton"](false)
                --     warningNotification("AdetundeExploit", "Kit required or you need to be in testing mode", 5)
                -- end
            end
        end
    })

    local real_list = {}
    for i, v in pairs(adetunde_remotes) do
        table.insert(real_list, i)
    end

    AdetundeExploit_List = AdetundeExploit:CreateDropdown({
        Name = 'Preferred Upgrade',
        List = real_list,
        Function = function() end,
        Default = "Shield"
    })
end)

run(function()
	function IsAlive(plr)
		plr = plr or lplr
		if not plr.Character then return false end
		if not plr.Character:FindFirstChild("Head") then return false end
		if not plr.Character:FindFirstChild("Humanoid") then return false end
		if plr.Character:FindFirstChild("Humanoid").Health < 0.11 then return false end
		return true
	end
	local Slowmode = {Value = 2}
	GodMode = vape.Categories.Blatant:CreateModule({
		Name = "AntiHit/Godmode",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat task.wait()
						local res, msg = pcall(function()
							if (not vape.Modules.Fly.Enabled) and (not vape.Modules.InfiniteFly.Enabled) then
								for i, v in pairs(game:GetService("Players"):GetChildren()) do
									if v.Team ~= lplr.Team and IsAlive(v) and IsAlive(lplr) then
										if v and v ~= lplr then
											local TargetDistance = lplr:DistanceFromCharacter(v.Character:FindFirstChild("HumanoidRootPart").CFrame.p)
											if TargetDistance < 25 then
												if not lplr.Character:WaitForChild("HumanoidRootPart"):FindFirstChildOfClass("BodyVelocity") then
													repeat task.wait() until shared.GlobalStore.matchState ~= 0
													if not (v.Character.HumanoidRootPart.Velocity.Y < -10*5) then
														lplr.Character.Archivable = true
				
														local Clone = lplr.Character:Clone()
														Clone.Parent = game.Workspace
														Clone.Head:ClearAllChildren()
														gameCamera.CameraSubject = Clone:FindFirstChild("Humanoid")
					
														for i,v in pairs(Clone:GetChildren()) do
															if string.lower(v.ClassName):find("part") and v.Name ~= "HumanoidRootPart" then
																v.Transparency = 1
															end
															if v:IsA("Accessory") then
																v:FindFirstChild("Handle").Transparency = 1
															end
														end
					
														lplr.Character:WaitForChild("HumanoidRootPart").CFrame = lplr.Character:WaitForChild("HumanoidRootPart").CFrame + Vector3.new(0,100,0)
					
														GodMode:Clean(game:GetService("RunService").RenderStepped:Connect(function()
															if Clone ~= nil and Clone:FindFirstChild("HumanoidRootPart") then
																Clone.HumanoidRootPart.Position = Vector3.new(lplr.Character:WaitForChild("HumanoidRootPart").Position.X, Clone.HumanoidRootPart.Position.Y, lplr.Character:WaitForChild("HumanoidRootPart").Position.Z)
															end
														end))
					
														task.wait(Slowmode.Value/10)
														lplr.Character:WaitForChild("HumanoidRootPart").Velocity = Vector3.new(lplr.Character:WaitForChild("HumanoidRootPart").Velocity.X, -1, lplr.Character:WaitForChild("HumanoidRootPart").Velocity.Z)
														lplr.Character:WaitForChild("HumanoidRootPart").CFrame = Clone.HumanoidRootPart.CFrame
														gameCamera.CameraSubject = lplr.Character:FindFirstChild("Humanoid")
														Clone:Destroy()
														task.wait(0.15)
													end
												end
											end
										end
									end
								end
							end
						end)
						if not res then warn(msg) end
					until (not GodMode.Enabled)
				end)
			end
		end
	})
	Slowmode = GodMode:CreateSlider({
		Name = "Slowmode",
		Function = function() end,
		Default = 2,
		Min = 1,
		Max = 25
	})
end)

local vapeAssert = function(argument, title, text, duration, hault, moduledisable, module) 
	if not argument then
    local suc, res = pcall(function()
    local notification = GuiLibrary.CreateNotification(title or "Voidware", text or "Failed to call function.", duration or 20, "assets/WarningNotification.png")
    notification.IconLabel.ImageColor3 = Color3.new(220, 0, 0)
    notification.Frame.Frame.ImageColor3 = Color3.new(220, 0, 0)
    if moduledisable and (module and vape.Modules[module].Enabled) then vape.Modules[module]:Toggle(false) end
    end)
    if hault then while true do task.wait() end end end
end
local function GetMagnitudeOf2Objects(part, part2, bypass)
	local magnitude, partcount = 0, 0
	if not bypass then 
		local suc, res = pcall(function() return part.Position end)
		partcount = suc and partcount + 1 or partcount
		suc, res = pcall(function() return part2.Position end)
		partcount = suc and partcount + 1 or partcount
	end
	if partcount > 1 or bypass then 
		magnitude = bypass and (part - part2).magnitude or (part.Position - part2.Position).magnitude
	end
	return magnitude
end
local function GetTopBlock(position, smart, raycast, customvector)
	position = position or isAlive(lplr, true) and lplr.Character:WaitForChild("HumanoidRootPart").Position
	if not position then 
		return nil 
	end
	if raycast and not game.Workspace:Raycast(position, Vector3.new(0, -2000, 0), store.blockRaycast) then
	    return nil
    end
	local lastblock = nil
	for i = 1, 500 do 
		local newray = game.Workspace:Raycast(lastblock and lastblock.Position or position, customvector or Vector3.new(0.55, 999999, 0.55), store.blockRaycast)
		local smartest = newray and smart and game.Workspace:Raycast(lastblock and lastblock.Position or position, Vector3.new(0, 5.5, 0), store.blockRaycast) or not smart
		if newray and smartest then
			lastblock = newray
		else
			break
		end
	end
	return lastblock
end
local function FindEnemyBed(maxdistance, highest)
	local target = nil
	local distance = maxdistance or math.huge
	local whitelistuserteams = {}
	local badbeds = {}
	if not lplr:GetAttribute("Team") then return nil end
	for i,v in pairs(playersService:GetPlayers()) do
		if v ~= lplr then
			local type, attackable = shared.vapewhitelist:get(v)
			if not attackable then
				whitelistuserteams[v:GetAttribute("Team")] = true
			end
		end
	end
	for i,v in pairs(collectionService:GetTagged("bed")) do
			local bedteamstring = string.split(v:GetAttribute("id"), "_")[1]
			if whitelistuserteams[bedteamstring] ~= nil then
			   badbeds[v] = true
		    end
	    end
	for i,v in pairs(collectionService:GetTagged("bed")) do
		if v:GetAttribute("id") and v:GetAttribute("id") ~= lplr:GetAttribute("Team").."_bed" and badbeds[v] == nil and lplr.Character and lplr.Character.PrimaryPart then
			if v:GetAttribute("NoBreak") or v:GetAttribute("PlacedByUserId") and v:GetAttribute("PlacedByUserId") ~= 0 then continue end
			local magdist = GetMagnitudeOf2Objects(lplr.Character.PrimaryPart, v)
			if magdist < distance then
				target = v
				distance = magdist
			end
		end
	end
	local coveredblock = highest and target and GetTopBlock(target.Position, true)
	if coveredblock then
		target = coveredblock.Instance
	end
	return target
end
local function FindTeamBed()
	local bedstate, res = pcall(function()
		return lplr.leaderstats.Bed.Value
	end)
	return bedstate and res and res ~= nil and res == "✅"
end
local function FindItemDrop(item)
	local itemdist = nil
	local dist = math.huge
	local function abletocalculate() return lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart") end
    for i,v in pairs(collectionService:GetTagged("ItemDrop")) do
		if v and v.Name == item and abletocalculate() then
			local itemdistance = GetMagnitudeOf2Objects(lplr.Character:WaitForChild("HumanoidRootPart"), v)
			if itemdistance < dist then
			itemdist = v
			dist = itemdistance
		end
		end
	end
	return itemdist
end
local function FindTarget(dist, blockRaycast, includemobs, healthmethod)
	local whitelist = shared.vapewhitelist
	local sort, entity = healthmethod and math.huge or dist or math.huge, {}
	local function abletocalculate() return lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart") end
	local sortmethods = {Normal = function(entityroot, entityhealth) return abletocalculate() and GetMagnitudeOf2Objects(lplr.Character:WaitForChild("HumanoidRootPart"), entityroot) < sort end, Health = function(entityroot, entityhealth) return abletocalculate() and entityhealth < sort end}
	local sortmethod = healthmethod and "Health" or "Normal"
	local function raycasted(entityroot) return abletocalculate() and blockRaycast and game.Workspace:Raycast(entityroot.Position, Vector3.new(0, -2000, 0), store.blockRaycast) or not blockRaycast and true or false end
	for i,v in pairs(playersService:GetPlayers()) do
		if v ~= lplr and abletocalculate() and isAlive(v) and v.Team ~= lplr.Team then
			if not ({whitelist:get(v)})[2] then 
				continue
			end
			if sortmethods[sortmethod](v.Character.HumanoidRootPart, v.Character:GetAttribute("Health") or v.Character.Humanoid.Health) and raycasted(v.Character.HumanoidRootPart) then
				sort = healthmethod and v.Character.Humanoid.Health or GetMagnitudeOf2Objects(lplr.Character:WaitForChild("HumanoidRootPart"), v.Character.HumanoidRootPart)
				entity.Player = v
				entity.Human = true 
				entity.RootPart = v.Character.HumanoidRootPart
				entity.Humanoid = v.Character.Humanoid
			end
		end
	end
	if includemobs then
		local maxdistance = dist or math.huge
		for i,v in pairs(store.pots) do
			if abletocalculate() and v.PrimaryPart and GetMagnitudeOf2Objects(lplr.Character:WaitForChild("HumanoidRootPart"), v.PrimaryPart) < maxdistance then
			entity.Player = {Character = v, Name = "PotEntity", DisplayName = "PotEntity", UserId = 1}
			entity.Human = false
			entity.RootPart = v.PrimaryPart
			entity.Humanoid = {Health = 1, MaxHealth = 1}
			end
		end
		for i,v in pairs(collectionService:GetTagged("DiamondGuardian")) do 
			if v.PrimaryPart and v:FindFirstChild("Humanoid") and v.Humanoid.Health and abletocalculate() then
				if sortmethods[sortmethod](v.PrimaryPart, v.Humanoid.Health) and raycasted(v.PrimaryPart) then
				sort = healthmethod and v.Humanoid.Health or GetMagnitudeOf2Objects(lplr.Character:WaitForChild("HumanoidRootPart"), v.PrimaryPart)
				entity.Player = {Character = v, Name = "DiamondGuardian", DisplayName = "DiamondGuardian", UserId = 1}
				entity.Human = false
				entity.RootPart = v.PrimaryPart
				entity.Humanoid = v.Humanoid
				end
			end
		end
		for i,v in pairs(collectionService:GetTagged("GolemBoss")) do
			if v.PrimaryPart and v:FindFirstChild("Humanoid") and v.Humanoid.Health and abletocalculate() then
				if sortmethods[sortmethod](v.PrimaryPart, v.Humanoid.Health) and raycasted(v.PrimaryPart) then
				sort = healthmethod and v.Humanoid.Health or GetMagnitudeOf2Objects(lplr.Character:WaitForChild("HumanoidRootPart"), v.PrimaryPart)
				entity.Player = {Character = v, Name = "Titan", DisplayName = "Titan", UserId = 1}
				entity.Human = false
				entity.RootPart = v.PrimaryPart
				entity.Humanoid = v.Humanoid
				end
			end
		end
		for i,v in pairs(collectionService:GetTagged("Drone")) do
			local plr = playersService:GetPlayerByUserId(v:GetAttribute("PlayerUserId"))
			if plr and plr ~= lplr and plr.Team and lplr.Team and plr.Team ~= lplr.Team and ({VoidwareFunctions:GetPlayerType(plr)})[2] and abletocalculate() and v.PrimaryPart and v:FindFirstChild("Humanoid") and v.Humanoid.Health then
				if sortmethods[sortmethod](v.PrimaryPart, v.Humanoid.Health) and raycasted(v.PrimaryPart) then
					sort = healthmethod and v.Humanoid.Health or GetMagnitudeOf2Objects(lplr.Character:WaitForChild("HumanoidRootPart"), v.PrimaryPart)
					entity.Player = {Character = v, Name = "Drone", DisplayName = "Drone", UserId = 1}
					entity.Human = false
					entity.RootPart = v.PrimaryPart
					entity.Humanoid = v.Humanoid
				end
			end
		end
		for i,v in pairs(collectionService:GetTagged("Monster")) do
			if v:GetAttribute("Team") ~= lplr:GetAttribute("Team") and abletocalculate() and v.PrimaryPart and v:FindFirstChild("Humanoid") and v.Humanoid.Health then
				if sortmethods[sortmethod](v.PrimaryPart, v.Humanoid.Health) and raycasted(v.PrimaryPart) then
				sort = healthmethod and v.Humanoid.Health or GetMagnitudeOf2Objects(lplr.Character:WaitForChild("HumanoidRootPart"), v.PrimaryPart)
				entity.Player = {Character = v, Name = "Monster", DisplayName = "Monster", UserId = 1}
				entity.Human = false
				entity.RootPart = v.PrimaryPart
				entity.Humanoid = v.Humanoid
			end
		end
	end
    end
    return entity
end
local function isVulnerable(plr) return plr.Humanoid.Health > 0 and not plr.Character.FindFirstChildWhichIsA(plr.Character, "ForceField") end
VoidwareFunctions.GlobaliseObject("isVulnarable", isVulnarable)
local function EntityNearPosition(distance, ignore, overridepos)
	local closestEntity, closestMagnitude = nil, distance
	if entityLibrary.isAlive then
		for i, v in pairs(entityLibrary.entityList) do
			if not v.Targetable then continue end
			if isVulnerable(v) then
				local mag = (entityLibrary.character.HumanoidRootPart.Position - v.RootPart.Position).magnitude
				if overridepos and mag > distance then
					mag = (overridepos - v.RootPart.Position).magnitude
				end
				if mag <= closestMagnitude then
					closestEntity, closestMagnitude = v, mag
				end
			end
		end
		if not ignore then
			for i, v in pairs(game.Workspace:GetChildren()) do
				if v.Name == "Void Enemy Dummy" or v.Name == "Emerald Enemy Dummy" or v.Name == "Diamond Enemy Dummy" or v.Name == "Leather Enemy Dummy" or v.Name == "Regular Enemy Dummy" or v.Name == "Iron Enemy Dummy" then
					if v.PrimaryPart then
						local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
						if overridepos and mag > distance then
							mag = (overridepos - v2.PrimaryPart.Position).magnitude
						end
						if mag <= closestMagnitude then
							closestEntity, closestMagnitude = {Player = {Name = v.Name, UserId = (v.Name == "Duck" and 2020831224 or 1443379645)}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
						end
					end
				end
			end
			for i, v in pairs(collectionService:GetTagged("Monster")) do
				if v.PrimaryPart and v:GetAttribute("Team") ~= lplr:GetAttribute("Team") then
					local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
					if overridepos and mag > distance then
						mag = (overridepos - v2.PrimaryPart.Position).magnitude
					end
					if mag <= closestMagnitude then
						closestEntity, closestMagnitude = {Player = {Name = v.Name, UserId = (v.Name == "Duck" and 2020831224 or 1443379645)}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
					end
				end
			end
			for i, v in pairs(collectionService:GetTagged("GuardianOfDream")) do
				if v.PrimaryPart and v:GetAttribute("Team") ~= lplr:GetAttribute("Team") then
					local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
					if overridepos and mag > distance then
						mag = (overridepos - v2.PrimaryPart.Position).magnitude
					end
					if mag <= closestMagnitude then
						closestEntity, closestMagnitude = {Player = {Name = v.Name, UserId = (v.Name == "Duck" and 2020831224 or 1443379645)}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
					end
				end
			end
			for i, v in pairs(collectionService:GetTagged("DiamondGuardian")) do
				if v.PrimaryPart then
					local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
					if overridepos and mag > distance then
						mag = (overridepos - v2.PrimaryPart.Position).magnitude
					end
					if mag <= closestMagnitude then
						closestEntity, closestMagnitude = {Player = {Name = "DiamondGuardian", UserId = 1443379645}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
					end
				end
			end
			for i, v in pairs(collectionService:GetTagged("GolemBoss")) do
				if v.PrimaryPart then
					local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
					if overridepos and mag > distance then
						mag = (overridepos - v2.PrimaryPart.Position).magnitude
					end
					if mag <= closestMagnitude then
						closestEntity, closestMagnitude = {Player = {Name = "GolemBoss", UserId = 1443379645}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
					end
				end
			end
			for i, v in pairs(collectionService:GetTagged("Drone")) do
				if v.PrimaryPart and tonumber(v:GetAttribute("PlayerUserId")) ~= lplr.UserId then
					local droneplr = playersService:GetPlayerByUserId(v:GetAttribute("PlayerUserId"))
					if droneplr and droneplr.Team == lplr.Team then continue end
					local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
					if overridepos and mag > distance then
						mag = (overridepos - v.PrimaryPart.Position).magnitude
					end
					if mag <= closestMagnitude then -- magcheck
						closestEntity, closestMagnitude = {Player = {Name = "Drone", UserId = 1443379645}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
					end
				end
			end
			for i,v in pairs(game.Workspace:GetChildren()) do
				if v.Name == "InfectedCrateEntity" and v.ClassName == "Model" and v.PrimaryPart then
					local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
					if overridepos and mag > distance then
						mag = (overridepos - v.PrimaryPart.Position).magnitude
					end
					if mag <= closestMagnitude then -- magcheck
						closestEntity, closestMagnitude = {Player = {Name = "InfectedCrateEntity", UserId = 1443379645}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
					end
				end
			end
			for i, v in pairs(store.pots) do
				if v.PrimaryPart then
					local mag = (entityLibrary.character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude
					if overridepos and mag > distance then
						mag = (overridepos - v.PrimaryPart.Position).magnitude
					end
					if mag <= closestMagnitude then -- magcheck
						closestEntity, closestMagnitude = {Player = {Name = "Pot", UserId = 1443379645}, Character = v, RootPart = v.PrimaryPart, JumpTick = tick() + 5, Jumping = false, Humanoid = {HipHeight = 2}}, mag
					end
				end
			end
		end
	end
	return closestEntity
end
VoidwareFunctions.GlobaliseObject("EntityNearPosition", EntityNearPosition)
																											
run(function()
	local lplr = game:GetService("Players").LocalPlayer
	local lplr_gui = lplr.PlayerGui

	local function handle_tablist(ui)
		local frame = ui:FindFirstChild("TabListFrame")
		if frame then
			local plrs_frame = frame:FindFirstChild("4"):FindFirstChild("1")
			if plrs_frame then
				local side_1 = plrs_frame:WaitForChild("2")
				local side_2 = plrs_frame:WaitForChild("3")
				local sides = {side_1, side_2}

				for _, side in pairs(sides) do
					if side then
						--print("Processing side:", side.Name)
						local side_teams = {}
						local side_teams_players = {}

						for _, child in pairs(side:GetChildren()) do
							if child:IsA("Frame") then
								table.insert(side_teams, child)
							end
						end

						for _, team in pairs(side_teams) do
							local team_plrs_list = team:WaitForChild("3")
							local plrs = team_plrs_list:GetChildren()

							for _, plr in pairs(plrs) do
								if plr:IsA("Frame") and plr.Name == "PlayerRowContainer" then
									table.insert(side_teams_players, plr)
								end
							end
						end

						for _, player_row in pairs(side_teams_players) do
							local plr_name_frame = player_row:WaitForChild("Content"):WaitForChild("PlayerRow"):WaitForChild("3"):WaitForChild("PlayerNameContainer"):WaitForChild("3"):WaitForChild("2"):FindFirstChild("PlayerName")

							if plr_name_frame then
								local function extract_name(formatted_text)
									local name = formatted_text:match("</font>%s*(.+)")
									return name
								end

								local current_text = plr_name_frame.Text
								local name = extract_name(current_text)
								local streamer_mode = true

								for _, player in pairs(game:GetService("Players"):GetPlayers()) do
									if player.DisplayName == name then
										streamer_mode = false
										break
									end
								end

								if not streamer_mode then
									local needed_plr
									for i,v in pairs(game:GetService("Players"):GetPlayers()) do
										if game:GetService("Players"):GetPlayers()[i].DisplayName == name then
											needed_plr = game:GetService("Players"):GetPlayers()[i]
										end
									end
									if needed_plr then
										local function get_player_rank(player)
											local rank = shared.vapewhitelist:get(player)
											if rank == 1 then
												return "INF"
											elseif rank == 2 then
												return "Owner"
											else
												return "Normal"
											end
										end
										local rank = get_player_rank(needed_plr)
										local function add_colored_text(existing_text, new_text, color3)
											local r = math.floor(color3.R * 255)
											local g = math.floor(color3.G * 255)
											local b = math.floor(color3.B * 255)
											local new_colored_text = string.format('<font color="rgb(%d,%d,%d)">[%s]</font> ', r, g, b, new_text)
											local updated_text = new_colored_text .. existing_text
											return updated_text
										end

										local tag_data = shared.vapewhitelist:tag(needed_plr)
										if tag_data and #tag_data > 0 then
											if tag_data[1]["text"] == "VOIDWARE USER" then rank = "Normal" end
											local tag_text = tag_data[1]["text"].." - "..rank
											local tag_color = tag_data[1]["color"]
											local updated_text = add_colored_text(current_text, tag_text, tag_color)
											
											if updated_text then
												plr_name_frame.Text = updated_text
											end
										else
											print("Tag data missing for player:", name)
										end
									end
								else
									print("Streamer mode is on for player:", name)
								end
							else
								print("PlayerName frame not found for player row")
							end
						end
					else
						print("Side is nil")
					end
				end
			else
				print("Players frame not found")
			end
		else
			print("TabListFrame not found")
		end
	end

	local function handle_new_ui(ui)
		if tostring(ui) == "TabListScreenGui" then
			handle_tablist(ui)
		end
	end

	lplr_gui.ChildAdded:Connect(handle_new_ui)
end)

run(function()
	local isAlive = function(plr, healthblacklist)
		plr = plr or lplr
		local alive = false 
		if plr.Character and plr.Character.PrimaryPart and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("Head") then 
			alive = true
		end
		if not healthblacklist and alive and plr.Character.Humanoid.Health and plr.Character.Humanoid.Health <= 0 then 
			alive = false
		end
		return alive
	end

    local ExploitDetectionSystem = {
        Connections = {},
        PlayerData = {}
    }
	local ExploitDetectionSystemConfig = {
		DetectionThresholds = {
			TeleportDistance = 400,
			SpeedDistance = 25,
			FlyDistance = 10000,
			CheckInterval = 2.5
		},
		DetectedPlayers = {
			Teleport = {},
			Speed = {},
			InfiniteFly = {},
			Invisibility = {},
			NameSuspicious = {},
			Cached = {}
		},
		CacheEnabled = true,
		TeleportDetection = false,
		InfiniteFlyDetection = false,
		InvisibilityDetection = false,
		NukerDetection = false,
		SpeedDetection = false,
		NameDetection = false
	}

    local DetectionCore = {
        updateCache = function(player, detectionType)
            if not ExploitDetectionSystemConfig.CacheEnabled then return end
            
            local success, cache = pcall(function()
                local file = readfile('vape/Libraries/exploiters.json')
                return file and httpService:JSONDecode(file) or {}
            end)
            
            cache = cache or {}
            cache[player.Name] = cache[player.Name] or {
                DisplayName = player.DisplayName,
                UserId = tostring(player.UserId),
                Detections = {}
            }
            
            if not table.find(cache[player.Name].Detections, detectionType) then
                table.insert(cache[player.Name].Detections, detectionType)
                pcall(function()
                    writefile('vape/Libraries/exploiters.json', httpService:JSONEncode(cache))
                end)
            end
        end,

        isValidTarget = function(player)
            return player ~= lplr and not player:GetAttribute('Spectator') and store.queueType:find('bedwars') ~= nil
        end,

        notify = function(title, message, duration)
            InfoNotification('HackerDetector', message, duration)
            whitelist.customtags[title] = {{text = 'VAPE USER', color = Color3.fromRGB(255, 255, 0)}}
        end
    }

    local DetectionMethods = {
        Teleport = function(player)
            local lastTeleport = player:GetAttribute('LastTeleported') or 0
            local lastPosition = Vector3.zero
            
            table.insert(ExploitDetectionSystem.Connections, player:GetAttributeChangedSignal('LastTeleported'):Connect(function()
                lastTeleport = player:GetAttribute('LastTeleported')
            end))
            
            table.insert(ExploitDetectionSystem.Connections, player.CharacterAdded:Connect(function()
                task.spawn(function()
                    repeat task.wait() until isAlive(player, true)
                    lastPosition = player.Character.HumanoidRootPart.Position
                    
                    task.delay(ExploitDetectionSystemConfig.DetectionThresholds.CheckInterval, function()
                        if isAlive(player, true) and not table.find(ExploitDetectionSystemConfig.DetectedPlayers.Teleport, player) then
                            local distance = (player.Character.HumanoidRootPart.Position - lastPosition).Magnitude
                            if distance >= ExploitDetectionSystemConfig.DetectionThresholds.TeleportDistance and 
                               (player:GetAttribute('LastTeleported') - lastTeleport) == 0 then
                                DetectionCore.notify(player.Name, player.DisplayName .. ' detected using Teleport!', 100)
                                table.insert(ExploitDetectionSystemConfig.DetectedPlayers.Teleport, player)
                                DetectionCore.updateCache(player, 'Teleport')
                            end
                        end
                    end)
                end)
            end))
        end,

        Speed = function(player)
            local lastTeleport = player:GetAttribute('LastTeleported') or 0
            local lastPosition = Vector3.zero
            
            table.insert(ExploitDetectionSystem.Connections, player:GetAttributeChangedSignal('LastTeleported'):Connect(function()
                lastTeleport = player:GetAttribute('LastTeleported')
            end))
            
            task.spawn(function()
                repeat
                    if isAlive(player, true) and not table.find(ExploitDetectionSystemConfig.DetectedPlayers.Speed, player) then
                        local magnitude = (player.Character.HumanoidRootPart.Position - lastPosition).Magnitude
                        local kitDistance = ExploitDetectionSystemConfig.DetectionThresholds.SpeedDistance
                        local threshold = kitDistance + (playerRaycasted(player, Vector3.new(0, -15, 0)) and 0 or 40)
                        
                        if magnitude >= threshold and (player:GetAttribute('LastTeleported') - lastTeleport) ~= 0 then
                            DetectionCore.notify(player.Name, player.DisplayName .. ' detected using Speed!', 60)
                            table.insert(ExploitDetectionSystemConfig.DetectedPlayers.Speed, player)
                            DetectionCore.updateCache(player, 'Speed')
                        end
                        lastPosition = player.Character.HumanoidRootPart.Position
                        task.wait(ExploitDetectionSystemConfig.DetectionThresholds.CheckInterval)
                    end
                until not ExploitDetectionSystem.Enabled or not ExploitDetectionSystem.SpeedToggle.Enabled
            end)
        end,

        InfiniteFly = function(player)
            task.spawn(function()
                repeat
                    if isAlive(player, true) and not table.find(ExploitDetectionSystemConfig.DetectedPlayers.InfiniteFly, player) then
                        local distance = (lplr.Character:WaitForChild("HumanoidRootPart").Position - player.Character.HumanoidRootPart.Position).Magnitude
                        if distance >= ExploitDetectionSystemConfig.DetectionThresholds.FlyDistance and 
                           not playerRaycast(player) then
                            DetectionCore.notify(player.Name, player.DisplayName .. ' detected using Infinite Fly!', 60)
                            table.insert(ExploitDetectionSystemConfig.DetectedPlayers.InfiniteFly, player)
                            DetectionCore.updateCache(player, 'InfiniteFly')
                        end
                        task.wait(ExploitDetectionSystemConfig.DetectionThresholds.CheckInterval)
                    end
                until not ExploitDetectionSystem.Enabled or not ExploitDetectionSystem.InfiniteFlyToggle.Enabled
            end)
        end,

        Invisibility = function(player)
            task.spawn(function()
                repeat
                    if isAlive(player, true) and not table.find(ExploitDetectionSystemConfig.DetectedPlayers.Invisibility, player) then
                        for _, track in pairs(player.Character.Humanoid:GetPlayingAnimationTracks()) do
                            local animId = track.Animation.AnimationId
                            if animId == 'http://www.roblox.com/asset/?id=11335949902' or animId == 'rbxassetid://11335949902' then
                                DetectionCore.notify(player.Name, player.DisplayName .. ' detected using Invisibility!', 60)
                                table.insert(ExploitDetectionSystemConfig.DetectedPlayers.Invisibility, player)
                                DetectionCore.updateCache(player, 'Invisibility')
                            end
                        end
                        task.wait(0.5)
                    end
                until not ExploitDetectionSystem.Enabled or not ExploitDetectionSystem.InvisibilityToggle.Enabled
            end)
        end,

        NameCheck = function(player)
            task.spawn(function()
                local suspiciousNames = {'godsploit', 'alsploit', 'renderintents'}
                local nameLower = player.Name:lower()
                local displayLower = player.DisplayName:lower()
                
                for _, term in ipairs(suspiciousNames) do
                    if nameLower:find(term) or displayLower:find(term) then
                        DetectionCore.notify(player.Name, player.DisplayName .. ' has suspicious ' .. (nameLower:find(term) and 'username' or 'display name') .. ' "' .. term .. '"!', 20)
                        DetectionCore.updateCache(player, 'SuspiciousName')
                        return
                    end
                end
            end)
        end,

        CacheCheck = function(player)
            local success, cache = pcall(function()
                return httpService:JSONDecode(readfile('vape/Libraries/exploiters.json'))
            end)
            
            if success and cache[player.Name] then
                DetectionCore.notify(player.Name, player.DisplayName .. ' found in exploiter cache!', 30)
                table.insert(ExploitDetectionSystemConfig.DetectedPlayers.Cached, player)
            end
        end
    }

    local function initializeDetections(player)
        local toggles = {
            Teleport = ExploitDetectionSystemConfig.TeleportDetection,
            Speed = ExploitDetectionSystemConfig.SpeedDetection,
            InfiniteFly = ExploitDetectionSystemConfig.InfiniteFlyDetection,
            Invisibility = ExploitDetectionSystemConfig.InvisibilityDetection,
            NameCheck = ExploitDetectionSystemConfig.NameDetection,
            CacheCheck = ExploitDetectionSystemConfig.CacheEnabled
        }
        
        for detection, method in pairs(DetectionMethods) do
            if toggles[detection] then
                task.spawn(method, player)
            end
        end
    end

	local CORE_CONNECTIONS = {}

	local function clean(con)
		table.insert(CORE_CONNECTIONS, con)
	end

    ExploitDetectionSystem = vape.Categories.Utility:CreateModule({
        Name = 'HackerDetector',
        Tooltip = 'Advanced exploit detection system for monitoring suspicious player behavior',
        ExtraText = function() return 'Enhanced' end,
        Function = function(enabled)
            ExploitDetectionSystem.Enabled = enabled
            if enabled then
                for _, player in pairs(playersService:GetPlayers()) do
                    if player ~= lplr then
                        initializeDetections(player)
                    end
                end
                clean(playersService.PlayerAdded:Connect(initializeDetections))
            else
                for _, conn in pairs(ExploitDetectionSystem.Connections) do
                    conn:Disconnect()
                end
                table.clear(ExploitDetectionSystem.Connections)
				for _, conn in pairs(CORE_CONNECTIONS) do
                    conn:Disconnect()
                end
				table.clear(CORE_CONNECTIONS)
            end
        end
    })

    ExploitDetectionSystem:CreateToggle({
        Name = 'Teleport',
        Default = true,
        Function = function(call) 
			ExploitDetectionSystemConfig.TeleportDetection = call
		end	
    })
    
    ExploitDetectionSystem:CreateToggle({
        Name = 'InfiniteFly',
        Default = true,
        Function = function(call) 
			ExploitDetectionSystemConfig.InfiniteFlyDetection = call
		end
    })
    
    ExploitDetectionSystem:CreateToggle({
        Name = 'Invisibility',
        Default = true,
        Function = function(call) 
			ExploitDetectionSystemConfig.InvisibilityDetection = call
		end
    })
    
    ExploitDetectionSystem:CreateToggle({
        Name = 'Nuker',
        Default = true,
        Function = function(call) 
			ExploitDetectionSystemConfig.NukerDetection = call
		end
    })
    
    ExploitDetectionSystem:CreateToggle({
        Name = 'Speed',
        Default = true,
        Function = function(call) 
			ExploitDetectionSystemConfig.SpeedDetection = call
		end
    })
    
    ExploitDetectionSystem:CreateToggle({
        Name = 'Name',
        Default = true,
        Function = function(call)
			ExploitDetectionSystemConfig.NameDetection = call
		end
    })
    
    ExploitDetectionSystem:CreateToggle({
        Name = 'Cached detections',
        Tooltip = 'Manages detection cache in vape/Libraries/exploiters.json',
        Default = true,
        Function = function(state) 
            ExploitDetectionSystemConfig.CacheEnabled = state 
        end
    })
end)

run(function()
	local ZoomUnlocker = {Enabled = false}
	local ZoomUnlockerMode = {Value = 'Infinite'}
	local ZoomUnlockerZoom = {Value = 500}
	local ZoomConnection, OldZoom = nil, nil
	ZoomUnlocker = vape.Categories.Utility:CreateModule({
		Name = 'ZoomUnlocker',
        Tooltip = 'Unlocks the abillity to zoom more.',
		Function = function(callback)
			if callback then
				OldZoom = lplr.CameraMaxZoomDistance
				ZoomUnlocker = runService.Heartbeat:Connect(function()
					if ZoomUnlockerMode.Value == 'Infinite' then
						lplr.CameraMaxZoomDistance = 9e9
					else
						lplr.CameraMaxZoomDistance = ZoomUnlockerZoom.Value
					end
				end)
			else
				if ZoomUnlocker then ZoomUnlocker:Disconnect() end
				lplr.CameraMaxZoomDistance = OldZoom
				OldZoom = nil
			end
		end,
        Default = false,
		ExtraText = function()
            return ZoomUnlockerMode.Value
        end
	})
	ZoomUnlockerMode = ZoomUnlocker:CreateDropdown({
		Name = 'Mode',
		List = {
			'Infinite',
			'Custom'
		},
		Tooltip = 'Mode to unlock the zoom.',
		Value = 'Infinite',
		Function = function() end
	})
	ZoomUnlockerZoom = ZoomUnlocker:CreateSlider({
		Name = 'Zoom',
		Min = OldZoom or 13,
		Max = 1000,
		Tooltip = 'Amount to unlock the zoom.',
		Function = function() end,
		Default = 500
	})
end)

--[[run(function()
	local entityLibrary = shared.vapeentity
    local Headless = {Enabled = false};
    Headless = vape.Categories.Utility:CreateModule({
		PerformanceModeBlacklisted = true,
        Name = 'Headless',
        Tooltip = 'Makes your head transparent.',
        Function = function(callback)
            if callback then
				local old, y = nil, nil;
				local x = old;
                task.spawn(function()
                    repeat task.wait()
						entityLibrary.character.Head.Transparency = 1
						y = entityLibrary.character.Head:FindFirstChild('face');
						if y then
							old = y;
							y.Parent = game.Workspace;
						end;
						for _, v in next, entityLibrary.character:GetChildren() do
							if v:IsA'Accessory' then
								v.Handle.Transparency = 0
							end
						end
                    until not Headless.Enabled;
                end);
            else
                entityLibrary.character.Head.Transparency = 0;
				for _, v in next, entityLibrary.character:GetChildren() do
					if v:IsA'Accessory' then
						v.Handle.Transparency = 0;
					end;
				end;
				if old then
					old.Parent = entityLibrary.character.Head;
					old = x;
				end;
            end;
        end,
        Default = false
    })
end)--]]

--[[run(function()
	local NoNameTag = {Enabled = false}
	NoNameTag = vape.Categories.Utility:CreateModule({
		PerformanceModeBlacklisted = true,
		Name = 'NoNameTag',
        Tooltip = 'Removes your NameTag.',
		Function = function(callback)
			if callback then
				RunLoops:BindToHeartbeat('NoNameTag', function()
					pcall(function()
						lplr.Character.Head.Nametag:Destroy()
					end)
				end)
			else
				RunLoops:UnbindFromHeartbeat('NoNameTag')
			end
		end,
        Default = false
	})
end)--]]

run(function()
    local GuiLibrary = shared.GuiLibrary
	local texture_pack = {};
	texture_pack = vape.Categories.Render:CreateModule({
		Name = 'TexturePack',
		Tooltip = 'Customizes your texture pack.',
		Function = function(callback)
			if callback then
				if not shared.VapeSwitchServers then
					warningNotification("TexturePack - Credits", "Credits to melo and star", 1.5)
				end
				if texture_pack_m.Value == 'Noboline' then
					local Players = game:GetService("Players")
					local ReplicatedStorage = game:GetService("ReplicatedStorage")
					local Workspace = game:GetService("Workspace")
					local objs = game:GetObjects("rbxassetid://13988978091")
					local import = objs[1]
					import.Parent = game:GetService("ReplicatedStorage")
					local index = {
						{
							name = "wood_sword",
							offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
							model = import:WaitForChild("Wood_Sword"),
						},
						{
							name = "stone_sword",
							offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
							model = import:WaitForChild("Stone_Sword"),
						},
						{
							name = "iron_sword",
							offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
							model = import:WaitForChild("Iron_Sword"),
						},
						{
							name = "diamond_sword",
							offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
							model = import:WaitForChild("Diamond_Sword"),
						},
						{
							name = "emerald_sword",
							offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
							model = import:WaitForChild("Emerald_Sword"),
						},
						{
							name = "wood_pickaxe",
							offset = CFrame.Angles(math.rad(0), math.rad(-190), math.rad(-95)),
							model = import:WaitForChild("Wood_Pickaxe"),
						},
						{
							name = "stone_pickaxe",
							offset = CFrame.Angles(math.rad(0), math.rad(-190), math.rad(-95)),
							model = import:WaitForChild("Stone_Pickaxe"),
						},
						{
							name = "iron_pickaxe",
							offset = CFrame.Angles(math.rad(0), math.rad(-190), math.rad(-95)),
							model = import:WaitForChild("Iron_Pickaxe"),
						},
						{
							name = "diamond_pickaxe",
							offset = CFrame.Angles(math.rad(0), math.rad(80), math.rad(-95)),
							model = import:WaitForChild("Diamond_Pickaxe"),
						},
						{
							name = "wood_axe",
							offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
							model = import:WaitForChild("Wood_Axe"),
						},
						{
							name = "stone_axe",
							offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
							model = import:WaitForChild("Stone_Axe"),
						},
						{
							name = "iron_axe",
							offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
							model = import:WaitForChild("Iron_Axe"),
						},
						{
							name = "diamond_axe",
							offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(-95)),
							model = import:WaitForChild("Diamond_Axe"),
						},
					}
					local func = Workspace.Camera.Viewmodel.ChildAdded:Connect(function(tool)
						if not tool:IsA("Accessory") then
							return
						end
						for _, v in ipairs(index) do
							if v.name == tool.Name then
								for _, part in ipairs(tool:GetDescendants()) do
									if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then
										part.Transparency = 1
									end
								end
								local model = v.model:Clone()
								model.CFrame = tool.Handle.CFrame * v.offset
								model.CFrame = model.CFrame * CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
								model.Parent = tool
								local weld = Instance.new("WeldConstraint")
								weld.Part0 = model
								weld.Part1 = tool.Handle
								weld.Parent = model
								local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
								for _, part in ipairs(tool2:GetDescendants()) do
									if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then
										part.Transparency = 1
										if part.Name == "Handle" then
											part.Transparency = 0
										end
									end
								end
							end
						end
					end)
				elseif texture_pack_m.Value == 'Aquarium' then
					local objs = game:GetObjects("rbxassetid://14217388022")
					local import = objs[1]
					
					import.Parent = game:GetService("ReplicatedStorage")
					
					local index = {
					
						{
							name = "wood_sword",
							offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
							model = import:WaitForChild("Wood_Sword"),
						},
						
						{
							name = "stone_sword",
							offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
							model = import:WaitForChild("Stone_Sword"),
						},
						
						{
							name = "iron_sword",
							offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
							model = import:WaitForChild("Iron_Sword"),
						},
						
						{
							name = "diamond_sword",
							offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
							model = import:WaitForChild("Diamond_Sword"),
						},
						
						{
							name = "emerald_sword",
							offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
							model = import:WaitForChild("Diamond_Sword"),
						},
						
						{
							name = "Rageblade",
							offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
							model = import:WaitForChild("Diamond_Sword"),
						},
						
					}
					
					local func = Workspace:WaitForChild("Camera").Viewmodel.ChildAdded:Connect(function(tool)
						
						if(not tool:IsA("Accessory")) then return end
						
						for i,v in pairs(index) do
						
							if(v.name == tool.Name) then
							
								for i,v in pairs(tool:GetDescendants()) do
						
									if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
										
										v.Transparency = 1
										
									end
								
								end
							
								local model = v.model:Clone()
								model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
								model.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
								model.Parent = tool
								
								local weld = Instance.new("WeldConstraint",model)
								weld.Part0 = model
								weld.Part1 = tool:WaitForChild("Handle")
								
								local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
								
								for i,v in pairs(tool2:GetDescendants()) do
						
									if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
										
										v.Transparency = 1
										
									end
								
								end
								
								local model2 = v.model:Clone()
								model2.Anchored = false
								model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
								model2.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
								model2.CFrame *= CFrame.new(0.4,0,-.9)
								model2.Parent = tool2
								
								local weld2 = Instance.new("WeldConstraint",model)
								weld2.Part0 = model2
								weld2.Part1 = tool2:WaitForChild("Handle")
							
							end
						
						end
						
					end)
				else
					local Players = game:GetService("Players")
					local ReplicatedStorage = game:GetService("ReplicatedStorage")
					local Workspace = game:GetService("Workspace")
					local objs = game:GetObjects("rbxassetid://14356045010")
					local import = objs[1]
					import.Parent = game:GetService("ReplicatedStorage")
					index = {
						{
							name = "wood_sword",
							offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
							model = import:WaitForChild("Wood_Sword"),
						},
						{
							name = "stone_sword",
							offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
							model = import:WaitForChild("Stone_Sword"),
						},
						{
							name = "iron_sword",
							offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
							model = import:WaitForChild("Iron_Sword"),
						},
						{
							name = "diamond_sword",
							offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
							model = import:WaitForChild("Diamond_Sword"),
						},
						{
							name = "emerald_sword",
							offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(-90)),
							model = import:WaitForChild("Emerald_Sword"),
						}, 
						{
							name = "rageblade",
							offset = CFrame.Angles(math.rad(0),math.rad(-100),math.rad(90)),
							model = import:WaitForChild("Rageblade"),
						}, 
						   {
							name = "fireball",
									offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)),
							model = import:WaitForChild("Fireball"),
						}, 
						{
							name = "telepearl",
									offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)),
							model = import:WaitForChild("Telepearl"),
						}, 
						{
							name = "wood_bow",
							offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)),
							model = import:WaitForChild("Bow"),
						},
						{
							name = "wood_crossbow",
							offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)),
							model = import:WaitForChild("Crossbow"),
						},
						{
							name = "tactical_crossbow",
							offset = CFrame.Angles(math.rad(0), math.rad(180), math.rad(-90)),
							model = import:WaitForChild("Crossbow"),
						},
							{
							name = "wood_pickaxe",
							offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)),
							model = import:WaitForChild("Wood_Pickaxe"),
						},
						{
							name = "stone_pickaxe",
							offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)),
							model = import:WaitForChild("Stone_Pickaxe"),
						},
						{
							name = "iron_pickaxe",
							offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)),
							model = import:WaitForChild("Iron_Pickaxe"),
						},
						{
							name = "diamond_pickaxe",
							offset = CFrame.Angles(math.rad(0), math.rad(80), math.rad(-95)),
							model = import:WaitForChild("Diamond_Pickaxe"),
						},
					   {
								  
							name = "wood_axe",
							offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
							model = import:WaitForChild("Wood_Axe"),
						},
						{
							name = "stone_axe",
							offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
							model = import:WaitForChild("Stone_Axe"),
						},
						{
							name = "iron_axe",
							offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)),
							model = import:WaitForChild("Iron_Axe"),
						 },
						 {
							name = "diamond_axe",
							offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-95)),
							model = import:WaitForChild("Diamond_Axe"),
						 },
					
					
					
					 }
					local func = Workspace:WaitForChild("Camera").Viewmodel.ChildAdded:Connect(function(tool)
						if(not tool:IsA("Accessory")) then return end
						for i,v in pairs(index) do
							if(v.name == tool.Name) then
								for i,v in pairs(tool:GetDescendants()) do
									if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
										v.Transparency = 1
									end
								end
								local model = v.model:Clone()
								model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset
								model.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
								model.Parent = tool
								local weld = Instance.new("WeldConstraint",model)
								weld.Part0 = model
								weld.Part1 = tool:WaitForChild("Handle")
								local tool2 = Players.LocalPlayer.Character:WaitForChild(tool.Name)
								for i,v in pairs(tool2:GetDescendants()) do
									if(v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation")) then
										v.Transparency = 1
									end
								end
								local model2 = v.model:Clone()
								model2.Anchored = false
								model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset
								model2.CFrame *= CFrame.Angles(math.rad(0),math.rad(-50),math.rad(0))
								model2.CFrame *= CFrame.new(.7,0,-.8)
								model2.Parent = tool2
								local weld2 = Instance.new("WeldConstraint",model)
								weld2.Part0 = model2
								weld2.Part1 = tool2:WaitForChild("Handle")
							end
						end
					end)
				end
			end
		end
	})
	texture_pack_m = texture_pack:CreateDropdown({
		Name = 'Mode',
		List = {
			'Noboline',
			'Aquarium',
			'Ocean'
		},
		Default = 'Noboline',
		Tooltip = 'Mode to render the texture pack.',
		Function = function() end;
	});
end)

run(function()
    local TexturePacksV2 = {Enabled = false}
    local TexturePacksV2_Connections = {}
    local TexturePacksV2_GUI_Elements = {
        Material = {Value = "Forcefield"},
        Color = {Hue = 0, Sat = 0, Value = 0},
        GuiSync = {Enabled = false}
    }

    local function refreshChild(child, children)
        if (not child) then return warn("[refreshChild]: invalid child!") end
        if (not table.find(children, child)) then table.insert(children, child) end
        if child.ClassName == "Accessory" then
            for i, v in pairs(child:GetChildren()) do
                if v.ClassName == "MeshPart" then
                    --v.Material = Enum.Material[TexturePacksV2_GUI_Elements.Material.Value]
					v.Material = Enum.Material.ForceField
                    if TexturePacksV2_GUI_Elements.GuiSync.Enabled and TexturePacksV2.Enabled then
                        if shared.RiseMode and GuiLibrary.GUICoreColor and GuiLibrary.GUICoreColorChanged then
                            v.Color = GuiLibrary.GUICoreColor
							TexturePacksV2:Clean(GuiLibrary.GUICoreColorChanged.Event:Connect(function()
                                if TexturePacksV2_GUI_Elements.GuiSync.Enabled then v.Color = GuiLibrary.GUICoreColor end
                            end))
                        else
                            local color = vape.GUIColor
                            v.Color = Color3.fromHSV(color.Hue, color.Sat, color.Value)
							TexturePacksV2:Clean(runService.Heartbeat:Connect(function()
								if TexturePacksV2_GUI_Elements.GuiSync.Enabled and TexturePacksV2.Enabled then
                                    local color = vape.GUIColor
                                    v.Color = Color3.fromHSV(color.Hue, color.Sat, color.Value)
                                    if TexturePacksV2.Enabled then
                                        color = {Hue = h, Sat = s, Value = v}
                                        v.Color = Color3.fromHSV(color.Hue, color.Sat, color.Value)
                                    end
                                end
							end))
                        end
                    else
                        v.Color = Color3.fromHSV(TexturePacksV2_GUI_Elements.Color.Hue, TexturePacksV2_GUI_Elements.Color.Sat, TexturePacksV2_GUI_Elements.Color.Value)
                    end
                end
            end
        end
    end

    local function refreshChildren()
        local children = gameCamera and gameCamera:FindFirstChild("Viewmodel") and gameCamera:FindFirstChild("Viewmodel").ClassName and gameCamera:FindFirstChild("Viewmodel").ClassName == "Model" and gameCamera:FindFirstChild("Viewmodel"):GetChildren() or {}
        for i, v in pairs(children) do refreshChild(v, children) end
    end

    TexturePacksV2 = vape.Categories.Render:CreateModule({
        Name = "TexturePacksV2",
        Function = function(call)
            if call then
                task.spawn(function()
                    repeat
                        refreshChildren()
                        task.wait()
                    until (not TexturePacksV2.Enabled)
                end)
            else
                for i, v in pairs(TexturePacksV2_Connections) do
                    pcall(function() v:Disconnect() end)
                end
            end
        end
    })

    TexturePacksV2.Restart = function()
        if TexturePacksV2.Enabled then
            TexturePacksV2:Toggle(false)
            TexturePacksV2:Toggle(false)
        end
    end

    TexturePacksV2_GUI_Elements.Material = TexturePacksV2:CreateDropdown({
        Name = "Material",
        Function = refreshChildren,
        List = GetEnumItems("Material"),
        Default = "Forcefield"
    })
	TexturePacksV2_GUI_Elements.Material.Object.Visible = false

    TexturePacksV2_GUI_Elements.Color = TexturePacksV2:CreateColorSlider({
        Name = "Color",
        Function = refreshChildren
    })

    TexturePacksV2_GUI_Elements.GuiSync = TexturePacksV2:CreateToggle({
        Name = "GUI Color Sync",
        Function = TexturePacksV2.Restart,
        Default = true
    })
end)

run(function()
	local GuiLibrary = shared.GuiLibrary
	local size_changer = {};
	local size_changer_d = {};
	local size_changer_h = {};
	local size_changer_v = {};
	size_changer = vape.Categories.Misc:CreateModule({
		Name = 'ToolSizeChanger',
		Tooltip = 'Changes the size of the tools.',
		Function = function(callback) 
			if callback then
				pcall(function()
					lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_DEPTH_OFFSET', -(size_changer_d.Value / 10));
					lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_HORIZONTAL_OFFSET', size_changer_h.Value / 10);
					lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_VERTICAL_OFFSET', size_changer_v.Value / 10);
					bedwars.ViewmodelController:playAnimation((10 / 2) + 6);
				end)
			else
				pcall(function()
					lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_DEPTH_OFFSET', 0);
					lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_HORIZONTAL_OFFSET', 0);
					lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_VERTICAL_OFFSET', 0);
					bedwars.ViewmodelController:playAnimation((10 / 2) + 6);
					cam.Viewmodel.RightHand.RightWrist.C1 = cam.Viewmodel.RightHand.RightWrist.C1;
				end)
			end;
		end;
	});
	size_changer_d = size_changer:CreateSlider({
		Name = 'Depth',
		Min = 0,
		Max = 24,
		Function = function(val)
			if size_changer.Enabled then
				pcall(function()
					lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_DEPTH_OFFSET', -(val / 10));
				end)
			end;
		end,
		Default = 10;
	});
	size_changer_h = size_changer:CreateSlider({
		Name = 'Horizontal',
		Min = 0,
		Max = 24,
		Function = function(val)
			if size_changer.Enabled then
				pcall(function()
					lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_HORIZONTAL_OFFSET', (val / 10));
				end)
			end;
		end,
		Default = 10;
	});
	size_changer_v = size_changer:CreateSlider({
		Name = 'Vertical',
		Min = 0,
		Max = 24,
		Function = function(val)
			if size_changer.Enabled then
				pcall(function()
					lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_VERTICAL_OFFSET', (val / 10));
				end)
			end;
		end,
		Default = 0;
	});
end)

run(function()
    local InvisibilitySystem = {
        Enabled = false
    }
	local InvisibilitySystemConnections = {}
	local InvisibilitySystemConfig = {
		ShowRoot = true,
		RootColor = {Hue = 0, Sat = 0, Val = 1}
	}
	local InvisibilitySystemParts = {}
	local InvisibilitySystemAnimation = nil

    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local lplr = Players.LocalPlayer

    local InvisUtils = {
        disableCollisions = function(character)
            InvisibilitySystemParts = {}
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide and part ~= character:FindFirstChild("HumanoidRootPart") then
                    part.CanCollide = false
                    table.insert(InvisibilitySystemParts, part)
                end
            end
        end,

        setupAnimation = function(character)
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://11335949902"
            local humanoid = character:WaitForChild("Humanoid", 5)
            if humanoid then
                local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
                InvisibilitySystemAnimation = animator:LoadAnimation(anim)
                return InvisibilitySystemAnimation
            end
            return nil
        end,

        updateRootAppearance = function(rootPart)
            if rootPart then
                rootPart.Transparency = InvisibilitySystemConfig.ShowRoot and 0.6 or 1
                rootPart.Color = Color3.fromHSV(
                    InvisibilitySystemConfig.RootColor.Hue,
                    InvisibilitySystemConfig.RootColor.Sat,
                    InvisibilitySystemConfig.RootColor.Val
                )
            end
        end,

        toggleSpider = function(enable)
            local spiderButton = vape.Modules.Spider
            if not spiderButton then return end
            
            if enable and spiderButton.Enabled then
                spiderButton:Toggle(false)
                task.spawn(function()
                    repeat task.wait(0.1) until warningNotification
                    warningNotification("Invisibility", "Spider disabled to prevent suffocation.\nRe-enabled when invisibility ends!", 10)
                end)
                return true
            elseif not enable and not spiderButton.Enabled then
                spiderButton:Toggle(false)
                task.spawn(function()
                    repeat task.wait(0.1) until warningNotification
                    warningNotification("Invisibility", "Spider re-enabled!", 10)
                end)
            end
            return false
        end
    }

    local function applyInvisibility()
        local character = lplr.Character
        if not isAlive(lplr, true) or not character then return end

        InvisUtils.disableCollisions(character)
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local anim = InvisibilitySystemAnimation or InvisUtils.setupAnimation(character)

        table.insert(InvisibilitySystemConnections, character.DescendantAdded:Connect(function(part)
            if part:IsA("BasePart") and part.CanCollide and part ~= rootPart then
                part.CanCollide = false
                table.insert(InvisibilitySystemParts, part)
            end
        end))

        local stepConnection = RunService.Stepped:Connect(function()
            for _, part in pairs(InvisibilitySystemParts) do
                part.CanCollide = false
            end
        end)
        table.insert(InvisibilitySystemConnections, stepConnection)

        while InvisibilitySystem.Enabled and isAlive(lplr, true) and anim do
            if vape.Modules.AnimationPlayer.Enabled then
                vape.Modules.AnimationPlayer:Toggle(false)
            end
            
            InvisUtils.updateRootAppearance(rootPart)
            anim:Play(0.1, 9e9, 0.1)
            task.wait(0.1)
        end

        if anim then
            anim:Stop()
            anim:AdjustSpeed(0)
        end
        stepConnection:Disconnect()
    end

    InvisibilitySystem = vape.Categories.Blatant:CreateModule({
        Name = "Invisibility",
        Tooltip = "Renders you less visible via animation and transparency",
        Function = function(enabled)
            InvisibilitySystem.Enabled = enabled
            if enabled then
                local spiderWasDisabled = InvisUtils.toggleSpider(true)
                
                local taskHandle = task.spawn(applyInvisibility)
                table.insert(InvisibilitySystemConnections, lplr.CharacterAdded:Connect(function()
                    task.cancel(taskHandle)
                    taskHandle = task.spawn(applyInvisibility)
                end))

                InvisibilitySystem.Cleanup = function()
                    if spiderWasDisabled then
                        InvisUtils.toggleSpider(false)
                    end
                    if InvisibilitySystemAnimation then
                        InvisibilitySystemAnimation:Stop()
                        InvisibilitySystemAnimation:AdjustSpeed(0)
                    end
                    for _, conn in pairs(InvisibilitySystemConnections) do
                        pcall(conn.Disconnect, conn)
                    end
                    table.clear(InvisibilitySystemConnections)
                    InvisibilitySystemParts = {}
                end
            else
                if InvisibilitySystem.Cleanup then
                    InvisibilitySystem.Cleanup()
                    InvisibilitySystem.Cleanup = nil
                end
            end
        end
    })

    InvisibilitySystem.RootToggle = InvisibilitySystem:CreateToggle({
        Name = "Show Root Part",
        Default = true,
        Function = function(enabled)
			pcall(function()
				InvisibilitySystemConfig.ShowRoot = enabled
				InvisibilitySystem.RootColor.Object.Visible = enabled
			end)
        end,
        Tooltip = "Toggles visibility of the root part"
    })

    InvisibilitySystem.RootColor = InvisibilitySystem:CreateColorSlider({
        Name = "Root Color",
        Function = function(hue, sat, val)
            InvisibilitySystemConfig.RootColor = {Hue = hue, Sat = sat, Val = val}
        end,
        Default = {Hue = 0, Sat = 0, Val = 1},
        Tooltip = "Sets the color of the root part when visible"
    })

    InvisibilitySystem.RootColor.Object.Visible = InvisibilitySystemConfig.ShowRoot
end)

run(function() 
	local TPExploit = {}
	TPExploit = vape.Categories.Blatant:CreateModule({
		Name = "EmptyGameTP",
		Function = function(calling)
			if calling then 
				TPExploit:Toggle()
				local TeleportService = game:GetService("TeleportService")
				local e2 = TeleportService:GetLocalPlayerTeleportData()
				game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer, e2)
			end
		end,
		WhitelistRequired = 1
	}) 
end)

local GuiLibrary = shared.GuiLibrary
shared.slowmode = 0

local isAlive = function(plr, healthblacklist)
	plr = plr or lplr
	local alive = false 
	if plr.Character and plr.Character.PrimaryPart and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("Head") then 
		alive = true
	end
	if not healthblacklist and alive and plr.Character.Humanoid.Health and plr.Character.Humanoid.Health <= 0 then 
		alive = false
	end
	return alive
end
local function fetchTeamMembers()
	local plrs = {}
	for i,v in pairs(game:GetService("Players"):GetPlayers()) do if v.Team == lplr.Team then table.insert(plrs, v) end end
	return plrs
end
local function isEveryoneDead()
	if #fetchTeamMembers() > 0 then
		for i,v in pairs(fetchTeamMembers()) do
			local plr = playersService:FindFirstChild(v.name)
			if plr and isAlive(plr, true) then
				return false
			end
		end
		return true
	else
		return true
	end
end

run(function()
    local anim
	local asset
	local lastPosition
    local NightmareEmote
	NightmareEmote = vape.Categories.World:CreateModule({
		Name = "NightmareEmote",
		Function = function(call)
			if call then
				local l__GameQueryUtil__8
				if (not shared.CheatEngineMode) then 
					l__GameQueryUtil__8 = require(game:GetService("ReplicatedStorage")['rbxts_include']['node_modules']['@easy-games']['game-core'].out).GameQueryUtil 
				else
					local backup = {}; function backup:setQueryIgnored() end; l__GameQueryUtil__8 = backup;
				end
				local l__TweenService__9 = game:GetService("TweenService")
				local player = game:GetService("Players").LocalPlayer
				local p6 = player.Character
				
				if not p6 then NightmareEmote:Toggle() return end
				
				local v10 = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Effects"):WaitForChild("NightmareEmote"):Clone();
				asset = v10
				v10.Parent = game.Workspace
				lastPosition = p6.PrimaryPart and p6.PrimaryPart.Position or Vector3.new()
				
				task.spawn(function()
					while asset ~= nil do
						local currentPosition = p6.PrimaryPart and p6.PrimaryPart.Position
						if currentPosition and (currentPosition - lastPosition).Magnitude > 0.1 then
							asset:Destroy()
							asset = nil
							NightmareEmote:Toggle()
							break
						end
						lastPosition = currentPosition
						v10:SetPrimaryPartCFrame(p6.LowerTorso.CFrame + Vector3.new(0, -2, 0));
						task.wait()
					end
				end)
				
				local v11 = v10:GetDescendants();
				local function v12(p8)
					if p8:IsA("BasePart") then
						l__GameQueryUtil__8:setQueryIgnored(p8, true);
						p8.CanCollide = false;
						p8.Anchored = true;
					end;
				end;
				for v13, v14 in ipairs(v11) do
					v12(v14, v13 - 1, v11);
				end;
				local l__Outer__15 = v10:FindFirstChild("Outer");
				if l__Outer__15 then
					l__TweenService__9:Create(l__Outer__15, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1), {
						Orientation = l__Outer__15.Orientation + Vector3.new(0, 360, 0)
					}):Play();
				end;
				local l__Middle__16 = v10:FindFirstChild("Middle");
				if l__Middle__16 then
					l__TweenService__9:Create(l__Middle__16, TweenInfo.new(12.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1), {
						Orientation = l__Middle__16.Orientation + Vector3.new(0, -360, 0)
					}):Play();
				end;
                anim = Instance.new("Animation")
				anim.AnimationId = "rbxassetid://9191822700"
				anim = p6.Humanoid:LoadAnimation(anim)
				anim:Play()
			else 
                if anim then 
					anim:Stop()
					anim = nil
				end
				if asset then
					asset:Destroy() 
					asset = nil
				end
			end
		end
	})
end)
