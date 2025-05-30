repeat task.wait() until game:IsLoaded()
repeat task.wait() until shared.GuiLibrary

local GuiLibrary = shared.GuiLibrary
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
local entityLibrary = entitylib

local baseDirectory = shared.RiseMode and "rise/" or "vape/"

local runService = game:GetService("RunService")
local RunService = runService
local runservice = runService

local function run(func)
	local suc, err = pcall(function()
		func()
	end)
	if err then warn("[VWUniversal.lua Module Error]: "..tostring(debug.traceback(err))) end
end

task.spawn(function()
	pcall(function()
		local httpService = game:GetService("HttpService")
		local function loadJson(path)
			local suc, res = pcall(function()
				return httpService:JSONDecode(readfile(path))
			end)
			return suc and type(res) == 'table' and res or nil, res
		end

		local function filterStackTrace(stackTrace)
			stackTrace = stackTrace or "Unknown"
			if type(stackTrace) ~= "string" then 
				stackTrace = "INVALID: " .. tostring(stackTrace) 
			end
			if type(stackTrace) == "string" then
				return string.split(stackTrace, "\n") or {stackTrace}
			end
			return {"Unknown"}
		end

		local function saveError(message, stackTrace)
			stackTrace = stackTrace or ''
			local errorLog = {
				Message = tostring(message), 
				StackTrace = filterStackTrace(stackTrace)
			}
			local S_Name = "CONSOLE"
			local main = {}
			if isfile('VW_Error_Log.json') then
				local res = loadJson('VW_Error_Log.json')
				main = res or main
			end
			main["LogInfo"] = {
				Version = "Normal",
				Executor = identifyexecutor and ({identifyexecutor()})[1] or "Unknown executor",
				CheatEngineMode = tostring(shared.CheatEngineMode or "Unknown") 
			}
			local function toTime(timestamp)
				timestamp = timestamp or os.time()
				local dateTable = os.date("*t", timestamp)
				local timeString = string.format("%02d:%02d:%02d", dateTable.hour, dateTable.min, dateTable.sec)
				return timeString
			end
			local function toDate(timestamp)
				timestamp = timestamp or os.time()
				local dateTable = os.date("*t", timestamp)
				local dateString = string.format("%02d/%02d/%02d", dateTable.day, dateTable.month, dateTable.year % 100)
				return dateString
			end
			local function getExecutionTime()
				return {["toTime"] = toTime(), ["toDate"] = toDate()}
			end
			local dateKey = toDate()
			local placeJobKey = tostring(game.PlaceId) .. " | " .. tostring(game.JobId)
			main[dateKey] = main[dateKey] or {}
			main[dateKey][placeJobKey] = main[dateKey][placeJobKey] or {}
			main[dateKey][placeJobKey][S_Name] = main[dateKey][placeJobKey][S_Name] or {}
			table.insert(main[dateKey][placeJobKey][S_Name], {
				Time = getExecutionTime(),
				Data = errorLog
			})
			local success, jsonResult = pcall(function()
				return httpService:JSONEncode(main)
			end)
			if success then
				writefile('VW_Error_Log.json', jsonResult)
			else
				warn("Failed to encode JSON: " .. jsonResult)
			end
		end

		if shared.DEBUGLOGGING then 
			pcall(function()
				shared.DEBUGLOGGING:Disconnect()
			end)
		end
		shared.DEBUGLOGGING = game:GetService("ScriptContext").Error:Connect(function(message, stack, script)
			if not script then
				saveError(message, stack)
			end
		end)
	end)
end)

local vapeConnections = {}
GuiLibrary.SelfDestructEvent.Event:Connect(function()
	for i, v in pairs(vapeConnections) do
		if v.Disconnect then pcall(function() v:Disconnect() end) continue end
		if v.disconnect then pcall(function() v:disconnect() end) continue end
	end
end)

local colors = {
    White = Color3.fromRGB(255, 255, 255),
    Black = Color3.fromRGB(0, 0, 0),
    Red = Color3.fromRGB(255, 0, 0),
    Green = Color3.fromRGB(0, 255, 0),
    Blue = Color3.fromRGB(0, 0, 255),
    Yellow = Color3.fromRGB(255, 255, 0),
    Cyan = Color3.fromRGB(0, 255, 255),
    Magenta = Color3.fromRGB(255, 0, 255),
    Gray = Color3.fromRGB(128, 128, 128),
    DarkGray = Color3.fromRGB(64, 64, 64),
    LightGray = Color3.fromRGB(192, 192, 192),
    Orange = Color3.fromRGB(255, 165, 0),
    Pink = Color3.fromRGB(255, 192, 203),
    Purple = Color3.fromRGB(128, 0, 128),
    Brown = Color3.fromRGB(139, 69, 19),
    LimeGreen = Color3.fromRGB(50, 205, 50),
    NavyBlue = Color3.fromRGB(0, 0, 128),
    Olive = Color3.fromRGB(128, 128, 0),
    Teal = Color3.fromRGB(0, 128, 128),
    Maroon = Color3.fromRGB(128, 0, 0),
    Gold = Color3.fromRGB(255, 215, 0),
    Silver = Color3.fromRGB(192, 192, 192),
    SkyBlue = Color3.fromRGB(135, 206, 235),
    Violet = Color3.fromRGB(238, 130, 238)
}
VoidwareFunctions.GlobaliseObject("ColorTable", colors)
VoidwareFunctions.LoadFunctions("Universal")
VoidwareFunctions.LoadServices()

local lplr = game:GetService("Players").LocalPlayer
local lightingService = game:GetService("Lighting")
local core
pcall(function() core = game:GetService('CoreGui') end)

local newcolor = function() return {Hue = 0, Sat = 0, Value = 0} end

run(function()
    local WeatherMods = { Enabled = false }
    local WeatherMode = { Value = "Snow" }
    local ParticleSpread = { Value = 35 }
    local ParticleRate = { Value = 28 }
    local ParticleHigh = { Value = 100 }

    WeatherMods = vape.Categories.Misc:CreateModule({
        Name = "WeatherMods",
        Tooltip = "Changes the weather (Snow or Rain)",
        Function = function(callback)
            if callback then
                task.spawn(function()
                    local weatherPart = Instance.new("Part")
                    weatherPart.Size = Vector3.new(240, 0.5, 240)
                    weatherPart.Name = "WeatherParticle"
                    weatherPart.Transparency = 1
                    weatherPart.CanCollide = false
                    weatherPart.Position = Vector3.new(0, 120, 286)
                    weatherPart.Anchored = true
                    weatherPart.Parent = game.Workspace

                    local particleEmitter = Instance.new("ParticleEmitter")
                    particleEmitter.VelocitySpread = ParticleSpread.Value
                    particleEmitter.Rate = ParticleRate.Value
                    particleEmitter.EmissionDirection = Enum.NormalId.Bottom
                    particleEmitter.SpreadAngle = Vector2.new(35, 35)
                    particleEmitter.Lifetime = NumberRange.new(8, 14)
                    particleEmitter.Speed = NumberRange.new(12, 20) 
                    particleEmitter.Parent = weatherPart

                    if WeatherMode.Value == "Rain" then
                        particleEmitter.Texture = "rbxassetid://257489726" 
                        particleEmitter.Size = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.2, 0),
                            NumberSequenceKeypoint.new(0.5, 0.3, 0.1),
                            NumberSequenceKeypoint.new(1, 0, 0)
                        })
                        particleEmitter.Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.3, 0),
                            NumberSequenceKeypoint.new(0.5, 0.5, 0),
                            NumberSequenceKeypoint.new(1, 1, 0)
                        })
                        particleEmitter.RotSpeed = NumberRange.new(0) 
                        particleEmitter.Rotation = NumberRange.new(0)
                        particleEmitter.Acceleration = Vector3.new(0, -5, 0) 
                    else
                        particleEmitter.Texture = "rbxassetid://8158344433"
                        particleEmitter.Size = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0, 0),
                            NumberSequenceKeypoint.new(0.039760299026966, 1.3114800453186, 0.32786899805069),
                            NumberSequenceKeypoint.new(0.7554469704628, 0.98360699415207, 0.44038599729538),
                            NumberSequenceKeypoint.new(1, 0, 0)
                        })
                        particleEmitter.Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.16939899325371, 0),
                            NumberSequenceKeypoint.new(0.23365999758244, 0.62841498851776, 0.37158501148224),
                            NumberSequenceKeypoint.new(0.56209099292755, 0.38797798752785, 0.2771390080452),
                            NumberSequenceKeypoint.new(0.90577298402786, 0.51912599802017, 0),
                            NumberSequenceKeypoint.new(1, 1, 0)
                        })
                        particleEmitter.RotSpeed = NumberRange.new(300)
                        particleEmitter.Rotation = NumberRange.new(110)
                        particleEmitter.Acceleration = Vector3.new(0, 0, 0) 
                    end

                    if WeatherMode.Value == "Snow" then
                        local windEmitter = Instance.new("ParticleEmitter")
                        windEmitter.Acceleration = Vector3.new(0, 0, 1)
                        windEmitter.RotSpeed = NumberRange.new(100)
                        windEmitter.VelocitySpread = ParticleSpread.Value
                        windEmitter.Rate = ParticleRate.Value
                        windEmitter.Texture = "rbxassetid://8158344433"
                        windEmitter.EmissionDirection = Enum.NormalId.Bottom
                        windEmitter.Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.16939899325371, 0),
                            NumberSequenceKeypoint.new(0.23365999758244, 0.62841498851776, 0.37158501148224),
                            NumberSequenceKeypoint.new(0.56209099292755, 0.38797798752785, 0.2771390080452),
                            NumberSequenceKeypoint.new(0.90577298402786, 0.51912599802017, 0),
                            NumberSequenceKeypoint.new(1, 1, 0)
                        })
                        windEmitter.Lifetime = NumberRange.new(8, 14)
                        windEmitter.Speed = NumberRange.new(8, 18)
                        windEmitter.Rotation = NumberRange.new(110)
                        windEmitter.SpreadAngle = Vector2.new(35, 35)
                        windEmitter.Size = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0, 0),
                            NumberSequenceKeypoint.new(0.039760299026966, 1.3114800453186, 0.32786899805069),
                            NumberSequenceKeypoint.new(0.7554469704628, 0.98360699415207, 0.44038599729538),
                            NumberSequenceKeypoint.new(1, 0, 0)
                        })
                        windEmitter.Parent = weatherPart
                    end

                    repeat
                        task.wait()
                        if entityLibrary.isAlive then
                            weatherPart.Position = entityLibrary.character.HumanoidRootPart.Position + Vector3.new(0, ParticleHigh.Value, 0)
                        end
                    until not shared.VapeExecuted
                end)
            else
                for _, v in next, game.Workspace:GetChildren() do
                    if v.Name == "WeatherParticle" then
                        v:Remove()
                    end
                end
            end
        end
    })

    ParticleSpread = WeatherMods:CreateSlider({
        Name = "Particle Spread",
        Min = 1,
        Max = 100,
        Function = function(val)
            ParticleSpread.Value = val
            for _, v in next, game.Workspace:GetChildren() do
                if v.Name == "WeatherParticle" then
                    for _, emitter in next, v:GetChildren() do
                        if emitter:IsA("ParticleEmitter") then
                            emitter.VelocitySpread = val
                        end
                    end
                end
            end
        end,
        Default = 35
    })

    ParticleRate = WeatherMods:CreateSlider({
        Name = "Particle Rate",
        Min = 1,
        Max = 100,
        Function = function(val)
            ParticleRate.Value = val
            for _, v in next, game.Workspace:GetChildren() do
                if v.Name == "WeatherParticle" then
                    for _, emitter in next, v:GetChildren() do
                        if emitter:IsA("ParticleEmitter") then
                            emitter.Rate = val
                        end
                    end
                end
            end
        end,
        Default = 28
    })

    ParticleHigh = WeatherMods:CreateSlider({
        Name = "Particle Height",
        Min = 1,
        Max = 200,
        Function = function(val)
            ParticleHigh.Value = val
        end,
        Default = 100
    })

    WeatherMode = WeatherMods:CreateDropdown({
        Name = "Weather Mode",
        List = {"Snow", "Rain"},
        Function = function(val)
            WeatherMode.Value = val
            if WeatherMods.Enabled then
                WeatherMods:Toggle()
                WeatherMods:Toggle()
            end
        end,
        Default = "Snow"
    })
end)

local Maid = {}
Maid.__index = Maid

function Maid.new()
    return setmetatable({Tasks = {}}, Maid)
end

function Maid:Add(task)
    if typeof(task) == "RBXScriptConnection" or (typeof(task) == "Instance" and task.Destroy) or typeof(task) == "function" then
        table.insert(self.Tasks, task)
    end
    return task
end

function Maid:Clean()
    for _, task in ipairs(self.Tasks) do
		pcall(function()
			if typeof(task) == "RBXScriptConnection" then
				task:Disconnect()
			elseif typeof(task) == "Instance" then
				task:Destroy()
			elseif typeof(task) == "function" then
				task()
			end
		end)
    end
	table.clear(self.Tasks)
    self.Tasks = {}
end

local Services = setmetatable({}, {
	__index = function(self, key)
		local suc, service = pcall(game.GetService, game, key)
		if suc and service then
			self[key] = service
			return service
		else
			warn(`[Services] Warning: "{key}" is not a valid Roblox service.`)
			return nil
		end
	end
})

run(function()
    local maid = Maid.new()
    local CustomChat = {Enabled = false}
    local Config = {
        Kill = false,
        ["Bed Break"] = false,
        ["Final Kill"] = false,
        Win = false,
        Defeat = false,
        TypeWrite = false,
        DragEnabled = false,
        CleanOld = false,
        Transparency = 1,
        MaxMessages = 50 
    }
    local scale
    local Players
    local guiService
    local StarterGui
    local RunService
    local TweenService
    local inputService
    local TextChatService
    local UserInputService

    local function brickColorToRGB(brickColor)
        local color3 = brickColor.Color
        return math.floor(color3.R * 255), math.floor(color3.G * 255), math.floor(color3.B * 255)
    end

    local function makeDraggable(gui, window)
        inputService = inputService or Services.UserInputService
        guiService = guiService or Services.GuiService
        scale = scale or vape.gui.ScaledGui:FindFirstChildOfClass("UIScale")
        if not scale then scale = {Scale = 1} end
        local con = gui.InputBegan:Connect(function(inputObj)
            if window and not window.Visible then return end
            if
                (inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch)
                and (inputObj.Position.Y - gui.AbsolutePosition.Y < 40 or window)
            then
                local dragPosition = Vector2.new(
                    gui.AbsolutePosition.X - inputObj.Position.X,
                    gui.AbsolutePosition.Y - inputObj.Position.Y + guiService:GetGuiInset().Y
                ) / scale.Scale

                local changed = inputService.InputChanged:Connect(function(input)
                    if not Config.DragEnabled then return end
                    if input.UserInputType == (inputObj.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
                        local position = input.Position
                        if inputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                            dragPosition = (dragPosition // 3) * 3
                            position = (position // 3) * 3
                        end
                        gui.Position = UDim2.fromOffset((position.X / scale.Scale) + dragPosition.X, (position.Y / scale.Scale) + dragPosition.Y)
                    end
                end)

                local ended
                ended = inputObj.Changed:Connect(function()
                    if inputObj.UserInputState == Enum.UserInputState.End then
                        if changed then
                            changed:Disconnect()
                        end
                        if ended then
                            ended:Disconnect()
                        end
                    end
                end)
            end
        end)
        return con
    end

    local addMessage

    local function typewrite(object, text)
        if not Config.TypeWrite then object.Text = text; return end
        if not object or not text then return end
        if not object:IsA("TextLabel") and not object:IsA("TextBox") then
            warn("typewrite: Object must be a TextLabel or TextBox")
            return
        end

        local function parseChars(str)
            local chars = {}
            local i = 1
            while i <= #str do
                if str:sub(i, i + 4) == "<font" then
                    local tagEnd = str:find(">", i)
                    if tagEnd then
                        table.insert(chars, str:sub(i, tagEnd))
                        i = tagEnd + 1
                    else
                        table.insert(chars, str:sub(i, i))
                        i = i + 1
                    end
                elseif str:sub(i, i + 6) == "</font>" then
                    table.insert(chars, "</font>")
                    i = i + 7
                else
                    table.insert(chars, str:sub(i, i))
                    i = i + 1
                end
            end
            return chars
        end

        object.Text = ""

        local chars = parseChars(text)
        RunService = RunService or Services.RunService
        local index, total = 1, #chars
        local con
        con = RunService.RenderStepped:Connect(function()
            local suc, err = pcall(function()
                if index <= total then
                    object.Text = table.concat(chars, "", 1, index)
                    index = index + 1
                else
                    pcall(function()
                        con:Disconnect()
                    end)
                end
            end)
            if not suc then
                pcall(function()
                    con:Disconnect()
                end)
            end
        end)
    end

    local custom_notify = function(notifType, killerPlayer, killedPlayer, finalKill, data)
        if not (CustomChat.Enabled and addMessage) then return end
        local suc, res = pcall(function()
            if notifType == "kill" then
                if not Config.Kill then return end
                local killedName = killedPlayer and killedPlayer.Name or "Unknown"
                local killerName = killerPlayer and killerPlayer.Name or "Unknown"

                local killedTeamColor = BrickColor.White()
                local killerTeamColor = BrickColor.White()
                if killedPlayer then
                    local killedPlr = Players:GetPlayerByUserId(Players:GetUserIdFromNameAsync(killedName))
                    killedTeamColor = killedPlr and killedPlr.TeamColor or BrickColor.White()
                end
                if killerPlayer then
                    local killerPlr = Players:GetPlayerByUserId(Players:GetUserIdFromNameAsync(killerName))
                    killerTeamColor = killerPlr and killerPlr.TeamColor or BrickColor.White()
                end

                local r1, g1, b1 = brickColorToRGB(killedTeamColor)
                local r2, g2, b2 = brickColorToRGB(killerTeamColor)
                local formattedKilled = string.format('<font color="rgb(%d,%d,%d)">%s</font>', r1, g1, b1, killedName)
                local formattedKiller = string.format('<font color="rgb(%d,%d,%d)">%s</font>', r2, g2, b2, killerName)

                local message = string.format("%s was killed by %s", formattedKilled, formattedKiller)

                if finalKill and Config["Final Kill"] then
                    message = message .. " <font color=\"rgb(0,255,255)\">FINAL KILL!</font>"
                end

                addMessage(message, nil, true)

            elseif notifType == "bedbreak" then
                if not Config["Bed Break"] then return end
                local killerName = killerPlayer and killerPlayer.Name or "Unknown"
                local bedName, bedColor = "Unknown", nil
                if data then
                    bedName = data.Name
                    bedColor = data.Color
                end

                local killerTeamColor = BrickColor.White()
                if killerPlayer then
                    local killerPlr = Players:GetPlayerByUserId(Players:GetUserIdFromNameAsync(killerName))
                    killerTeamColor = killerPlr and killerPlr.TeamColor or BrickColor.White()
                end

                local r, g, b = brickColorToRGB(killerTeamColor)
                local formattedKiller = string.format('<font color="rgb(%d,%d,%d)">%s</font>', r, g, b, killerName)

                local bedR, bedG, bedB = 255, 255, 255
                if bedColor then
                    if typeof(bedColor) == "BrickColor" then
                        bedR, bedG, bedB = brickColorToRGB(bedColor)
                    elseif typeof(bedColor) == "Color3" then
                        bedR, bedG, bedB = math.floor(bedColor.R * 255), math.floor(bedColor.G * 255), math.floor(bedColor.B * 255)
                    end
                end

                local formattedBed = string.format('<font color="rgb(%d,%d,%d)">%s BED</font>', bedR, bedG, bedB, bedName)

                local message = string.format('<font size="18">BED DESTRUCTION > </font>» %s was destroyed by %s', formattedBed, formattedKiller)
                addMessage(message, nil, true)

            elseif notifType == "win" then
                if not Config.Win then return end
                local teamName = data and data.Name or "Unknown"
                local teamColor = data and data.Color or BrickColor.White()

                local teamR, teamG, teamB = 255, 255, 255
                if teamColor then
                    if typeof(teamColor) == "BrickColor" then
                        teamR, teamG, teamB = brickColorToRGB(teamColor)
                    elseif typeof(teamColor) == "Color3" then
                        teamR, teamG, teamB = math.floor(teamColor.R * 255), math.floor(teamColor.G * 255), math.floor(teamColor.B * 255)
                    end
                end

                teamName = teamName.." TEAM"
                local formattedTeam = string.format('<font color="rgb(%d,%d,%d)">%s</font>', teamR, teamG, teamB, teamName)
                local message = string.format('<font size="20" color="rgb(255,255,0)">🏆 VICTORY! %s has won the game!</font>', formattedTeam)
                addMessage(message, nil, true)

            elseif notifType == "defeat" then
                if not Config.Defeat then return end
                local teamName = data and data.Name or "Unknown"
                local teamColor = data and data.Color or BrickColor.White()

                local teamR, teamG, teamB = 255, 255, 255
                if teamColor then
                    if typeof(teamColor) == "BrickColor" then
                        teamR, teamG, teamB = brickColorToRGB(teamColor)
                    elseif typeof(teamColor) == "Color3" then
                        teamR, teamG, teamB = math.floor(teamColor.R * 255), math.floor(bedColor.G * 255), math.floor(bedColor.B * 255)
                    end
                end

                teamName = teamName.." TEAM"
                local formattedTeam = string.format('<font color="rgb(%d,%d,%d)">%s</font>', teamR, teamG, teamB, teamName)
                local message = string.format('<font size="20" color="rgb(128,128,128)">💔 DEFEAT! %s has lost the game.</font>', formattedTeam)
                addMessage(message, nil, true)
            end
        end)

        if not suc then
            warn("Error in custom_notify function: " .. res)
            addMessage("Error in notification. Check console.", nil, true)
        end
    end

	local updateChatVisibility = function() end

    TextChatService = TextChatService or Services.TextChatService
    local old1, old2, old3 = TextChatService.ChatWindowConfiguration.Enabled, TextChatService.ChatInputBarConfiguration.Enabled, TextChatService.ChannelTabsConfiguration.Enabled
    shared.custom_notify = custom_notify

    CustomChat = vape.Categories.World:CreateModule({
        Name = "CustomChat",
        Function = function(call)
            if call then
                Players = Players or Services.Players
                RunService = RunService or Services.RunService
                StarterGui = StarterGui or Services.StarterGui
                TweenService = TweenService or Services.TweenService
                UserInputService = UserInputService or Services.UserInputService

                local core = {
                    font = Enum.Font.SourceSans
                }

                local player = Players.LocalPlayer
                shared.TagRegister = shared.TagRegister or {}
                shared.TagRegister[player] = "<font color='rgb(255,105,180)'>[MEOW]</font>"

                maid:Add(function()
                    TextChatService.ChatWindowConfiguration.Enabled = old1
                    TextChatService.ChatInputBarConfiguration.Enabled = old2
                    TextChatService.ChannelTabsConfiguration.Enabled = old3
                end)

                TextChatService.ChatWindowConfiguration.Enabled = false
                TextChatService.ChatInputBarConfiguration.Enabled = false
                TextChatService.ChannelTabsConfiguration.Enabled = false

                local playerGui = player:WaitForChild("PlayerGui")

                local screenGui = Instance.new("ScreenGui")
                screenGui.Name = "CustomChatGui"
                screenGui.Parent = playerGui
                screenGui.ResetOnSpawn = false
                screenGui.Enabled = true

                maid:Add(screenGui)

                local chatFrame = Instance.new("Frame")
                chatFrame.Size = UDim2.new(0.29, 0, 0.4, 0)
                chatFrame.AnchorPoint = Vector2.new(0, 0.2)
                chatFrame.Position = UDim2.new(0, 5, 0.4, 0)
                chatFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
                chatFrame.BackgroundTransparency = Config.Transparency/10
                chatFrame.BorderSizePixel = 0
                chatFrame.Parent = screenGui

                local chatFrameCorner = Instance.new("UICorner")
                chatFrameCorner.CornerRadius = UDim.new(0, 8)
                chatFrameCorner.Parent = chatFrame

                local scrollingFrame = Instance.new("ScrollingFrame")
                scrollingFrame.Size = UDim2.new(1, -10, 1, -10)
                scrollingFrame.Position = UDim2.new(0, 5, 0, 5)
                scrollingFrame.BackgroundTransparency = 1
                scrollingFrame.BorderSizePixel = 0
                scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
                scrollingFrame.ScrollBarThickness = 0
                scrollingFrame.Parent = chatFrame

                local uiListLayout = Instance.new("UIListLayout")
                uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                uiListLayout.Padding = UDim.new(0, 2)
                uiListLayout.Parent = scrollingFrame

                local inputBox = Instance.new("TextBox")
                inputBox.Size = UDim2.new(0.29, 0, 0, 20)
                inputBox.Position = UDim2.new(0, 5, 0.73, 0)
                inputBox.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
                inputBox.BackgroundTransparency = Config.Transparency/10
                inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                inputBox.PlaceholderText = "Message in Public..."
                inputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
                inputBox.Text = ""
                inputBox.TextSize = 14
                inputBox.Font = Enum.Font.SourceSans
                inputBox.ClearTextOnFocus = true
                inputBox.Parent = screenGui

                maid:Add(makeDraggable(chatFrame, inputBox))

                local inputBoxCorner = Instance.new("UICorner")
                inputBoxCorner.CornerRadius = UDim.new(0, 8)
                inputBoxCorner.Parent = inputBox

                local isChatActive = false
                local fadeTimer = 0
                local FADE_DELAY = 5

                updateChatVisibility = function()
                    if isChatActive then
                        TweenService:Create(chatFrame, TweenInfo.new(0.5), {BackgroundTransparency = Config.Transparency/10}):Play()
                        TweenService:Create(inputBox, TweenInfo.new(0.5), {BackgroundTransparency = Config.Transparency/10, TextTransparency = 0}):Play()
                    else
                        TweenService:Create(chatFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
                        TweenService:Create(inputBox, TweenInfo.new(1), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
                    end
                end

                local function resetFadeTimer()
                    fadeTimer = 0
                    isChatActive = true
                    updateChatVisibility()
                end

                maid:Add(RunService.Heartbeat:Connect(function(deltaTime)
                    if not isChatActive then return end
                    fadeTimer = fadeTimer + deltaTime
                    if fadeTimer >= FADE_DELAY and not inputBox:IsFocused() then
                        isChatActive = false
                        updateChatVisibility()
                    end
                end))

                addMessage = function(message, senderName, isSystem, teamColor, noSeparator)
                    local suc, res = pcall(function()
                        local messages = scrollingFrame:GetChildren()
                        local messageCount = 0
                        for _, child in ipairs(messages) do
                            if child:IsA("Frame") then
                                messageCount = messageCount + 1
                            end
                        end
                        if messageCount >= Config.MaxMessages then
                            for _, child in ipairs(messages) do
                                if child:IsA("Frame") then
                                    child:Destroy()
                                    break 
                                end
                            end
                        end

                        local messageFrame = Instance.new("Frame")
                        messageFrame.Size = UDim2.new(1, -10, 0, 20)
                        messageFrame.Position = UDim2.new(0, 0, 0, 0)
                        messageFrame.BackgroundTransparency = 1
                        messageFrame.Parent = scrollingFrame

                        local senderLabel = Instance.new("TextLabel")
                        senderLabel.Name = "Sender"
                        senderLabel.Size = UDim2.new(0, 0, 1, 0)
                        senderLabel.Position = UDim2.new(0, 0, 0, 0)
                        senderLabel.BackgroundTransparency = 1
                        senderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        senderLabel.TextSize = 16
                        senderLabel.Font = core.font
                        senderLabel.TextXAlignment = Enum.TextXAlignment.Left
                        senderLabel.RichText = true
                        senderLabel.TextTransparency = 1
                        senderLabel.Parent = messageFrame

                        local separatorLabel = Instance.new("TextLabel")
                        separatorLabel.Name = "Separator"
                        separatorLabel.Size = UDim2.new(0, 20, 0, 20)
                        separatorLabel.Position = UDim2.new(0, 0, 0, 0)
                        separatorLabel.BackgroundTransparency = 1
                        separatorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        senderLabel.TextSize = 16
                        separatorLabel.TextSize = 14
                        separatorLabel.Font = core.font
                        separatorLabel.TextXAlignment = Enum.TextXAlignment.Left
                        separatorLabel.RichText = true
                        separatorLabel.Text = "»"
                        separatorLabel.TextTransparency = 1
                        separatorLabel.Parent = messageFrame

                        local messageLabel = Instance.new("TextLabel")
                        messageLabel.Name = "Message"
                        messageLabel.Size = UDim2.new(0, 0, 1, 0)
                        messageLabel.Position = UDim2.new(0, 0, 0, 0)
                        messageLabel.BackgroundTransparency = 1
                        messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        messageLabel.TextSize = 15
                        messageLabel.Font = Enum.Font.FredokaOne
                        messageLabel.TextXAlignment = Enum.TextXAlignment.Left
                        messageLabel.RichText = true
                        messageLabel.TextTransparency = 1
                        messageLabel.Parent = messageFrame

                        for _, child in ipairs(messageFrame:GetChildren()) do
                            if child:IsA("TextLabel") then
                                TweenService:Create(child, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
                            end
                        end

                        task.spawn(function()
                            task.wait(10)
                            if messageFrame and messageFrame.Parent and not isChatActive and Config.CleanOld then
                                for _, child in ipairs(messageFrame:GetChildren()) do
                                    if child:IsA("TextLabel") then
                                        TweenService:Create(child, TweenInfo.new(1), {TextTransparency = 1}):Play()
                                    end
                                end
                                task.wait(1)
                                if messageFrame and messageFrame.Parent then
                                    messageFrame:Destroy()
                                end
                            end
                        end)

                        local final_message, formatted_message

                        if isSystem then
                            senderLabel.Text = ""
                            separatorLabel.Text = "»"
                            final_message = message
                        else
                            local r, g, b = brickColorToRGB(teamColor or BrickColor.White())
                            local formattedSender = string.format('<font color="rgb(%d,%d,%d)">%s</font>', r, g, b, senderName)
                            local formattedMessage = string.format('<font size="12">%s</font>', message)

                            local tagText = ""
                            TagRegister = shared.TagRegister or {}
                            local senderPlayer = Players:GetPlayerByUserId(Players:GetUserIdFromNameAsync(senderName))
                            if senderPlayer then
                                local tags = {}
                                if TagRegister[senderPlayer] then
                                    table.insert(tags, TagRegister[senderPlayer])
                                end

                                local tagsFolder = senderPlayer:FindFirstChild("Tags")
                                if tagsFolder and tagsFolder:IsA("Folder") then
                                    local folderContents = tagsFolder:GetChildren()
                                    local validTags = {}
                                    for _, child in ipairs(folderContents) do
                                        if child:IsA("StringValue") then
                                            table.insert(validTags, {Name = child.Name, Value = child.Value})
                                        end
                                    end

                                    table.sort(validTags, function(a, b)
                                        local aNum, bNum = tonumber(a.Name), tonumber(b.Name)
                                        if aNum and bNum then
                                            return aNum < bNum
                                        else
                                            return a.Name < b.Name
                                        end
                                    end)

                                    for _, tag in ipairs(validTags) do
                                        table.insert(tags, tag.Value)
                                    end
                                end

                                if #tags > 0 then
                                    tagText = table.concat(tags, " ") .. " "
                                end
                            end

                            senderLabel.Text = tagText .. formattedSender
                            separatorLabel.Text = "»"
                            final_message = message
                            formatted_message = formattedMessage
                        end
                        if noSeparator then separatorLabel.Text = '' end

                        senderLabel.TextWrapped = false
                        messageLabel.TextWrapped = true

                        local senderBounds = senderLabel.TextBounds
                        senderLabel.Size = UDim2.new(0, senderBounds.X, 1, 0)

                        separatorLabel.Position = UDim2.new(0, senderBounds.X + 5, 0, 0)

                        local separatorBounds = separatorLabel.TextBounds
                        messageLabel.Position = UDim2.new(0, senderBounds.X + separatorBounds.X + 10, 0.07, 0)
                        messageLabel.Size = UDim2.new(1, -(senderBounds.X + separatorBounds.X), 1, 0)

                        local messageBounds = messageLabel.TextBounds
                        local totalHeight = math.max(20, math.max(senderBounds.Y, messageBounds.Y))
                        messageFrame.Size = UDim2.new(1, -10, 0, totalHeight)

                        local totalHeightCanvas = uiListLayout.AbsoluteContentSize.Y
                        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeightCanvas)
                        scrollingFrame.CanvasPosition = Vector2.new(0, math.max(0, totalHeightCanvas - scrollingFrame.AbsoluteSize.Y))

                        typewrite(messageLabel, final_message)
                        if formatted_message then
                            messageLabel.Text = formatted_message
                        end

                        resetFadeTimer()
                    end)

                    if not suc then
                        warn("Error adding message: " .. res)
                        local errorMessage = "Error displaying message. Check console for details."
                        local errorFrame = Instance.new("Frame")
                        errorFrame.Size = UDim2.new(1, -10, 0, 20)
                        errorFrame.BackgroundTransparency = 1
                        errorFrame.Parent = scrollingFrame

                        local errorSeparator = Instance.new("TextLabel")
                        errorSeparator.Size = UDim2.new(0, 20, 0, 20)
                        errorSeparator.Position = UDim2.new(0, 0, 0, 0)
                        errorSeparator.BackgroundTransparency = 1
                        errorSeparator.TextColor3 = Color3.fromRGB(255, 255, 255)
                        errorSeparator.TextSize = 10
                        errorSeparator.Font = Enum.Font.SourceSans
                        errorSeparator.TextXAlignment = Enum.TextXAlignment.Left
                        errorSeparator.RichText = true
                        errorSeparator.Text = "»"
                        errorSeparator.Parent = errorFrame

                        local errorLabel = Instance.new("TextLabel")
                        errorLabel.Size = UDim2.new(1, -20, 1, 0)
                        errorLabel.Position = UDim2.new(0, 20, 0, 0)
                        errorLabel.BackgroundTransparency = 1
                        errorLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                        errorLabel.TextSize = 16
                        errorLabel.Font = Enum.Font.SourceSans
                        errorLabel.TextXAlignment = Enum.TextXAlignment.Left
                        errorLabel.RichText = true
                        errorLabel.Text = errorMessage
                        errorLabel.TextWrapped = true
                        errorLabel.Parent = errorFrame

                        local errorBounds = errorLabel.TextBounds
                        errorFrame.Size = UDim2.new(1, -10, 0, math.max(20, errorBounds.Y))
                        errorSeparator.Position = UDim2.new(0, 0, 0, (errorBounds.Y - errorSeparator.TextSize) / 2)

                        local totalHeight = uiListLayout.AbsoluteContentSize.Y
                        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
                        scrollingFrame.CanvasPosition = Vector2.new(0, math.max(0, totalHeight - scrollingFrame.AbsoluteSize.Y))
                    end
                end
                shared.addMessage = addMessage

                maid:Add(function()
                    addMessage = nil
                    shared.addMessage = nil
                end)

                local function focused()
                    resetFadeTimer()
                end

                local function focusLost() end

                maid:Add(chatFrame.MouseEnter:Connect(focused))
                maid:Add(chatFrame.MouseLeave:Connect(focusLost))

                maid:Add(inputBox.Focused:Connect(focused))
                maid:Add(inputBox.FocusLost:Connect(focusLost))

                maid:Add(function()
                    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
                end)

                local textChannel = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")

                maid:Add(inputBox.FocusLost:Connect(function(enterPressed)
                    if enterPressed and inputBox.Text ~= "" then
                        local suc, res = pcall(function()
                            local message = inputBox.Text
                            if (message:split(""))[1] == "/" then
                                task.spawn(function() textChannel:SendAsync(message) end)
                            else
                                textChannel:SendAsync(message)
                            end
                            inputBox.Text = ""
                        end)

                        if not suc then
                            warn("Error sending message: " .. res)
                            addMessage("Error sending message. Check console.", nil, true)
                        end
                    end
                end))

                maid:Add(TextChatService.MessageReceived:Connect(function(textChatMessage)
                    local suc, res = pcall(function()
                        local sender = textChatMessage.TextSource and Players:GetPlayerByUserId(textChatMessage.TextSource.UserId)
                        local senderName = sender and sender.Name or "System"
                        local teamColor = sender and sender.TeamColor or nil
                        local message = textChatMessage.Text
                        local isSystem = not textChatMessage.TextSource
                        addMessage(message, senderName, isSystem, teamColor)
                    end)

                    if not suc then
                        warn("Error handling received message: " .. res)
                        addMessage("Error receiving message. Check console.", nil, true)
                    end
                end))

                maid:Add(UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if not gameProcessed and input.KeyCode == Enum.KeyCode.Slash then
                        local suc, res = pcall(function()
                            inputBox:CaptureFocus()
                            inputBox.Text = ""
                        end)

                        if not suc then
                            warn("Error focusing input box: " .. res)
                            addMessage("Error focusing chat input. Check console.", nil, true)
                        end
                    end
                end))

                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)

                addMessage("Custom chat enabled successfully!", "System", true, Color3.fromRGB(255, 255, 255))
            else
                maid:Clean()
            end
        end
    })

    CustomChat:CreateToggle({
        Name = "Typewrite",
        Function = function(call) Config.TypeWrite = call end,
        Default = true
    })
	if shared.VoidDev then
		CustomChat:CreateToggle({
			Name = "Draggable",
			Function = function(call) Config.DragEnabled = call end
		})
	end
    CustomChat:CreateToggle({
        Name = "Clean Old Messages",
        Function = function(call) Config.CleanOld = call end
    })
    CustomChat:CreateSlider({
        Name = "Background Transparency",
        Min = 0,
        Max = 10,
        Default = 1,
        Function = function(val)
            Config.Transparency = val
            if CustomChat.Enabled then
                updateChatVisibility()
            end
        end
    })
    CustomChat:CreateSlider({
        Name = "Max Displayed Messages",
        Min = 10,
        Max = 100,
        Round = 0,
        Default = 50,
        Function = function(val)
            Config.MaxMessages = val
        end
    })
    for i, v in pairs(Config) do
        if i == "TypeWrite" or i == "DragEnabled" or i == "CleanOld" or i == "Transparency" or i == "MaxMessages" then continue end
        CustomChat:CreateToggle({
            Name = "Display "..tostring(i),
            Function = function(call) Config[i] = call end,
            Default = true
        })
    end
end)

run(function() local Shader = {Enabled = false}
	local ShaderColor = {Hue = 0, Sat = 0, Value = 0}
	local ShaderTintSlider
	local ShaderBlur
	local ShaderTint
	local oldlightingsettings = {
		Brightness = lightingService.Brightness,
		ColorShift_Top = lightingService.ColorShift_Top,
		ColorShift_Bottom = lightingService.ColorShift_Bottom,
		OutdoorAmbient = lightingService.OutdoorAmbient,
		ClockTime = lightingService.ClockTime,
		ExposureCompensation = lightingService.ExposureCompensation,
		ShadowSoftness = lightingService.ShadowSoftness,
		Ambient = lightingService.Ambient
	}
	Shader = vape.Categories.Misc:CreateModule({
		Name = "RichShader",
		Tooltip = "pro shader",
		Function = function(callback)
			if callback then 
				task.spawn(function()
					pcall(function()
					ShaderBlur = Instance.new("BlurEffect")
					ShaderBlur.Parent = lightingService
					ShaderBlur.Size = 4 end)
					pcall(function()
						ShaderTint = Instance.new("ColorCorrectionEffect")
						ShaderTint.Parent = lightingService
						ShaderTint.Saturation = -0.2
						ShaderTint.TintColor = Color3.fromRGB(255, 224, 219)
					end)
					pcall(function()
						lightingService.ColorShift_Bottom = Color3.fromHSV(ShaderColor.Hue, ShaderColor.Sat, ShaderColor.Value)
						lightingService.ColorShift_Top = Color3.fromHSV(ShaderColor.Hue, ShaderColor.Sat, ShaderColor.Value)
						lightingService.OutdoorAmbient = Color3.fromHSV(ShaderColor.Hue, ShaderColor.Sat, ShaderColor.Value)
						lightingService.ClockTime = 8.7
						lightingService.FogColor = Color3.fromHSV(ShaderColor.Hue, ShaderColor.Sat, ShaderColor.Value)
						lightingService.FogEnd = 1000
						lightingService.FogStart = 0
						lightingService.ExposureCompensation = 0.24
						lightingService.ShadowSoftness = 0
						lightingService.Ambient = Color3.fromRGB(59, 33, 27)
					end)
				end)
			else
				pcall(function() ShaderBlur:Destroy() end)
				pcall(function() ShaderTint:Destroy() end)
				pcall(function()
				    lightingService.Brightness = oldlightingsettings.Brightness
				    lightingService.ColorShift_Top = oldlightingsettings.ColorShift_Top
				    lightingService.ColorShift_Bottom = oldlightingsettings.ColorShift_Bottom
				    lightingService.OutdoorAmbient = oldlightingsettings.OutdoorAmbient
				    lightingService.ClockTime = oldlightingsettings.ClockTime
				    lightingService.ExposureCompensation = oldlightingsettings.ExposureCompensation
				    lightingService.ShadowSoftness = oldlightingsettings.ShadowSoftnesss
				    lightingService.Ambient = oldlightingsettings.Ambient
				    lightingService.FogColor = oldthemesettings.FogColor
				    lightingService.FogStart = oldthemesettings.FogStart
				    ightingService.FogEnd = oldthemesettings.FogEnd
				end)
			end
		end
	})	
	ShaderColor = Shader:CreateColorSlider({
		Name = "Main Color",
		Function = function(h, s, v)
			if Shader.Enabled then 
				pcall(function()
					lightingService.ColorShift_Bottom = Color3.fromHSV(h, s, v)
					lightingService.ColorShift_Top = Color3.fromHSV(h, s, v)
					lightingService.OutdoorAmbient = Color3.fromHSV(h, s, v)
					lightingService.FogColor = Color3.fromHSV(h, s, v)
				end)
			end
		end
	})
end)

run(function() local chatDisable = {Enabled = false}
	local chatVersion = function()
		if game.Chat:GetChildren()[1] then return true else return false end
	end
	chatDisable = vape.Categories.Misc:CreateModule({
		Name = "ChatDisable",
		Tooltip = "Disables the chat",
		Function = function(callback)
			if callback then
				if chatVersion() then
					lplr.PlayerGui.Chat.Enabled = false
					game:GetService("CoreGui").TopBarApp.TopBarFrame.LeftFrame.ChatIcon.Visible = false
				elseif (not chatVersion()) then
					game.CoreGui.ExperienceChat.Enabled = false
					game:GetService("CoreGui").TopBarApp.TopBarFrame.LeftFrame.ChatIcon.Visible = false
					textChatService.ChatInputBarConfiguration.Enabled = false
					textChatService.BubbleChatConfiguration.Enabled = false
				end
			else
				if chatVersion() then
					lplr.PlayerGui.Chat.Enabled = true
					core.TopBarApp.TopBarFrame.LeftFrame.ChatIcon.Visible = true
				else
					gcore.ExperienceChat.Enabled = true
					core.TopBarApp.TopBarFrame.LeftFrame.ChatIcon.Visible = true
					textChatService.ChatInputBarConfiguration.Enabled = true
					textChatService.BubbleChatConfiguration.Enabled = true
				end
			end
		end
	})
end)

run(function() local CloudMods = {}
	local CloudNeon = {}
	local clouds = {}
	local CloudColor = newcolor()
	local cloudFunction = function(cloud)
		pcall(function()
			cloud.Color = Color3.fromHSV(CloudColor.Hue, CloudColor.Sat, CloudColor.Value)
			cloud.Material = (CloudNeon.Enabled and Enum.Material.Neon or Enum.Material.SmoothPlastic) 
		end)
	end
	CloudMods = vape.Categories.Misc:CreateModule({
		Name = 'CloudMods',
		Tooltip = 'Recolorizes the clouds to your liking.',
		Function = function(calling)
			if calling then 
				clouds = game.Workspace:WaitForChild('Clouds'):GetChildren()
				if not CloudMods.Enabled then 
					return 
				end
				for i,v in next, clouds do 
					cloudFunction(v)
				end
				CloudMods:Clean(game.Workspace.Clouds.ChildAdded:Connect(function(cloud)
					cloudFunction(cloud)
					table.insert(clouds, cloud)
				end))
			else 
				for i,v in next, clouds do 
					pcall(function() 
						v.Color = Color3.fromRGB(255, 255, 255)
						v.Material = Enum.Material.SmoothPlastic
					end) 
				end
			end
		end
	})
	CloudColor = CloudMods:CreateColorSlider({
		Name = 'Color',
		Function = function()
			for i,v in next, clouds do 
				cloudFunction(v)
			end
		end
	})
	CloudNeon = CloudMods:CreateToggle({
		Name = 'Neon',
		Function = function() 
			for i,v in next, clouds do 
				cloudFunction(v)
			end
		end
	})
end)

run(function() 
	local RestartVoidware = {}
	RestartVoidware = vape.Categories.Blatant:CreateModule({
		Name = 'Restart',
		Function = function(calling)
			if calling then 
				RestartVoidware:Toggle()
				vape:Uninject()
				task.wait(0.1)
				loadstring(game:HttpGet("https://raw.githubusercontent.com/randombackup1293/PastewareRewrite/main/NewMainScript.lua", true))()
			end
		end
	}) 
end)

run(function() local ReinstallProfiles = {}
	ReinstallProfiles = vape.Categories.Blatant:CreateModule({
		Name = 'ReinstallProfiles',
		Function = function(calling)
			if calling then 
				ReinstallProfiles:Toggle()
				GuiLibrary:Uninject()
				delfile(baseDirectory..'Libraries/profilesinstalled4.txt')
				delfolder(baseDirectory..'Profiles')
				pload('NewMainScript.lua', true)
			end
		end
	}) 
end)
local vec3 = function(a, b, c) return Vector3.new(a, b, c) end
run(function() 
	local CustomJump = {Enabled = false}
	local CustomJumpMode = {Value = "Normal"}
	local CustomJumpVelocity = {Value = 50}
	local UIS_Connection = {Disconnect = function() end}
	CustomJump = vape.Categories.Blatant:CreateModule({
		Name = "InfJump",
        Tooltip = "Customizes your jumping ability",
		Function = function(callback)
			if callback then
				UIS_Connection = game:GetService("UserInputService").JumpRequest:Connect(function()
					if CustomJumpMode.Value == "Normal" then
						entityLibrary.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
					elseif CustomJumpMode.Value == "Velocity" then
						entityLibrary.character.HumanoidRootPart.Velocity += vec3(0,CustomJumpVelocity.Value,0)
					end 
				end)
			else
				pcall(function()
					UIS_Connection:Disconnect()
				end)
			end
		end,
		ExtraText = function()
			return CustomJumpMode.Value
		end
	})
	CustomJumpMode = CustomJump:CreateDropdown({
		Name = "Mode",
		List = {
			"Normal",
			"Velocity"
		},
		Function = function() end,
	})
	CustomJumpVelocity = CustomJump:CreateSlider({
		Name = "Velocity",
		Min = 1,
		Max = 100,
		Function = function() end,
		Default = 50
	})
end)

run(function()
	local AnimationChanger = {Enabled = false}
	local AnimFreeze = {Enabled = false}
	local AnimRun = {Value = "Robot"}
	local AnimWalk = {Value = "Robot"}
	local AnimJump = {Value = "Robot"}
	local AnimFall = {Value = "Robot"}
    local AnimClimb = {Value = "Robot"}
	local AnimIdle = {Value = "Robot"}
	local AnimIdleB = {Value = "Robot"}
	local Animate
	local oldanimations = {}
	local RunAnimations = {}
	local WalkAnimations = {}
	local FallAnimations = {}
	local JumpAnimations = {}
    local ClimbAnimations = {}
	local IdleAnimations = {}
	local IdleAnimationsB = {}
	local AnimList = {
		RunAnim = {
		    ["Cartoony"] = "http://www.roblox.com/asset/?id=10921082452",
		    ["Levitation"] = "http://www.roblox.com/asset/?id=10921135644",
		    ["Robot"] = "http://www.roblox.com/asset/?id=10921250460",
		    ["Stylish"] = "http://www.roblox.com/asset/?id=10921276116",
		    ["Superhero"] = "http://www.roblox.com/asset/?id=10921291831",
		    ["Zombie"] = "http://www.roblox.com/asset/?id=616163682",
		    ["Ninja"] = "http://www.roblox.com/asset/?id=10921157929",
		    ["Knight"] = "http://www.roblox.com/asset/?id=10921121197",
		    ["Mage"] = "http://www.roblox.com/asset/?id=10921148209",
		    ["Pirate"] = "http://www.roblox.com/asset/?id=750783738",
		    ["Elder"] = "http://www.roblox.com/asset/?id=10921104374",
		    ["Toy"] = "http://www.roblox.com/asset/?id=10921306285",
	    	["Bubbly"] = "http://www.roblox.com/asset/?id=10921057244",
	    	["Astronaut"] = "http://www.roblox.com/asset/?id=10921039308",
	    	["Vampire"] = "http://www.roblox.com/asset/?id=10921320299",
	    	["Werewolf"] = "http://www.roblox.com/asset/?id=10921336997",
	    	["Rthro"] = "http://www.roblox.com/asset/?id=10921261968",
	    	["Oldschool"] = "http://www.roblox.com/asset/?id=10921240218",
	    	["Toilet"] = "http://www.roblox.com/asset/?id=4417979645",
		    ["Rthro Heavy Run"] = "http://www.roblox.com/asset/?id=3236836670",
            ["Tryhard"] = "http://www.roblox.com/asset/?id=10921157929",
            ["Goofy"] = "http://www.roblox.com/asset/?id=4417979645",
            ["Tamar"] = "http://www.roblox.com/asset/?id=10921306285"
	    },
	    WalkAnim = {
	    	["Cartoony"] = "http://www.roblox.com/asset/?id=10921082452",
    		["Levitation"] = "http://www.roblox.com/asset/?id=10921140719",
		    ["Robot"] = "http://www.roblox.com/asset/?id=10921255446",
		    ["Stylish"] = "http://www.roblox.com/asset/?id=10921283326",
		    ["Superhero"] = "http://www.roblox.com/asset/?id=10921298616",
		    ["Zombie"] = "http://www.roblox.com/asset/?id=10921355261",
		    ["Ninja"] = "http://www.roblox.com/asset/?id=10921162768",
		    ["Knight"] = "http://www.roblox.com/asset/?id=10921127095",
		    ["Mage"] = "http://www.roblox.com/asset/?id=10921152678",
		    ["Pirate"] = "http://www.roblox.com/asset/?id=750785693",
            ["Elder"] = "http://www.roblox.com/asset/?id=10921111375",
    		["Toy"] = "http://www.roblox.com/asset/?id=10921312010",
    		["Bubbly"] = "http://www.roblox.com/asset/?id=10980888364",
    		["Astronaut"] = "http://www.roblox.com/asset/?id=10921046031",
    		["Vampire"] = "http://www.roblox.com/asset/?id=10921326949",
    	  	["Werewolf"] = "http://www.roblox.com/asset/?id=10921342074",
    		["Rthro"] = "http://www.roblox.com/asset/?id=10921269718",
    		["Oldschool"] = "http://www.roblox.com/asset/?id=10921244891",
		    ["Ud'zal"] = "http://www.roblox.com/asset/?id=3303162967",
            ["Tryhard"] = "http://www.roblox.com/asset/?id=10921162768",
            ["Goofy"] = "http://www.roblox.com/asset/?id=10921162768",
            ["Tamar"] = "http://www.roblox.com/asset/?id=10921312010"
	    },
        FallAnim = {
            ["Cartoony"] = "http://www.roblox.com/asset/?id=10921077030",
            ["Levitation"] = "http://www.roblox.com/asset/?id=10921136539",
            ["Robot"] = "http://www.roblox.com/asset/?id=10921251156",
            ["Stylish"] = "http://www.roblox.com/asset/?id=10921278648",
            ["Superhero"] = "http://www.roblox.com/asset/?id=10921293373",
            ["Zombie"] = "http://www.roblox.com/asset/?id=10921350320",
            ["Ninja"] = "http://www.roblox.com/asset/?id=10921159222",
            ["Knight"] = "http://www.roblox.com/asset/?id=10921122579",
            ["Mage"] = "http://www.roblox.com/asset/?id=10921148939",
            ["Pirate"] = "http://www.roblox.com/asset/?id=750780242",
            ["Elder"] = "http://www.roblox.com/asset/?id=10921105765",
            ["Toy"] = "http://www.roblox.com/asset/?id=10921307241",
            ["Bubbly"] = "http://www.roblox.com/asset/?id=10921061530",
            ["Astronaut"] = "http://www.roblox.com/asset/?id=10921040576",
            ["Vampire"] = "http://www.roblox.com/asset/?id=10921321317",
            ["Werewolf"] = "http://www.roblox.com/asset/?id=10921337907",
            ["Rthro"] = "http://www.roblox.com/asset/?id=10921262864",
            ["Oldschool"] = "http://www.roblox.com/asset/?id=10921241244",
            ["Tryhard"] = "http://www.roblox.com/asset/?id=10921136539",
            ["Goofy"] = "http://www.roblox.com/asset/?id=10921136539",
            ["Tamar"] = "http://www.roblox.com/asset/?id=10921136539"
        },
        JumpAnim = {
            ["Cartoony"] = "http://www.roblox.com/asset/?id=10921078135",
            ["Levitation"] = "http://www.roblox.com/asset/?id=10921137402",
            ["Robot"] = "http://www.roblox.com/asset/?id=10921252123",
            ["Stylish"] = "http://www.roblox.com/asset/?id=10921279832",
            ["Superhero"] = "http://www.roblox.com/asset/?id=10921294559",
            ["Zombie"] = "http://www.roblox.com/asset/?id=10921351278",
            ["Ninja"] = "http://www.roblox.com/asset/?id=10921160088",
            ["Knight"] = "http://www.roblox.com/asset/?id=10921123517",
            ["Mage"] = "http://www.roblox.com/asset/?id=10921149743",
            ["Pirate"] = "http://www.roblox.com/asset/?id=750782230",
            ["Elder"] = "http://www.roblox.com/asset/?id=10921107367",
            ["Toy"] = "http://www.roblox.com/asset/?id=10921308158",
            ["Bubbly"] = "http://www.roblox.com/asset/?id=10921062673",
            ["Astronaut"] = "http://www.roblox.com/asset/?id=10921042494",
            ["Vampire"] = "http://www.roblox.com/asset/?id=10921322186",
            ["Werewolf"] = "http://www.roblox.com/asset/?id=1083218792",
            ["Rthro"] = "http://www.roblox.com/asset/?id=10921263860",
            ["Oldschool"] = "http://www.roblox.com/asset/?id=10921242013",
            ["Tryhard"] = "http://www.roblox.com/asset/?id=10921137402",
            ["Goofy"] = "http://www.roblox.com/asset/?id=10921137402",
            ["Tamar"] = "http://www.roblox.com/asset/?id=10921242013"
        },
        ClimbAnim = {
            ["Cartoony"] = "http://www.roblox.com/asset/?id=10921070953",
            ["Levitation"] = "http://www.roblox.com/asset/?id=10921132092",
            ["Robot"] = "http://www.roblox.com/asset/?id=10921245669",
            ["Stylish"] = "http://www.roblox.com/asset/?id=10921525854",
            ["Superhero"] = "http://www.roblox.com/asset/?id=10921346417",
            ["Zombie"] = "http://www.roblox.com/asset/?id=10921469135",
            ["Ninja"] = "http://www.roblox.com/asset/?id=10920908048",
            ["Knight"] = "http://www.roblox.com/asset/?id=10921116196",
            ["Mage"] = "http://www.roblox.com/asset/?id=10921143404",
            ["Pirate"] = "http://www.roblox.com/asset/?id=750779899",
            ["Elder"] = "http://www.roblox.com/asset/?id=10921100400",
            ["Toy"] = "http://www.roblox.com/asset/?id=10921300839",
            ["Bubbly"] = "http://www.roblox.com/asset/?id=10921053544",
            ["Astronaut"] = "http://www.roblox.com/asset/?id=10921032124",
            ["Vampire"] = "http://www.roblox.com/asset/?id=10921314188",
            ["Werewolf"] = "http://www.roblox.com/asset/?id=10921329322",
            ["Rthro"] = "http://www.roblox.com/asset/?id=10921257536",
            ["Oldschool"] = "http://www.roblox.com/asset/?id=10921229866"
        },
        Animation1 = {
            ["Cartoony"] = "http://www.roblox.com/asset/?id=10921071918",
            ["Levitation"] = "http://www.roblox.com/asset/?id=10921132962",
            ["Robot"] = "http://www.roblox.com/asset/?id=10921248039",
            ["Stylish"] = "http://www.roblox.com/asset/?id=10921272275",
            ["Superhero"] = "http://www.roblox.com/asset/?id=10921288909",
            ["Zombie"] = "http://www.roblox.com/asset/?id=10921344533",
            ["Ninja"] = "http://www.roblox.com/asset/?id=10921155160",
            ["Knight"] = "http://www.roblox.com/asset/?id=10921117521",
            ["Mage"] = "http://www.roblox.com/asset/?id=10921144709",
            ["Pirate"] = "http://www.roblox.com/asset/?id=750781874",
            ["Elder"] = "http://www.roblox.com/asset/?id=10921101664",
            ["Toy"] = "http://www.roblox.com/asset/?id=10921301576",
            ["Bubbly"] = "http://www.roblox.com/asset/?id=10921054344",
            ["Astronaut"] = "http://www.roblox.com/asset/?id=10921034824",
            ["Vampire"] = "http://www.roblox.com/asset/?id=10921315373",
            ["Werewolf"] = "http://www.roblox.com/asset/?id=10921330408",
            ["Rthro"] = "http://www.roblox.com/asset/?id=10921258489",
            ["Oldschool"] = "http://www.roblox.com/asset/?id=10921230744",
            ["Toilet"] = "http://www.roblox.com/asset/?id=4417977954",
            ["Ud'zal"] = "http://www.roblox.com/asset/?id=3303162274",
            ["Tryhard"] = "http://www.roblox.com/asset/?id=10921301576",
            ["Goofy"] = "http://www.roblox.com/asset/?id=4417977954",
            ["Tamar"] = "http://www.roblox.com/asset/?id=10921034824"
        },
        Animation2 = {
            ["Cartoony"] = "http://www.roblox.com/asset/?id=10921072875",
            ["Levitation"] = "http://www.roblox.com/asset/?id=10921133721",
            ["Robot"] = "http://www.roblox.com/asset/?id=10921248831",
            ["Stylish"] = "http://www.roblox.com/asset/?id=10921273958",
            ["Superhero"] = "http://www.roblox.com/asset/?id=10921290167",
            ["Zombie"] = "http://www.roblox.com/asset/?id=10921345304",
            ["Ninja"] = "http://www.roblox.com/asset/?id=10921155867",
            ["Knight"] = "http://www.roblox.com/asset/?id=10921118894",
            ["Mage"] = "http://www.roblox.com/asset/?id=10921145797",
            ["Pirate"] = "http://www.roblox.com/asset/?id=750782770",
            ["Elder"] = "http://www.roblox.com/asset/?id=10921102574",
            ["Toy"] = "http://www.roblox.com/asset/?id=10921302207",
            ["Bubbly"] = "http://www.roblox.com/asset/?id=10921055107",
            ["Astronaut"] = "http://www.roblox.com/asset/?id=10921036806",
            ["Vampire"] = "http://www.roblox.com/asset/?id=10921316709",
            ["Werewolf"] = "http://www.roblox.com/asset/?id=10921333667",
            ["Rthro"] = "http://www.roblox.com/asset/?id=10921259953",
            ["Oldschool"] = "http://www.roblox.com/asset/?id=10921232093",
            ["Toilet"] = "http://www.roblox.com/asset/?id=4417978624",
            ["Ud'zal"] = "http://www.roblox.com/asset/?id=3303162549",
            ["Tryhard"] = "http://www.roblox.com/asset/?id=10921302207",
            ["Goofy"] = "http://www.roblox.com/asset/?id=4417978624",
            ["Tamar"] = "http://www.roblox.com/asset/?id=10921036806"
        }
    }
    local function AnimateCharacter()
        local animate = lplr.Character:FindFirstChild("Animate") 
        if AnimFreeze.Enabled then
            animate.Enabled = false
        end
        animate.run.RunAnim.AnimationId = AnimList.RunAnim[AnimRun.Value]
        task.wait(4.5)
        animate.walk.WalkAnim.AnimationId = AnimList.WalkAnim[AnimWalk.Value]
        task.wait(4.5)
        animate.fall.FallAnim.AnimationId = AnimList.FallAnim[AnimFall.Value]
        task.wait(4.5)
        animate.jump.JumpAnim.AnimationId = AnimList.JumpAnim[AnimJump.Value]
        task.wait(4.5)
        animate.climb.ClimbAnim.AnimationId = AnimList.Animation1[AnimClimb.Value]
        task.wait(4.5)
        animate.idle.Animation1.AnimationId = AnimList.Animation1[AnimIdle.Value]
        task.wait(4.5)
        animate.idle.Animation2.AnimationId = AnimList.Animation2[AnimIdleB.Value]
        task.wait(4.5)
    end
	AnimationChanger = vape.Categories.Misc:CreateModule({
		Name = "AnimationChanger",
		Function = function(callback)
			if callback then
				AnimationChanger:Clean(runService.Heartbeat:Connect(function()
					pcall(function()
				        task.spawn(function()
					        if not entityLibrary.isAlive then repeat task.wait(10) until entityLibrary.isAlive end
							AnimationChanger:Clean(lplr.CharacterAdded:Connect(function()
					        	if not entityLibrary.isAlive then repeat task.wait(10) until entityLibrary.isAlive end
					            pcall(AnimateCharacter)
					        end))                   
					        pcall(AnimateCharacter)
                        end)
                    end)
				end))
			else
				pcall(function() Animate.Enabled = true end)
				Animate = nil
			end
		end,
		Tooltip = "customize your animations freely."
	})
	for i,v in pairs(AnimList.RunAnim) do table.insert(RunAnimations, i) end
	for i,v in pairs(AnimList.WalkAnim) do table.insert(WalkAnimations, i) end
	for i,v in pairs(AnimList.FallAnim) do table.insert(FallAnimations, i) end
	for i,v in pairs(AnimList.JumpAnim) do table.insert(JumpAnimations, i) end
	for i,v in pairs(AnimList.ClimbAnim) do table.insert(ClimbAnimations, i) end
	for i,v in pairs(AnimList.Animation1) do table.insert(IdleAnimations, i) end
	for i,v in pairs(AnimList.Animation2) do table.insert(IdleAnimationsB, i) end
	AnimRun = AnimationChanger:CreateDropdown({
		Name = "Run",
		List = RunAnimations,
		Function = function() 
			if AnimationChanger.Enabled then
				AnimationChanger:Toggle(false)
				AnimationChanger:Toggle(false)
			end
		end
	})
	AnimWalk = AnimationChanger:CreateDropdown({
		Name = "Walk",
		List = WalkAnimations,
		Function = function() 
			if AnimationChanger.Enabled then
				AnimationChanger:Toggle(false)
				AnimationChanger:Toggle(false)
			end
		end
	})
	AnimFall = AnimationChanger:CreateDropdown({
		Name = "Fall",
		List = FallAnimations,
		Function = function() 
			if AnimationChanger.Enabled then
				AnimationChanger:Toggle(false)
				AnimationChanger:Toggle(false)
			end
		end
	})
	AnimJump = AnimationChanger:CreateDropdown({
		Name = "Jump",
		List = JumpAnimations,
		Function = function() 
			if AnimationChanger.Enabled then
				AnimationChanger:Toggle(false)
				AnimationChanger:Toggle(false)
			end
		end
	})
	AnimIdle = AnimationChanger:CreateDropdown({
		Name = "Idle",
		List = IdleAnimations,
		Function = function() 
			if AnimationChanger.Enabled then
				AnimationChanger:Toggle(false)
				AnimationChanger:Toggle(false)
			end
		end
	})
	AnimIdleB = AnimationChanger:CreateDropdown({
		Name = "Idle 2",
		List = IdleAnimationsB,
		Function = function() 
			if AnimationChanger.Enabled then
				AnimationChanger:Toggle(false)
				AnimationChanger:Toggle(false)
			end
		end
	})
	AnimFreeze = AnimationChanger:CreateToggle({
		Name = "Freeze",
		Tooltip = "Freezes all your animations",
		Function = function(callback)
			if AnimationChanger.Enabled then
				AnimationChanger:Toggle(false)
				AnimationChanger:Toggle(false)
			end
		end
	})
end)

local vapeConnections
if shared.vapeConnections and type(shared.vapeConnections) == "table" then vapeConnections = shared.vapeConnections else vapeConnections = {}; shared.vapeConnections = vapeConnections; end
GuiLibrary.SelfDestructEvent.Event:Connect(function()
	for i, v in pairs(vapeConnections) do
		if v.Disconnect then pcall(function() v:Disconnect() end) continue end
		if v.disconnect then pcall(function() v:disconnect() end) continue end
	end
end)

run(function()
	local UIS = game:GetService('UserInputService')
	local mouseMod = {Enabled = false}
	local mouseDropdown = {Value = 'Arrow'}
	local mouseIcons = {
		['CS:GO'] = 'rbxassetid://14789879068',
		['Old Roblox Mouse'] = 'rbxassetid://13546344315',
		['dx9ware'] = 'rbxassetid://12233942144',
		['Aimbot'] = 'rbxassetid://8680062686',
		['Triangle'] = 'rbxassetid://14790304072',
		['Arrow'] = 'rbxassetid://14790316561'
	}
	local customMouseIcon = {Enabled = false}
	local customIcon = {Value = ''}
	mouseMod = vape.Categories.Misc:CreateModule({
		Name = 'MouseMod',
		Tooltip = 'Modifies your cursor\'s image.',
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat task.wait()
						if customMouseIcon.Enabled then
							UIS.MouseIcon = 'rbxassetid://' .. customIcon.Value
						else
							UIS.MouseIcon = mouseIcons[mouseDropdown.Value]
						end
					until not mouseMod.Enabled
				end)
			else
				UIS.MouseIcon = ''
				task.wait()
				UIS.MouseIcon = ''
			end
		end
	})
	mouseDropdown = mouseMod:CreateDropdown({
		Name = 'Mouse Icon',
		List = {
			'CS:GO',
			'Old Roblox Mouse',
			'dx9ware',
			'Aimbot',
			'Triangle',
			'Arrow'
		},
		Function = function() end
	})
	customMouseIcon = mouseMod:CreateToggle({
		Name = 'Custom Icon',
		Function = function(callback) end
	})
	customIcon = mouseMod:CreateTextBox({
		Name = 'Custom Mouse Icon',
		TempText = 'Image ID (not decal)',
		FocusLost = function(enter) 
			if mouseMod.Enabled then 
				mouseMod:Toggle(false)
				mouseMod:Toggle(false)
			end
		end
	})
end)

local tween = game:GetService("TweenService")
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
run(function()
	local trails = {};
	local traildistance = {Value = 7};
	local trailcolor = newcolor();
	local trailparts = safearray();
	local lastpos;
	local lastpart;
	local createtrailpart = function()
		local part = Instance.new('Part', game.Workspace);
		part.Anchored = true;
		part.Material = Enum.Material.Neon;
		part.Size = Vector3.new(2, 1, 1);
		part.Shape = Enum.PartType.Ball;
		part.CFrame = lplr.Character.PrimaryPart.CFrame;
		part.CanCollide = false;
		part.Color = Color3.fromHSV(trailcolor.Hue, trailcolor.Sat, trailcolor.Value);
		lastpart = part;
		lastpos = part.Position;
		table.insert(trailparts, part);
		task.delay(2.5, function()
			tween:Create(part, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {Transparency = 1}):Play()
			repeat task.wait() until (part.Transparency == 1);
			part:Destroy()
		end);
		return part
	end;
	trails = vape.Categories.Misc:CreateModule({
		Name = 'Trails',
		Tooltip = 'cool trail for your character.',
		Function = function(calling)
			if calling then 
				repeat 
					if isAlive(lplr, true) and (lastpos == nil or (lplr.Character.PrimaryPart.Position - lastpos).Magnitude > traildistance.Value) then 
						createtrailpart()
					end
					task.wait()
				until (not trails.Enabled)
			end
		end
	})
	traildistance = trails:CreateSlider({
		Name = 'Distance',
		Min = 3,
		Max = 10,
		Function = void
	})
	trailcolor = trails:CreateColorSlider({
		Name = 'Color',
		Function = function()
			for i,v in trailparts do 
				v.Color = Color3.fromHSV(trailcolor.Hue, trailcolor.Sat, trailcolor.Value);
			end
		end
	})
end)

run(function() 
	local AestheticLighting = {}
	AestheticLighting = vape.Categories.Misc:CreateModule({
		Name = 'AestheticLighting',
		Function = function(callback)
			if callback then
				local Lighting = game:GetService("Lighting")
				local StarterGui = game:GetService("StarterGui")
				local Bloom = Instance.new("BloomEffect")
				local Blur = Instance.new("BlurEffect")
				local ColorCor = Instance.new("ColorCorrectionEffect")
				local SunRays = Instance.new("SunRaysEffect")
				local Sky = Instance.new("Sky")
				local Atm = Instance.new("Atmosphere")
	
				for i, v in pairs(Lighting:GetChildren()) do
					if v then
						v:Destroy()
					end
				end
				Bloom.Parent = Lighting
				Blur.Parent = Lighting
				ColorCor.Parent = Lighting
				SunRays.Parent = Lighting
				Sky.Parent = Lighting
				Atm.Parent = Lighting
				if Vignette == true then
					local Gui = Instance.new("ScreenGui")
					Gui.Parent = StarterGui
					Gui.IgnoreGuiInset = true
					
					local ShadowFrame = Instance.new("ImageLabel")
					ShadowFrame.Parent = Gui
					ShadowFrame.AnchorPoint = Vector2.new(0.5,1)
					ShadowFrame.Position = UDim2.new(0.5,0,1,0)
					ShadowFrame.Size = UDim2.new(1,0,1.05,0)
					ShadowFrame.BackgroundTransparency = 1
					ShadowFrame.Image = "rbxassetid://4576475446"
					ShadowFrame.ImageTransparency = 0.3
					ShadowFrame.ZIndex = 10
				end
				Bloom.Intensity = 1
				Bloom.Size = 2
				Bloom.Threshold = 2
				Blur.Size = 0
				ColorCor.Brightness = 0.1
				ColorCor.Contrast = 0
				ColorCor.Saturation = -0.3
				ColorCor.TintColor = Color3.fromRGB(107, 78, 173)
				SunRays.Intensity = 0.03
				SunRays.Spread = 0.727
				Sky.SkyboxBk = "http://www.roblox.com/asset/?id=8139677359"
				Sky.SkyboxDn = "http://www.roblox.com/asset/?id=8139677253"
				Sky.SkyboxFt = "http://www.roblox.com/asset/?id=8139677111"
				Sky.SkyboxLf = "http://www.roblox.com/asset/?id=8139676988"
				Sky.SkyboxRt = "http://www.roblox.com/asset/?id=8139676842"
				Sky.SkyboxUp = "http://www.roblox.com/asset/?id=8139676647"
				Sky.SunAngularSize = 10
				Lighting.Ambient = Color3.fromRGB(128,128,128)
				Lighting.Brightness = 2
				Lighting.ColorShift_Bottom = Color3.fromRGB(0,0,0)
				Lighting.ColorShift_Top = Color3.fromRGB(0,0,0)
				Lighting.EnvironmentDiffuseScale = 0.2
				Lighting.EnvironmentSpecularScale = 0.2
				Lighting.GlobalShadows = false
				Lighting.OutdoorAmbient = Color3.fromRGB(0,0,0)
				Lighting.ShadowSoftness = 0.2
				Lighting.ClockTime = 14
				Lighting.GeographicLatitude = 45
				Lighting.ExposureCompensation = 0.5
			end
		end
	}) 
end)

if shared.ProfilesSavedCustom then
	warningNotification("ProfilesSaver", "Profiles successfully saved!", 3)
	shared.ProfilesSavedCustom = nil
end
run(function()
	local ProfilesSaver = {Enabled = false}
	ProfilesSaver = vape.Categories.Utility:CreateModule({
		Name = "1[VW] ProfilesSaver",
		Function = function(call)
			if call then
				ProfilesSaver:Toggle(false)
				shared.vape:Save()
				shared.Save = function() end
				shared.ProfilesSavedCustom = true
				shared.vape:Uninject()
				loadstring(game:HttpGet("https://raw.githubusercontent.com/randombackup1293/PastewareRewrite/main/NewMainScript.lua", true))()
			end
		end
	})
end)

run(function()
	local PlayerChanger = {Enabled = false}
	local Players = game:GetService("Players")
	local function getPlayers()
        local plrs = {}
        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            table.insert(plrs, player.Name)
        end
        return plrs
    end
	local PlayerChanger_DisconnectActions = {}
	local PlayerChanger_Functions = {
		getPlayerFromUsername = function(username)
			return Players:FindFirstChild(username)
		end,
		getPlayerCharacter = function(plr)
			return plr.Character
		end,
		editPlayerCharacterColor = function(char, color)
			local Objects_Original_Color = {}
			for i,v in pairs(char:GetChildren()) do
				if v.ClassName == "MeshPart" then
					table.insert(Objects_Original_Color, {Object = v, Color = v.Color})
					pcall(function() v.Color = color end)
				end
			end
			table.insert(PlayerChanger_DisconnectActions, function()
				for i,v in pairs(Objects_Original_Color) do
					v.Object.Color = v.Color
				end
			end)
		end,
		editPlayerCharacterName = function(char, name)
			local originalName = char.Name
			table.insert(PlayerChanger_DisconnectActions, function()
				char.Name = originalName
			end)
			pcall(function() char.Name = name end)
		end
	}
	local PlayerChanger_GUI_Elements = {
		PlayersDropdown = {Value = game:GetService("Players").LocalPlayer.Name},
		CharacterColor = {Hue = 0, Sat = 0, Value = 0},
		PlayerName = {Value = "Nigger"}
	}
	local function fetchDefaultFunction() if PlayerChanger.Enabled then PlayerChanger.Restart() end end
	local function fetchCurrentTargetUsername() return PlayerChanger_GUI_Elements.PlayersDropdown.Value end
	shared.PlayerChanger_GUI_Elements_PlayersDropdown_Value = PlayerChanger_GUI_Elements.PlayersDropdown.Value
	shared.fetchCurrentTargetUsername = fetchCurrentTargetUsername
	shared.PlayerChanger_Functions = PlayerChanger_Functions
	shared.PlayerChanger_DisconnectActions = PlayerChanger_DisconnectActions
	GuiLibrary.SelfDestructEvent.Event:Connect(function()
		shared.fetchCurrentTargetUsername = nil
		shared.PlayerChanger_Functions = nil
		shared.PlayerChanger_DisconnectActions = nil
		shared.PlayerChanger_GUI_Elements_PlayersDropdown_Value = nil
	end)
	PlayerChanger = vape.Categories.Misc:CreateModule({
		Name = "PlayerChanger",
		Function = function(call) if call then else
			for i,v in pairs(PlayerChanger_DisconnectActions) do pcall(function() PlayerChanger_DisconnectActions[i]() end) end end 
		end
	})
	PlayerChanger_GUI_Elements.PlayersDropdown = PlayerChanger:CreateDropdown({
		Name = "PlayerChoice",
		Function = function(val) shared.PlayerChanger_GUI_Elements_PlayersDropdown_Value = val end,
		List = getPlayers()
	})
	PlayerChanger_GUI_Elements.CharacterColor = PlayerChanger:CreateColorSlider({
		Name = "Character Color",
		Function = function(h, s, v)
			if PlayerChanger.Enabled then
				local plr = PlayerChanger_Functions.getPlayerFromUsername(fetchCurrentTargetUsername())
				if plr then
					local char = PlayerChanger_Functions.getPlayerCharacter(plr)
					if char then PlayerChanger_Functions.editPlayerCharacterColor(char, Color3.fromHSV(h, s, v))
					else warn("Error fetching player CHARACTER! Player: "..tostring(targetUser).." Character Result: "..tostring(char)) end
				else warn("Error fetching player! Player: "..tostring(targetUser)) end
			end
		end
	})
	table.insert(vapeConnections, game:GetService("Players").PlayerAdded:Connect(function() PlayerChanger_GUI_Elements.PlayersDropdown:Change(getPlayers()) end))
	table.insert(vapeConnections, game:GetService("Players").PlayerRemoving:Connect(function() PlayerChanger_GUI_Elements.PlayersDropdown:Change(getPlayers()) end))
end)

run(function()
	local LightingTheme = {Enabled = false}
	local LightingThemeType = {Value = "LunarNight"}
	local themesky
	local themeobjects = {}
	local oldthemesettings = {
		Ambient = lightingService.Ambient,
		FogEnd = lightingService.FogEnd,
		FogStart = lightingService.FogStart,
		OutdoorAmbient = lightingService.OutdoorAmbient,
	}
	local function dumptable(tab, tabtype, sortfunction)
		local data = {}
		for i,v in pairs(tab) do
			local tabtype = tabtype and tabtype == 1 and i or v
			table.insert(data, tabtype)
		end
		if sortfunction and type(sortfunction) == "function" then
			table.sort(data, sortfunction)
		end
		return data
	end
	local themetable = {
		Purple = function()
			if themesky then
                themesky.SkyboxBk = "rbxassetid://8539982183"
                themesky.SkyboxDn = "rbxassetid://8539981943"
                themesky.SkyboxFt = "rbxassetid://8539981721"
                themesky.SkyboxLf = "rbxassetid://8539981424"
                themesky.SkyboxRt = "rbxassetid://8539980766"
                themesky.SkyboxUp = "rbxassetid://8539981085"
				lightingService.Ambient = Color3.fromRGB(170, 0, 255)
				themesky.MoonAngularSize = 0
                themesky.SunAngularSize = 0
                themesky.StarCount = 3e3
			end
		end,
		Galaxy = function()
			if themesky then
                themesky.SkyboxBk = "rbxassetid://159454299"
                themesky.SkyboxDn = "rbxassetid://159454296"
                themesky.SkyboxFt = "rbxassetid://159454293"
                themesky.SkyboxLf = "rbxassetid://159454293"
                themesky.SkyboxRt = "rbxassetid://159454293"
                themesky.SkyboxUp = "rbxassetid://159454288"
                lightingService.FogEnd = 200
                lightingService.FogStart = 0
				themesky.SunAngularSize = 0
				lightingService.OutdoorAmbient = Color3.fromRGB(172, 18, 255)
			end
		end,
		BetterNight = function()
			if themesky then
				themesky.SkyboxBk = "rbxassetid://155629671"
                themesky.SkyboxDn = "rbxassetid://12064152"
                themesky.SkyboxFt = "rbxassetid://155629677"
                themesky.SkyboxLf = "rbxassetid://155629662"
                themesky.SkyboxRt = "rbxassetid://155629666"
                themesky.SkyboxUp = "rbxassetid://155629686"
				lightingService.FogColor = Color3.new(0, 20, 64)
				themesky.SunAngularSize = 0
			end
		end,
		BetterNight2 = function()
			if themesky then
				themesky.SkyboxBk = "rbxassetid://248431616"
                themesky.SkyboxDn = "rbxassetid://248431677"
                themesky.SkyboxFt = "rbxassetid://248431598"
                themesky.SkyboxLf = "rbxassetid://248431686"
                themesky.SkyboxRt = "rbxassetid://248431611"
                themesky.SkyboxUp = "rbxassetid://248431605"
				themesky.StarCount = 3000
			end
		end,
		MagentaOrange = function()
			if themesky then
				themesky.SkyboxBk = "rbxassetid://566616113"
                themesky.SkyboxDn = "rbxassetid://566616232"
                themesky.SkyboxFt = "rbxassetid://566616141"
                themesky.SkyboxLf = "rbxassetid://566616044"
                themesky.SkyboxRt = "rbxassetid://566616082"
                themesky.SkyboxUp = "rbxassetid://566616187"
				themesky.StarCount = 3000
			end
		end,
		Purple2 = function()
			if themesky then
				themesky.SkyboxBk = "rbxassetid://8107841671"
				themesky.SkyboxDn = "rbxassetid://6444884785"
				themesky.SkyboxFt = "rbxassetid://8107841671"
				themesky.SkyboxLf = "rbxassetid://8107841671"
				themesky.SkyboxRt = "rbxassetid://8107841671"
				themesky.SkyboxUp = "rbxassetid://8107849791"
				themesky.SunTextureId = "rbxassetid://6196665106"
				themesky.MoonTextureId = "rbxassetid://6444320592"
				themesky.MoonAngularSize = 0
			end
		end,
		Galaxy2 = function()
			if themesky then
				themesky.SkyboxBk = "rbxassetid://14164368678"
				themesky.SkyboxDn = "rbxassetid://14164386126"
				themesky.SkyboxFt = "rbxassetid://14164389230"
				themesky.SkyboxLf = "rbxassetid://14164398493"
				themesky.SkyboxRt = "rbxassetid://14164402782"
				themesky.SkyboxUp = "rbxassetid://14164405298"
				themesky.SunTextureId = "rbxassetid://8281961896"
				themesky.MoonTextureId = "rbxassetid://6444320592"
				themesky.SunAngularSize = 0
				themesky.MoonAngularSize = 0
				lightingService.OutdoorAmbient = Color3.fromRGB(172, 18, 255)
			end
		end,
		Pink = function()
			if themesky then
				themesky.SkyboxBk = "rbxassetid://271042516"
				themesky.SkyboxDn = "rbxassetid://271077243"
				themesky.SkyboxFt = "rbxassetid://271042556"
				themesky.SkyboxLf = "rbxassetid://271042310"
				themesky.SkyboxRt = "rbxassetid://271042467"
				themesky.SkyboxUp = "rbxassetid://271077958"
			end
		end,
		Purple3 = function()
			if themesky then
				themesky.SkyboxBk = "rbxassetid://433274085"
				themesky.SkyboxDn = "rbxassetid://433274194"
				themesky.SkyboxFt = "rbxassetid://433274131"
				themesky.SkyboxLf = "rbxassetid://433274370"
				themesky.SkyboxRt = "rbxassetid://433274429"
				themesky.SkyboxUp = "rbxassetid://433274285"
				lightingService.FogColor = Color3.new(170, 0, 255)
				lightingService.FogEnd = 200
				lightingService.FogStart = 0
			end
		end,
		DarkishPink = function()
			if themesky then
				themesky.SkyboxBk = "rbxassetid://570555736"
				themesky.SkyboxDn = "rbxassetid://570555964"
				themesky.SkyboxFt = "rbxassetid://570555800"
				themesky.SkyboxLf = "rbxassetid://570555840"
				themesky.SkyboxRt = "rbxassetid://570555882"
				themesky.SkyboxUp = "rbxassetid://570555929"
			end
		end,
		Space = function()
			themesky.MoonAngularSize = 0
			themesky.SunAngularSize = 0
			themesky.SkyboxBk = "rbxassetid://166509999"
			themesky.SkyboxDn = "rbxassetid://166510057"
			themesky.SkyboxFt = "rbxassetid://166510116"
			themesky.SkyboxLf = "rbxassetid://166510092"
			themesky.SkyboxRt = "rbxassetid://166510131"
			themesky.SkyboxUp = "rbxassetid://166510114"
		end,
		Galaxy3 = function()
			themesky.MoonAngularSize = 0
			themesky.SunAngularSize = 0
			themesky.SkyboxBk = "rbxassetid://14543264135"
			themesky.SkyboxDn = "rbxassetid://14543358958"
			themesky.SkyboxFt = "rbxassetid://14543257810"
			themesky.SkyboxLf = "rbxassetid://14543275895"
			themesky.SkyboxRt = "rbxassetid://14543280890"
			themesky.SkyboxUp = "rbxassetid://14543371676"
		end,
		NetherWorld = function()
			themesky.MoonAngularSize = 0
			themesky.SunAngularSize = 0
			themesky.SkyboxBk = "rbxassetid://14365019002"
			themesky.SkyboxDn = "rbxassetid://14365023350"
			themesky.SkyboxFt = "rbxassetid://14365018399"
			themesky.SkyboxLf = "rbxassetid://14365018705"
			themesky.SkyboxRt = "rbxassetid://14365018143"
			themesky.SkyboxUp = "rbxassetid://14365019327"
		end,
		Nebula = function()
			themesky.MoonAngularSize = 0
			themesky.SunAngularSize = 0
			themesky.SkyboxBk = "rbxassetid://5260808177"
			themesky.SkyboxDn = "rbxassetid://5260653793"
			themesky.SkyboxFt = "rbxassetid://5260817288"
			themesky.SkyboxLf = "rbxassetid://5260800833"
			themesky.SkyboxRt = "rbxassetid://5260811073"
			themesky.SkyboxUp = "rbxassetid://5260824661"
			lightingService.Ambient = Color3.fromRGB(170, 0, 255)
		end,
		PurpleNight = function()
			if themesky then
			themesky.MoonAngularSize = 0
			themesky.SunAngularSize = 0
			themesky.SkyboxBk = "rbxassetid://5260808177"
			themesky.SkyboxDn = "rbxassetid://5260653793"
			themesky.SkyboxFt = "rbxassetid://5260817288"
			themesky.SkyboxLf = "rbxassetid://5260800833"
			themesky.SkyboxRt = "rbxassetid://5260800833"
			themesky.SkyboxUp = "rbxassetid://5084576400"
			lightingService.Ambient = Color3.fromRGB(170, 0, 255)
			end
		end,
		Aesthetic = function()
			if themesky then
			themesky.MoonAngularSize = 0
			themesky.SunAngularSize = 0
			themesky.SkyboxBk = "rbxassetid://1417494030"
			themesky.SkyboxDn = "rbxassetid://1417494146"
			themesky.SkyboxFt = "rbxassetid://1417494253"
			themesky.SkyboxLf = "rbxassetid://1417494402"
			themesky.SkyboxRt = "rbxassetid://1417494499"
			themesky.SkyboxUp = "rbxassetid://1417494643"
			end
		end,
		Aesthetic2 = function()
			if themesky then
			themesky.MoonAngularSize = 0
			themesky.SunAngularSize = 0
			themesky.SkyboxBk = "rbxassetid://600830446"
			themesky.SkyboxDn = "rbxassetid://600831635"
			themesky.SkyboxFt = "rbxassetid://600832720"
			themesky.SkyboxLf = "rbxassetid://600886090"
			themesky.SkyboxRt = "rbxassetid://600833862"
			themesky.SkyboxUp = "rbxassetid://600835177"
			end
		end,
		Pastel = function()
			if themesky then
			themesky.SunAngularSize = 0
			themesky.MoonAngularSize = 0
			themesky.SkyboxBk = "rbxassetid://2128458653"
			themesky.SkyboxDn = "rbxassetid://2128462480"
			themesky.SkyboxFt = "rbxassetid://2128458653"
			themesky.SkyboxLf = "rbxassetid://2128462027"
			themesky.SkyboxRt = "rbxassetid://2128462027"
			themesky.SkyboxUp = "rbxassetid://2128462236"
			end
		end,
		PurpleClouds = function()
			if themesky then
			themesky.SkyboxBk = "rbxassetid://570557514"
			themesky.SkyboxDn = "rbxassetid://570557775"
			themesky.SkyboxFt = "rbxassetid://570557559"
			themesky.SkyboxLf = "rbxassetid://570557620"
			themesky.SkyboxRt = "rbxassetid://570557672"
			themesky.SkyboxUp = "rbxassetid://570557727"
			lightingService.Ambient = Color3.fromRGB(172, 18, 255)
			end
		end,
		BetterSky = function()
			if themesky then
			themesky.SkyboxBk = "rbxassetid://591058823"
			themesky.SkyboxDn = "rbxassetid://591059876"
			themesky.SkyboxFt = "rbxassetid://591058104"
			themesky.SkyboxLf = "rbxassetid://591057861"
			themesky.SkyboxRt = "rbxassetid://591057625"
			themesky.SkyboxUp = "rbxassetid://591059642"
			end
		end,
		BetterNight3 = function()
			if themesky then
			themesky.MoonTextureId = "rbxassetid://1075087760"
			themesky.SkyboxBk = "rbxassetid://2670643994"
			themesky.SkyboxDn = "rbxassetid://2670643365"
			themesky.SkyboxFt = "rbxassetid://2670643214"
			themesky.SkyboxLf = "rbxassetid://2670643070"
			themesky.SkyboxRt = "rbxassetid://2670644173"
			themesky.SkyboxUp = "rbxassetid://2670644331"
			themesky.MoonAngularSize = 1.5
			themesky.StarCount = 500
			pcall(function()
			local MoonColorCorrection = Instance.new("ColorCorrection")
			table.insert(themeobjects, MoonColorCorrection)
			MoonColorCorrection.Enabled = true
			MoonColorCorrection.TintColor = Color3.fromRGB(189, 179, 178)
			MoonColorCorrection.Parent = game.Workspace
			local MoonBlur = Instance.new("BlurEffect")
			table.insert(themeobjects, MoonBlur)
			MoonBlur.Enabled = true
			MoonBlur.Size = 9
			MoonBlur.Parent = game.Workspace
			local MoonBloom = Instance.new("BloomEffect")
			table.insert(themeobjects, MoonBloom)
			MoonBloom.Enabled = true
			MoonBloom.Intensity = 100
			MoonBloom.Size = 56
			MoonBloom.Threshold = 5
			MoonBloom.Parent = game.Workspace
			end)
			end
		end,
		Orange = function()
			if themesky then
			themesky.SkyboxBk = "rbxassetid://150939022"
			themesky.SkyboxDn = "rbxassetid://150939038"
			themesky.SkyboxFt = "rbxassetid://150939047"
			themesky.SkyboxLf = "rbxassetid://150939056"
			themesky.SkyboxRt = "rbxassetid://150939063"
			themesky.SkyboxUp = "rbxassetid://150939082"
			end
		end,
		DarkMountains = function()
			if themesky then
				themesky.SkyboxBk = "rbxassetid://5098814730"
				themesky.SkyboxDn = "rbxassetid://5098815227"
				themesky.SkyboxFt = "rbxassetid://5098815653"
				themesky.SkyboxLf = "rbxassetid://5098816155"
				themesky.SkyboxRt = "rbxassetid://5098820352"
				themesky.SkyboxUp = "rbxassetid://5098819127"
			end
		end,
		FlamingSunset = function()
			if themesky then
			themesky.SkyboxBk = "rbxassetid://415688378"
			themesky.SkyboxDn = "rbxassetid://415688193"
			themesky.SkyboxFt = "rbxassetid://415688242"
			themesky.SkyboxLf = "rbxassetid://415688310"
			themesky.SkyboxRt = "rbxassetid://415688274"
			themesky.SkyboxUp = "rbxassetid://415688354"
			end
		end,
		NewYork = function()
			if themesky then
			themesky.SkyboxBk = "rbxassetid://11333973069"
			themesky.SkyboxDn = "rbxassetid://11333969768"
			themesky.SkyboxFt = "rbxassetid://11333964303"
			themesky.SkyboxLf = "rbxassetid://11333971332"
			themesky.SkyboxRt = "rbxassetid://11333982864"
			themesky.SkyboxUp = "rbxassetid://11333967970"
			themesky.SunAngularSize = 0
			end
		end,
		Aesthetic3 = function()
			if themesky then
			themesky.SkyboxBk = "rbxassetid://151165214"
			themesky.SkyboxDn = "rbxassetid://151165197"
			themesky.SkyboxFt = "rbxassetid://151165224"
			themesky.SkyboxLf = "rbxassetid://151165191"
			themesky.SkyboxRt = "rbxassetid://151165206"
			themesky.SkyboxUp = "rbxassetid://151165227"
			end
		end,
		FakeClouds = function()
			if themesky then
			themesky.SkyboxBk = "rbxassetid://8496892810"
			themesky.SkyboxDn = "rbxassetid://8496896250"
			themesky.SkyboxFt = "rbxassetid://8496892810"
			themesky.SkyboxLf = "rbxassetid://8496892810"
			themesky.SkyboxRt = "rbxassetid://8496892810"
			themesky.SkyboxUp = "rbxassetid://8496897504"
			themesky.SunAngularSize = 0
			end
		end,
		LunarNight = function()
			if themesky then
				themesky.SkyboxBk = "rbxassetid://187713366"
				themesky.SkyboxDn = "rbxassetid://187712428"
				themesky.SkyboxFt = "rbxassetid://187712836"
				themesky.SkyboxLf = "rbxassetid://187713755"
				themesky.SkyboxRt = "rbxassetid://187714525"
				themesky.SkyboxUp = "rbxassetid://187712111"
				themesky.SunAngularSize = 0
				themesky.StarCount = 0
			end
		end,
		PitchDark = function()
			themesky.StarCount = 0
			lightingService.TimeOfDay = "00:00:00"
			LightingTheme:Clean(lightingService:GetPropertyChangedSignal("TimeOfDay"):Connect(function()
				pcall(function()
				themesky.StarCount = 0
				lightingService.TimeOfDay = "00:00:00"
				end)
			end))
		end
	}
	LightingTheme = vape.Categories.World:CreateModule({
		Name = "LightingTheme",
		Tooltip = "Add a whole new look to your game.",
		ExtraText = function() return LightingThemeType.Value end,
		Function = function(callback) 
			if callback then 
				task.spawn(function()
					task.wait()
					themesky = Instance.new("Sky")
					local success, err = pcall(themetable[LightingThemeType.Value])
					err = err and " | "..err or ""
					vapeAssert(success, "LightingTheme", "Failed to load the "..LightingThemeType.Value.." theme."..err, 5)
					themesky.Parent = success and lightingService or nil
					LightingTheme:Clean(lightingService.ChildAdded:Connect(function(v)
						if success and v:IsA("Sky") then 
							v.Parent = nil
						end
					end))
				end)
			else
				if themesky then 
					themesky = pcall(function() themesky:Destroy() end)
					for i,v in pairs(themeobjects) do 
						pcall(function() v:Destroy() end)
					end
					table.clear(themeobjects)
					for i,v in pairs(lightingService:GetChildren()) do 
						if v:IsA("Sky") and themesky then 
							pcall(function()
								v.Parent = nil 
								v.Parent = lightingService
							end)
						end
					end
					for i,v in pairs(oldthemesettings) do 
						pcall(function() lightingService[i] = v end)
					end
				end
				themesky = nil
			end
		end
	})
	LightingThemeType = LightingTheme:CreateDropdown({
		Name = "Theme",
		List = dumptable(themetable, 1),
		Function = function()
			if LightingTheme.Enabled then 
				LightingTheme:Toggle(false)
				LightingTheme:Toggle(false)
			end
		end
	})
end)

run(function()
    local CharacterEditor = {Enabled = true}
    local RevertTable = {}
    local ExcludeTable = {ObjectList = {}}
    local function isExcluded(part)
        local name = part.Name or tostring(part)
        for i,v in pairs(ExcludeTable.ObjectList) do
            name, v = tostring(name), tostring(v)
            if v == name then return true end
            if string.lower(name) == string.lower(v) then return end
        end
    end
    local function savePart(part)
        table.insert(RevertTable, {
            Part = part,
            Material = part.Material
        })
    end
    CharacterEditor = vape.Categories.Misc:CreateModule({
        Name = "TransparentCharacter",
        Function = function(call)
            if call then
                repeat task.wait();
                    if entityLibrary.isAlive and game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:IsA("Model") then
                        for _, part in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                            if not isExcluded(part) and part:IsA("BasePart") then savePart(part); part.Material = Enum.Material.ForceField end
                        end
                    end
                until (not CharacterEditor.Enabled)
            else
				for i,v in pairs(RevertTable) do
					pcall(function() v.Part.Material = Enum.Material[tostring(v.Material)] end)
				end
            end
        end
    })
    CharacterEditor.Restart = function() if CharacterEditor.Enabled then CharacterEditor:Toggle(false); CharacterEditor:Toggle(false) end end
    ExcludeTable = CharacterEditor:CreateTextList({
        Name = "Exclude character parts",
        TempText = "Example: Cape",
        Function = CharacterEditor.Restart
    })
end)
