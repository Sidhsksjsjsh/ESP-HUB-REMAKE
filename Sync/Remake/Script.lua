game:GetService('RunService').Stepped:connect(function()
for _,v in pairs(game.Players:GetPlayers()) do
local Check = game.Players[v.Name].Team
local Heart = game.Players[v.Name].Character.Humanoid.Health
local Pinput = game.Players[v.Name] .. "[ " .. Check .. " ] [ " .. Heart .. " ]"
end)
wait()
local Plrs = game:GetService("Players")
local Run = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StartGui = game:GetService("StarterGui")
local Teams = game:GetService("Teams")
local UserInput = game:GetService("UserInputService")
local Light = game:GetService("Lighting")
local HTTP = game:GetService("HttpService")
local RepStor = game:GetService("ReplicatedStorage")
 
function GetCamera() -- Just in case some game renames the player's camera.
return workspace:FindFirstChildOfClass("Camera")
end
 
local ChamsFolder = Instance.new("Folder", CoreGui)
ChamsFolder.Name = "Chams"
local PlayerChams = Instance.new("Folder", ChamsFolder)
PlayerChams.Name = "PlayerChams"
local ItemChams = Instance.new("Folder", ChamsFolder)
ItemChams.Name = "ItemChams"

local ESPFolder = Instance.new("Folder", CoreGui)
ESPFolder.Name = "ESP Stuff"
local PlayerESP = Instance.new("Folder", ESPFolder)
PlayerESP.Name = "PlayerESP"
local ItemESP = Instance.new("Folder", ESPFolder)
ItemESP.Name = "ItemESP"

local MyPlr = Plrs.LocalPlayer
local MyChar = MyPlr.Character
local MyMouse = MyPlr:GetMouse()
local MyCam = GetCamera()
if MyCam == nil then
error("WHAT KIND OF BLACK MAGIC IS THIS, CAMERA NOT FOUND.")
return
end

local Tracers = Instance.new("Folder", MyCam)
Tracers.Name = "Tracers"
local TracerData = { }
local TracerMT = setmetatable(TracerData, {
__newindex = function(tab, index, val)
rawset(tab, index, val)
end
})

function RemoveSpacesFromString(Str)
local newstr = ""
for i = 1, #Str do
if Str:sub(i, i) ~= " " then
newstr = newstr .. Str:sub(i, i)
end
end

return newstr
end

function CloneTable(T)
    local temp = { }
    for i,v in next, T do
        if type(v) == "table" then
            temp[i] = CloneTable(v)
        else
            temp[i] = v 
        end
    end
    return temp
end

local Vexana = {
ESPEnabled = false, -- Self explanatory. LEAVE OFF BY DEFAULT.
CHAMSEnabled = false, -- Self explanatory. LEAVE OFF BY DEFAULT.
TracersEnabled = false, -- Self explanatory. LEAVE OFF BY DEFAULT.
DebugInfo = false, -- Self explanatory. LEAVE OFF BY DEFAULT.
OutlinesEnabled = false,
FullbrightEnabled = false,
CrosshairEnabled = false,
AimbotEnabled = false,
Aimbot = false,
TracersLength = 500, -- MAX DISTANCE IS 2048 DO NOT GO ABOVE OR YOU'LL ENCOUNTER PROBLEMS.
ESPLength = 10000,
CHAMSLength = 500,
PlaceTracersUnderCharacter = true, -- Change to true if you want tracers to be placed under your character instead of at the bottom of your camera.
FreeForAll = false, -- use for games that don't have teams (Apocalypse Rising)
AutoFire = false,
MobChams = false,
MobESP = false,
AimbotKey = "Enum.UserInputType.MouseButton2", -- Doesn't do anything yet.
Colors = {
Enemy = Color3.new(1, 0, 0),
Ally = Color3.new(0, 1, 0),
Friend = Color3.new(1, 1, 0),
Neutral = Color3.new(1, 1, 1),
Crosshair = Color3.new(1, 0, 0),
ColorOverride = nil, -- Every player will have the chosen color regardless of enemy or ally.
},

-- VVVV DON'T EDIT BELOW VVVV --
ClosestEnemy = nil,
CharAddedEvent = { },
OutlinedParts = { },
WorkspaceChildAddedEvent = nil,
LightingEvent = nil,
AmbientBackup = Light.Ambient,
ColorShiftBotBackup = Light.ColorShift_Bottom,
ColorShiftTopBackup = Light.ColorShift_Top,
FPSAverage = { },
Blacklist = { },
FriendList = { },
CameraModeBackup = MyPlr.CameraMode,
GameSpecificCrap = { 
},
Mob_ESP_CHAMS_Ran_Once = false,
}

function SaveVexanaSettings()
local temp = { }
local succ, out = pcall(function()
temp.TracersLength = Vexana.TracersLength
temp.ESPLength = Vexana.ESPLength
temp.CHAMSLength = Vexana.CHAMSLength
temp.PlaceTracersUnderCharacter = Vexana.PlaceTracersUnderCharacter
temp.FreeForAll = Vexana.FreeForAll
temp.AutoFire = Vexana.AutoFire
temp.AimbotKey = tostring(Vexana.AimbotKey)
temp.MobChams = Vexana.MobChams
temp.MobESP = Vexana.MobESP
temp.Colors = { }
for i, v in next, Vexana.Colors do
temp.Colors[i] = tostring(v)
end
writefile("ProjectVexana.txt", HTTP:JSONEncode(temp))
end)
if not succ then
error(out)
end
end

fuck = pcall(function()
local temp = HTTP:JSONDecode(readfile("ProjectVexana.txt"))
if temp.MobChams ~= nil and temp.MobESP ~= nil then
for i, v in next, temp do
if i ~= "Colors" then
Vexana[i] = v
end
end
for i, v in next, temp.Colors do
local r, g, b = string.match(RemoveSpacesFromString(v), "(%d+),(%d+),(%d+)")
r = tonumber(r)
g = tonumber(g)
b = tonumber(b)

temp.Colors[i] = Color3.new(r, g, b)
end
Vexana.Colors = temp.Colors
else
spawn(function()
SaveVexanaSettings()
local hint = Instance.new("Hint", CoreGui)
hint.Text = "Major update requried your settings to be wiped! Sorry!"
wait(5)
hint:Destroy()
end)
end

Vexana.AutoFire = false
end)

-- Load blacklist file if it exists
Count2 = pcall(function()
Vexana.Blacklist = HTTP:JSONDecode(readfile("Blacklist.txt"))
end)

Count3 = pcall(function()
Vexana.FriendList = HTTP:JSONDecode(readfile("Whitelist.txt"))
end)

local DebugMenu = { }
DebugMenu["SC"] = Instance.new("ScreenGui", CoreGui)
DebugMenu["SC"].Name = "Debug"
DebugMenu["Main"] = Instance.new("Frame", DebugMenu["SC"])
DebugMenu["Main"].Name = "Debug Menu"
DebugMenu["Main"].Position = UDim2.new(0, 20, 1, -220)
DebugMenu["Main"].Size = UDim2.new(1, 0, 0, 200)
DebugMenu["Main"].BackgroundTransparency = 1
DebugMenu["Main"].Visible = false
if game.PlaceId == 606849621 then
DebugMenu["Main"].Position = UDim2.new(0, 230, 1, -220)
end
DebugMenu["Main"].Draggable = true
DebugMenu["Main"].Active = true
DebugMenu["Position"] = Instance.new("TextLabel", DebugMenu["Main"])
DebugMenu["Position"].BackgroundTransparency = 1
DebugMenu["Position"].Position = UDim2.new(0, 0, 0, 0)
DebugMenu["Position"].Size = UDim2.new(1, 0, 0, 15)
DebugMenu["Position"].Font = "Arcade"
DebugMenu["Position"].Text = ""
DebugMenu["Position"].TextColor3 = Color3.new(1, 1, 1)
DebugMenu["Position"].TextSize = 15
DebugMenu["Position"].TextStrokeColor3 = Color3.new(0, 0, 0)
DebugMenu["Position"].TextStrokeTransparency = 0.3
DebugMenu["Position"].TextXAlignment = "Left"
DebugMenu["FPS"] = Instance.new("TextLabel", DebugMenu["Main"])
DebugMenu["FPS"].BackgroundTransparency = 1
DebugMenu["FPS"].Position = UDim2.new(0, 0, 0, 15)
DebugMenu["FPS"].Size = UDim2.new(1, 0, 0, 15)
DebugMenu["FPS"].Font = "Arcade"
DebugMenu["FPS"].Text = ""
DebugMenu["FPS"].TextColor3 = Color3.new(1, 1, 1)
DebugMenu["FPS"].TextSize = 15
DebugMenu["FPS"].TextStrokeColor3 = Color3.new(0, 0, 0)
DebugMenu["FPS"].TextStrokeTransparency = 0.3
DebugMenu["FPS"].TextXAlignment = "Left"
DebugMenu["PlayerSelected"] = Instance.new("TextLabel", DebugMenu["Main"])
DebugMenu["PlayerSelected"].BackgroundTransparency = 1
DebugMenu["PlayerSelected"].Position = UDim2.new(0, 0, 0, 35)
DebugMenu["PlayerSelected"].Size = UDim2.new(1, 0, 0, 15)
DebugMenu["PlayerSelected"].Font = "Arcade"
DebugMenu["PlayerSelected"].Text = ""
DebugMenu["PlayerSelected"].TextColor3 = Color3.new(1, 1, 1)
DebugMenu["PlayerSelected"].TextSize = 15
DebugMenu["PlayerSelected"].TextStrokeColor3 = Color3.new(0, 0, 0)
DebugMenu["PlayerSelected"].TextStrokeTransparency = 0.3
DebugMenu["PlayerSelected"].TextXAlignment = "Left"
DebugMenu["PlayerTeam"] = Instance.new("TextLabel", DebugMenu["Main"])
DebugMenu["PlayerTeam"].BackgroundTransparency = 1
DebugMenu["PlayerTeam"].Position = UDim2.new(0, 0, 0, 50)
DebugMenu["PlayerTeam"].Size = UDim2.new(1, 0, 0, 15)
DebugMenu["PlayerTeam"].Font = "Arcade"
DebugMenu["PlayerTeam"].Text = ""
DebugMenu["PlayerTeam"].TextColor3 = Color3.new(1, 1, 1)
DebugMenu["PlayerTeam"].TextSize = 15
DebugMenu["PlayerTeam"].TextStrokeColor3 = Color3.new(0, 0, 0)
DebugMenu["PlayerTeam"].TextStrokeTransparency = 0.3
DebugMenu["PlayerTeam"].TextXAlignment = "Left"
DebugMenu["PlayerHealth"] = Instance.new("TextLabel", DebugMenu["Main"])
DebugMenu["PlayerHealth"].BackgroundTransparency = 1
DebugMenu["PlayerHealth"].Position = UDim2.new(0, 0, 0, 65)
DebugMenu["PlayerHealth"].Size = UDim2.new(1, 0, 0, 15)
DebugMenu["PlayerHealth"].Font = "Arcade"
DebugMenu["PlayerHealth"].Text = ""
DebugMenu["PlayerHealth"].TextColor3 = Color3.new(1, 1, 1)
DebugMenu["PlayerHealth"].TextSize = 15
DebugMenu["PlayerHealth"].TextStrokeColor3 = Color3.new(0, 0, 0)
DebugMenu["PlayerHealth"].TextStrokeTransparency = 0.3
DebugMenu["PlayerHealth"].TextXAlignment = "Left"
DebugMenu["PlayerPosition"] = Instance.new("TextLabel", DebugMenu["Main"])
DebugMenu["PlayerPosition"].BackgroundTransparency = 1
DebugMenu["PlayerPosition"].Position = UDim2.new(0, 0, 0, 80)
DebugMenu["PlayerPosition"].Size = UDim2.new(1, 0, 0, 15)
DebugMenu["PlayerPosition"].Font = "Arcade"
DebugMenu["PlayerPosition"].Text = ""
DebugMenu["PlayerPosition"].TextColor3 = Color3.new(1, 1, 1)
DebugMenu["PlayerPosition"].TextSize = 15
DebugMenu["PlayerPosition"].TextStrokeColor3 = Color3.new(0, 0, 0)
DebugMenu["PlayerPosition"].TextStrokeTransparency = 0.3
DebugMenu["PlayerPosition"].TextXAlignment = "Left"
DebugMenu["BehindWall"] = Instance.new("TextLabel", DebugMenu["Main"])
DebugMenu["BehindWall"].BackgroundTransparency = 1
DebugMenu["BehindWall"].Position = UDim2.new(0, 0, 0, 95)
DebugMenu["BehindWall"].Size = UDim2.new(1, 0, 0, 15)
DebugMenu["BehindWall"].Font = "Arcade"
DebugMenu["BehindWall"].Text = ""
DebugMenu["BehindWall"].TextColor3 = Color3.new(1, 1, 1)
DebugMenu["BehindWall"].TextSize = 15
DebugMenu["BehindWall"].TextStrokeColor3 = Color3.new(0, 0, 0)
DebugMenu["BehindWall"].TextStrokeTransparency = 0.3
DebugMenu["BehindWall"].TextXAlignment = "Left"

local LastTick = tick()
local FPSTick = tick()

if #Teams:GetChildren() <= 0 then
Vexana.FreeForAll = true
end

if Vexana.TracersLength > 2048 then
Vexana.TracersLength = 2048
end

if Vexana.CHAMSLength > 2048 then
Vexana.CHAMSLength = 2048
end

local wildrevolvertick = tick()
local wildrevolverteamdata = nil
function GetTeamColor(Plr)
if Plr == nil then return nil end
if not Plr:IsA("Player") then
return nil
end
local PickedColor = Vexana.Colors.Enemy

if Plr ~= nil then
if game.PlaceId == 606849621 then
if Vexana.Colors.ColorOverride == nil then
if not Vexana.FreeForAll then
if MyPlr.Team ~= nil and Plr.Team ~= nil then
if Vexana.FriendList[Plr.Name] == nil then
if MyPlr.Team.Name == "Prisoner" then
if Plr.Team == MyPlr.Team or Plr.Team.Name == "Criminal" then
PickedColor = Vexana.Colors.Ally
else
PickedColor = Vexana.Colors.Enemy
end
elseif MyPlr.Team.Name == "Criminal" then
if Plr.Team == MyPlr.Team or Plr.Team.Name == "Prisoner" then
PickedColor = Vexana.Colors.Ally
else
PickedColor = Vexana.Colors.Enemy
end
elseif MyPlr.Team.Name == "Police" then
if Plr.Team == MyPlr.Team then
PickedColor = Vexana.Colors.Ally
else
if Plr.Team.Name == "Criminal" then
PickedColor = Vexana.Colors.Enemy
elseif Plr.Team.Name == "Prisoner" then
PickedColor = Vexana.Colors.Neutral
end
end
end
else
PickedColor = Vexana.Colors.Friend
end
end
else
if Vexana.FriendList[Plr.Name] ~= nil then
PickedColor = Vexana.Colors.Friend
else
PickedColor = Vexana.Colors.Enemy
end
end
else
PickedColor = Vexana.Colors.ColorOverride
end
elseif game.PlaceId == 155615604 then
if Vexana.Colors.ColorOverride == nil then
if MyPlr.Team ~= nil and Plr.Team ~= nil then
if Vexana.FriendList[Plr.Name] == nil then
if MyPlr.Team.Name == "Inmates" then
if Plr.Team.Name == "Inmates" then
PickedColor = Vexana.Colors.Ally
elseif Plr.Team.Name == "Guards" or Plr.Team.Name == "Criminals" then
PickedColor = Vexana.Colors.Enemy
else
PickedColor = Vexana.Colors.Neutral
end
elseif MyPlr.Team.Name == "Guards" then
if Plr.Team.Name == "Inmates" then
PickedColor = Vexana.Colors.Neutral
elseif Plr.Team.Name == "Criminals" then
PickedColor = Vexana.Colors.Enemy
elseif Plr.Team.Name == "Guards" then
PickColor = Vexana.Colors.Ally
end
elseif MyPlr.Team.Name == "Criminals" then
if Plr.Team.Name == "Inmates" then
PickedColor = Vexana.Colors.Ally
elseif Plr.Team.Name == "Guards" then
PickedColor = Vexana.Colors.Enemy
else
PickedColor = Vexana.Colors.Neutral
end
end
else
PickedColor = Vexana.Colors.Friend
end
end
else
PickedColor = Vexana.Colors.ColorOverride
end
elseif game.PlaceId == 746820961 then
if Vexana.Colors.ColorOverride == nil then
if MyPlr:FindFirstChild("TeamC") and Plr:FindFirstChild("TeamC") then
if Plr.TeamC.Value == MyPlr.TeamC.Value then
PickedColor = Vexana.Colors.Ally
else
PickedColor = Vexana.Colors.Enemy
end
end
else
PickedColor = Vexana.Colors.ColorOverride
end
elseif game.PlaceId == 1382113806 then
if Vexana.Colors.ColorOverride == nil then
if MyPlr:FindFirstChild("role") and Plr:FindFirstChild("role") then
if MyPlr.role.Value == "assassin" then
if Plr.role.Value == "target" then
PickedColor = Vexana.Colors.Enemy
elseif Plr.role.Value == "guard" then
PickedColor = Color3.new(1, 135 / 255, 0)
else
PickedColor = Vexana.Colors.Neutral
end
elseif MyPlr.role.Value == "target" then
if Plr.role.Value == "guard" then
PickedColor = Vexana.Colors.Ally
elseif Plr.role.Value == "assassin" then
PickedColor = Vexana.Colors.Enemy
else
PickedColor = Vexana.Colors.Neutral
end
elseif MyPlr.role.Value == "guard" then
if Plr.role.Value == "target" then
PickedColor = Vexana.Colors.Friend
elseif Plr.role.Value == "guard" then
PickedColor = Vexana.Colors.Ally
elseif Plr.role.Value == "assassin" then
PickedColor = Vexana.Colors.Enemy
else
PickedColor = Vexana.Colors.Neutral
end
else
if MyPlr.role.Value == "none" then
PickedColor = Vexana.Colors.Neutral
end
end
end
else
PickedColor = Vexana.Colors.ColorOverride
end
elseif game.PlaceId == 1072809192 then
if MyPlr:FindFirstChild("Backpack") and Plr:FindFirstChild("Backpack") then
if MyPlr.Backpack:FindFirstChild("Knife") or MyChar:FindFirstChild("Knife") then
if Plr.Backpack:FindFirstChild("Revolver") or Plr.Character:FindFirstChild("Revolver") then
PickedColor = Vexana.Colors.Enemy
else
PickedColor = Color3.new(1, 135 / 255, 0)
end
elseif MyPlr.Backpack:FindFirstChild("Revolver") or MyChar:FindFirstChild("Revolver") then
if Plr.Backpack:FindFirstChild("Knife") or Plr.Character:FindFirstChild("Knife") then
PickedColor = Vexana.Colors.Enemy
elseif Plr.Backpack:FindFirstChild("Revolver") or Plr.Character:FindFirstChild("Revolver") then
PickedColor = Vexana.Colors.Enemy
else
PickedColor = Vexana.Colors.Ally
end
else
if Plr.Backpack:FindFirstChild("Knife") or Plr.Character:FindFirstChild("Knife") then
PickedColor = Vexana.Colors.Enemy
elseif Plr.Backpack:FindFirstChild("Revolver") or Plr.Character:FindFirstChild("Revolver") then
PickedColor = Vexana.Colors.Ally
else
PickedColor = Vexana.Colors.Neutral
end
end
end
elseif game.PlaceId == 142823291 or game.PlaceId == 1122507250 then
if MyPlr:FindFirstChild("Backpack") and Plr:FindFirstChild("Backpack") then
if MyPlr.Backpack:FindFirstChild("Knife") or MyChar:FindFirstChild("Knife") then
if (Plr.Backpack:FindFirstChild("Gun") or Plr.Backpack:FindFirstChild("Revolver")) or (Plr.Character:FindFirstChild("Gun") or Plr.Character:FindFirstChild("Revolver")) then
PickedColor = Vexana.Colors.Enemy
else
PickedColor = Color3.new(1, 135 / 255, 0)
end
elseif (MyPlr.Backpack:FindFirstChild("Gun") or MyPlr.Backpack:FindFirstChild("Revolver")) or (MyChar:FindFirstChild("Gun") or MyChar:FindFirstChild("Revolver")) then
if Plr.Backpack:FindFirstChild("Knife") or Plr.Character:FindFirstChild("Knife") then
PickedColor = Vexana.Colors.Enemy
else
PickedColor = Vexana.Colors.Ally
end
else
if Plr.Backpack:FindFirstChild("Knife") or Plr.Character:FindFirstChild("Knife") then
PickedColor = Vexana.Colors.Enemy
elseif (Plr.Backpack:FindFirstChild("Gun") or Plr.Backpack:FindFirstChild("Revolver")) or (Plr.Character:FindFirstChild("Gun") or Plr.Character:FindFirstChild("Revolver")) then
PickedColor = Vexana.Colors.Ally
else
PickedColor = Vexana.Colors.Neutral
end
end
end
elseif game.PlaceId == 379614936 then
if Vexana.Colors.ColorOverride == nil then
if not Vexana.FriendList[Plr.Name] then
local targ = MyPlr:FindFirstChild("PlayerGui"):FindFirstChild("ScreenGui"):FindFirstChild("UI"):FindFirstChild("Target"):FindFirstChild("Img"):FindFirstChild("PlayerText")
if targ then
if Plr.Name:lower() == targ.Text:lower() then
PickedColor = Vexana.Colors.Enemy
else
PickedColor = Vexana.Colors.Neutral
end
else
PickedColor = Vexana.Colors.Neutral
end
else
PickedColor = Vexana.Colors.Friend
end
else
PickedColor = Vexana.Colors.ColorOverride
end
elseif game.PlaceId == 983224898 then
if (tick() - wildrevolvertick) > 10 or wildrevolverteamdata == nil then
wildrevolverteamdata = RepStor.Functions.RequestGameData:InvokeServer()
wildrevolvertick = tick()
return Vexana.Colors.Neutral
end
local succ = pcall(function()
if wildrevolverteamdata[Plr.Name] ~= nil then
if Vexana.Colors.ColorOverride == nil then
if not Vexana.FriendList[Plr.Name] then
if wildrevolverteamdata[Plr.Name]["TeamName"] == wildrevolverteamdata[MyPlr.Name]["TeamName"] then
PickedColor = Vexana.Colors.Ally
else
PickedColor = Vexana.Colors.Enemy
end
else
PickedColor = Vexana.Colors.Friend
end
else
PickedColor = Vexana.Colors.ColorOverride
end
else
PickedColor = Vexana.Colors.Neutral
end
end)
if not succ then
wildrevolverteamdata = RepStor.Functions.RequestGameData:InvokeServer()
wildrevolvertick = tick()
return Vexana.Colors.Neutral
end
else
if Vexana.Colors.ColorOverride == nil then
if not Vexana.FreeForAll then
if MyPlr.Team ~= Plr.Team and not Vexana.FriendList[Plr.Name] then
PickedColor = Vexana.Colors.Enemy
elseif MyPlr.Team == Plr.Team and not Vexana.FriendList[Plr.Name] then
PickedColor = Vexana.Colors.Ally
else
PickedColor = Vexana.Colors.Friend
end
else
if Vexana.FriendList[Plr.Name] ~= nil then
PickedColor = Vexana.Colors.Friend
else
PickedColor = Vexana.Colors.Enemy
end
end
else
PickedColor = Vexana.Colors.ColorOverride
end
end
end

return PickedColor
end

function FindCham(Obj)
for i, v in next, ItemChams:GetChildren() do
if v.className == "ObjectValue" then
if v.Value == Obj then
return v.Parent
end
end
end

return nil
end

function FindESP(Obj)
for i, v in next, ItemESP:GetChildren() do
if v.className == "ObjectValue" then
if v.Value == Obj then
return v.Parent
end
end
end

return nil
end

function GetFirstPart(Obj)
for i, v in next, Obj:GetDescendants() do
if v:IsA("BasePart") then
return v
end
end

return nil
end

function GetSizeOfObject(Obj)
if Obj:IsA("BasePart") then
return Obj.Size
elseif Obj:IsA("Model") then
return Obj:GetExtentsSize()
end
end

function GetClosestPlayerNotBehindWall()
local Players = { }
local CurrentClosePlayer = nil
local SelectedPlr = nil

for _, v in next, Plrs:GetPlayers() do
if v ~= MyPlr and not Vexana.Blacklist[v.Name] then
local IsAlly = GetTeamColor(v)
if IsAlly ~= Vexana.Colors.Ally and IsAlly ~= Vexana.Colors.Friend and IsAlly ~= Vexana.Colors.Neutral then
local GetChar = v.Character
if MyChar and GetChar then
local MyHead, MyTor = MyChar:FindFirstChild("Head"), MyChar:FindFirstChild("HumanoidRootPart")
local GetHead, GetTor, GetHum = GetChar:FindFirstChild("Head"), GetChar:FindFirstChild("HumanoidRootPart"), GetChar:FindFirstChild("Humanoid")

if MyHead and MyTor and GetHead and GetTor and GetHum then
if game.PlaceId == 455366377 then
if not GetChar:FindFirstChild("KO") and GetHum.Health > 1 then
local Ray = Ray.new(MyCam.CFrame.p, (GetHead.Position - MyCam.CFrame.p).unit * 2048)
local part = workspace:FindPartOnRayWithIgnoreList(Ray, {MyChar})
if part ~= nil then
if part:IsDescendantOf(GetChar) then
local Dist = (MyTor.Position - GetTor.Position).magnitude
Players[v] = Dist
end
end
end
elseif game.PlaceId == 746820961 then
if GetHum.Health > 1 then
local Ray = Ray.new(MyCam.CFrame.p, (GetHead.Position - MyCam.CFrame.p).unit * 2048)
local part = workspace:FindPartOnRayWithIgnoreList(Ray, {MyChar, MyCam})
if part ~= nil then
if part:IsDescendantOf(GetChar) then
local Dist = (MyTor.Position - GetTor.Position).magnitude
Players[v] = Dist
end
end
end
else
if GetHum.Health > 1 then
local Ray = Ray.new(MyCam.CFrame.p, (GetHead.Position - MyCam.CFrame.p).unit * 2048)
local part = workspace:FindPartOnRayWithIgnoreList(Ray, {MyChar})
if part ~= nil then
if part:IsDescendantOf(GetChar) then
local Dist = (MyTor.Position - GetTor.Position).magnitude
Players[v] = Dist
end
end
end
end
end
end
end
end
end

for i, v in next, Players do
if CurrentClosePlayer ~= nil then
if v <= CurrentClosePlayer then
CurrentClosePlayer = v
SelectedPlr = i
end
else
CurrentClosePlayer = v
SelectedPlr = i
end
end

return SelectedPlr
end

function GetClosestPlayer()
local Players = { }
local CurrentClosePlayer = nil
local SelectedPlr = nil

for _, v in next, Plrs:GetPlayers() do
if v ~= MyPlr then
local IsAlly = GetTeamColor(v)
if IsAlly ~= Vexana.Colors.Ally and IsAlly ~= Vexana.Colors.Friend and IsAlly ~= Vexana.Colors.Neutral then
local GetChar = v.Character
if MyChar and GetChar then
local MyTor = MyChar:FindFirstChild("HumanoidRootPart")
local GetTor = GetChar:FindFirstChild("HumanoidRootPart")
local GetHum = GetChar:FindFirstChild("Humanoid")
if MyTor and GetTor and GetHum then
if game.PlaceId == 455366377 then
if not GetChar:FindFirstChild("KO") and GetHum.Health > 1 then
local Dist = (MyTor.Position - GetTor.Position).magnitude
Players[v] = Dist
end
else
if GetHum.Health > 1 then
local Dist = (MyTor.Position - GetTor.Position).magnitude
Players[v] = Dist
end
end
end
end
end
end
end

for i, v in next, Players do
if CurrentClosePlayer ~= nil then
if v <= CurrentClosePlayer then
CurrentClosePlayer = v
SelectedPlr = i
end
else
CurrentClosePlayer = v
SelectedPlr = i
end
end

return SelectedPlr
end

function FindPlayer(Txt)
local ps = { }
for _, v in next, Plrs:GetPlayers() do
if string.lower(string.sub(v.Name, 1, string.len(Txt))) == string.lower(Txt) then
table.insert(ps, v)
end
end

if #ps == 1 then
if ps[1] ~= MyPlr then
return ps[1]
else
return nil
end
else
return nil
end
end

function UpdateESP(Plr)
if Plr ~= nil then
local Find = PlayerESP:FindFirstChild("ESP Crap_" .. Plr.Name)
if Find then
local PickColor = GetTeamColor(Plr)
Find.Frame.Names.TextColor3 = PickColor
Find.Frame.Dist.TextColor3 = PickColor
Find.Frame.Health.TextColor3 = PickColor
--Find.Frame.Pos.TextColor3 = PickColor
local GetChar = Plr.Character
if MyChar and GetChar then
local Find2 = MyChar:FindFirstChild("HumanoidRootPart")
local Find3 = GetChar:FindFirstChild("HumanoidRootPart")
local Find4 = GetChar:FindFirstChildOfClass("Humanoid")
if Find2 and Find3 then
local pos = Find3.Position
local Dist = (Find2.Position - pos).magnitude
if Dist > Vexana.ESPLength or Vexana.Blacklist[Plr.Name] then
Find.Frame.Names.Visible = false
Find.Frame.Dist.Visible = false
Find.Frame.Health.Visible = false
return
else
Find.Frame.Names.Visible = true
Find.Frame.Dist.Visible = true
Find.Frame.Health.Visible = true
end
Find.Frame.Dist.Text = string.format("%.0f", Dist) .. " Meters"
--Find.Frame.Pos.Text = "(X: " .. string.format("%.0f", pos.X) .. ", Y: " .. string.format("%.0f", pos.Y) .. ", Z: " .. string.format("%.0f", pos.Z) .. ")"
if Find4 then
Find.Frame.Health.Text = "Health: " .. string.format("%.0f", Find4.Health)
else
Find.Frame.Health.Text = ""
end
end
end
end
end
end

function RemoveESP(Obj)
if Obj ~= nil then
local IsPlr = Obj:IsA("Player")
local UseFolder = ItemESP
if IsPlr then UseFolder = PlayerESP end

local FindESP = ((IsPlr) and UseFolder:FindFirstChild("ESP Crap_" .. Obj.Name)) or FindESP(Obj)
if FindESP then
FindESP:Destroy()
end
end
end

function CreateESP(Obj)
if Obj ~= nil then
local IsPlr = Obj:IsA("Player")
local UseFolder = ItemESP
local GetChar = ((IsPlr) and Obj.Character) or Obj
local Head = GetChar:FindFirstChild("Head")
local t = tick()
if IsPlr then UseFolder = PlayerESP end
if Head == nil then
repeat
Head = GetChar:FindFirstChild("Head")
wait()
until Head ~= nil or (tick() - t) >= 10
end
if Head == nil then return end

local bb = Instance.new("BillboardGui")
bb.Adornee = Head
bb.ExtentsOffset = Vector3.new(0, 1, 0)
bb.AlwaysOnTop = true
bb.Size = UDim2.new(0, 5, 0, 5)
bb.StudsOffset = Vector3.new(0, 3, 0)
bb.Name = "ESP Crap_" .. Obj.Name
bb.Parent = UseFolder

local frame = Instance.new("Frame", bb)
frame.ZIndex = 10
frame.BackgroundTransparency = 1
frame.Size = UDim2.new(1, 0, 1, 0)

local TxtName = Instance.new("TextLabel", frame)
TxtName.Name = "Names"
TxtName.ZIndex = 10
TxtName.Text = Obj.Name
TxtName.BackgroundTransparency = 1
TxtName.Position = UDim2.new(0, 0, 0, -45)
TxtName.Size = UDim2.new(1, 0, 10, 0)
TxtName.Font = "SourceSansBold"
TxtName.TextSize = 13
TxtName.TextStrokeTransparency = 0.5

local TxtDist = nil
local TxtHealth = nil
if IsPlr then
TxtDist = Instance.new("TextLabel", frame)
TxtDist.Name = "Dist"
TxtDist.ZIndex = 10
TxtDist.Text = ""
TxtDist.BackgroundTransparency = 1
TxtDist.Position = UDim2.new(0, 0, 0, -35)
TxtDist.Size = UDim2.new(1, 0, 10, 0)
TxtDist.Font = "SourceSansBold"
TxtDist.TextSize = 13
TxtDist.TextStrokeTransparency = 0.5

TxtHealth = Instance.new("TextLabel", frame)
TxtHealth.Name = "Health"
TxtHealth.ZIndex = 10
TxtHealth.Text = ""
TxtHealth.BackgroundTransparency = 1
TxtHealth.Position = UDim2.new(0, 0, 0, -25)
TxtHealth.Size = UDim2.new(1, 0, 10, 0)
TxtHealth.Font = "SourceSansBold"
TxtHealth.TextSize = 13
TxtHealth.TextStrokeTransparency = 0.5
else
local ObjVal = Instance.new("ObjectValue", bb)
ObjVal.Value = Obj
end

local PickColor = GetTeamColor(Obj) or Vexana.Colors.Neutral
TxtName.TextColor3 = PickColor

if IsPlr then
TxtDist.TextColor3 = PickColor
TxtHealth.TextColor3 = PickColor
end
end
end

function UpdateTracer(Plr)
if Vexana.TracersEnabled then
if MyChar then
local MyTor = MyChar:FindFirstChild("HumanoidRootPart")
local GetTor = TracerData[Plr.Name]
if MyTor and GetTor ~= nil and GetTor.Parent ~= nil then
local Dist = (MyTor.Position - GetTor.Position).magnitude
if (Dist <Vexana.TracersLength and not Vexana.Blacklist[Plr.Name]) and not (MyChar:FindFirstChild("InVehicle") or GetTor.Parent:FindFirstChild("InVehicle")) then
if not Vexana.PlaceTracersUnderCharacter then
local R = MyCam:ScreenPointToRay(MyCam.ViewportSize.X / 2, MyCam.ViewportSize.Y, 0)
Dist = (R.Origin - (GetTor.Position - Vector3.new(0, 3, 0))).magnitude
Tracers[Plr.Name].Transparency = 1
Tracers[Plr.Name].Size = Vector3.new(0.05, 0.05, Dist)
Tracers[Plr.Name].CFrame = CFrame.new(R.Origin, (GetTor.Position - Vector3.new(0, 4.5, 0))) * CFrame.new(0, 0, -Dist / 2)
Tracers[Plr.Name].BrickColor = BrickColor.new(GetTeamColor(Plr))
Tracers[Plr.Name].BoxHandleAdornment.Transparency = 0
Tracers[Plr.Name].BoxHandleAdornment.Size = Vector3.new(0.001, 0.001, Dist)
Tracers[Plr.Name].BoxHandleAdornment.Color3 = GetTeamColor(Plr)
else
Dist = (MyTor.Position - (GetTor.Position - Vector3.new(0, 3, 0))).magnitude
Tracers[Plr.Name].Transparency = 1
Tracers[Plr.Name].Size = Vector3.new(0.3, 0.3, Dist)
Tracers[Plr.Name].CFrame = CFrame.new(MyTor.Position - Vector3.new(0, 3, 0), (GetTor.Position - Vector3.new(0, 4.5, 0))) * CFrame.new(0, 0, -Dist / 2)
Tracers[Plr.Name].BrickColor = BrickColor.new(GetTeamColor(Plr))
Tracers[Plr.Name].BoxHandleAdornment.Transparency = 0
Tracers[Plr.Name].BoxHandleAdornment.Size = Vector3.new(0.05, 0.05, Dist)
Tracers[Plr.Name].BoxHandleAdornment.Color3 = GetTeamColor(Plr)
end
else
Tracers[Plr.Name].Transparency = 1
Tracers[Plr.Name].BoxHandleAdornment.Transparency = 1
end
end
end
end
end

function RemoveTracers(Plr)
local Find = Tracers:FindFirstChild(Plr.Name)
if Find then
Find:Destroy()
end
end

function CreateTracers(Plr)
local Find = Tracers:FindFirstChild(Plr.Name)
if not Find then
local P = Instance.new("Part")
P.Name = Plr.Name
P.Material = "Neon"
P.Transparency = 1
P.Anchored = true
P.Locked = true
P.CanCollide = false
local B = Instance.new("BoxHandleAdornment", P)
B.Adornee = P
B.Size = GetSizeOfObject(P)
B.AlwaysOnTop = true
B.ZIndex = 5
B.Transparency = 0
B.Color3 = GetTeamColor(Plr) or Vexana.Colors.Neutral
P.Parent = Tracers

coroutine.resume(coroutine.create(function()
while Tracers:FindFirstChild(Plr.Name) do
UpdateTracer(Plr)
Run.RenderStepped:wait()
end
end))
end
end

function UpdateChams(Obj)
if Obj == nil then return end

if Obj:IsA("Player") then
local Find = PlayerChams:FindFirstChild(Obj.Name)
local GetChar = Obj.Character

local Trans = 0
if GetChar and MyChar then
local GetHead = GetChar:FindFirstChild("Head")
local GetTor = GetChar:FindFirstChild("HumanoidRootPart")
local MyHead = MyChar:FindFirstChild("Head")
local MyTor = MyChar:FindFirstChild("HumanoidRootPart")
if GetHead and GetTor and MyHead and MyTor then
if (MyTor.Position - GetTor.Position).magnitude > Vexana.CHAMSLength or Vexana.Blacklist[Obj.Name] then
Trans = 1
else
--local MyCharStuff = MyChar:GetDescendants()
local Ray = Ray.new(MyCam.CFrame.p, (GetTor.Position - MyCam.CFrame.p).unit * 2048)
local part = workspace:FindPartOnRayWithIgnoreList(Ray, {MyChar})
if part ~= nil then
if part:IsDescendantOf(GetChar) then
Trans = 0.9
else
Trans = 0
end
end
end
end
end

if Find then
for i, v in next, Find:GetChildren() do
if v.className ~= "ObjectValue" then
v.Color3 = GetTeamColor(Obj) or Vexana.Colors.Neutral
v.Transparency = Trans
end
end
end
end
end

function RemoveChams(Obj)
if Obj ~= nil then
local IsPlr = Obj:IsA("Player")
local UseFolder = ItemChams
if IsPlr then UseFolder = PlayerChams end

local FindC = UseFolder:FindFirstChild(tostring(Obj)) or FindCham(Obj)
if FindC then
FindC:Destroy()
end
end
end

function CreateChams(Obj)
if Obj ~= nil then
local IsPlr = Obj:IsA("Player")
local UseFolder = ItemChams
local Crap = nil
local GetTor = nil
local t = tick()
if IsPlr then
Obj = Obj.Character
UseFolder = PlayerChams
end
if Obj == nil then return end
GetTor = Obj:FindFirstChild("HumanoidRootPart") or Obj:WaitForChild("HumanoidRootPart")
if IsPlr then Crap = Obj:GetChildren() else Crap = Obj:GetDescendants() end

local FindC = ((IsPlr) and UseFolder:FindFirstChild(Obj.Name)) or FindCham(Obj)
if not FindC then
FindC = Instance.new("Folder", UseFolder)
FindC.Name = Obj.Name
local ObjVal = Instance.new("ObjectValue", FindC)
ObjVal.Value = Obj
end

for _, P in next, Crap do
if P:IsA("PVInstance") and P.Name ~= "HumanoidRootPart" then
local Box = Instance.new("BoxHandleAdornment")
Box.Size = GetSizeOfObject(P)
Box.Name = "Cham"
Box.Adornee = P
Box.AlwaysOnTop = true
Box.ZIndex = 5
Box.Transparency = 0
Box.Color3 = ((IsPlr) and GetTeamColor(Plrs:GetPlayerFromCharacter(Obj))) or Vexana.Colors.Neutral
Box.Parent = FindC
end
end
end
end

function CreateMobESPChams()
local mobspawn = { }

for i, v in next, workspace:GetDescendants() do
local hum = v:FindFirstChildOfClass("Humanoid")
if hum and not Plrs:GetPlayerFromCharacter(hum.Parent) and FindCham(v) == nil and FindESP(v) == nil then
mobspawn[tostring(v.Parent)] = v.Parent
if Vexana.CHAMSEnabled and Vexana.MobChams then
CreateChams(v)
end
if Vexana.ESPEnabled and Vexana.MobESP then
CreateESP(v)
end
end
end

if Vexana.Mob_ESP_CHAMS_Ran_Once == false then
for i, v in next, mobspawn do
v.ChildAdded:connect(function(Obj)
if Vexana.MobChams then
local t = tick()
local GetHum = Obj:FindFirstChildOfClass("Humanoid")
if GetHum == nil then
repeat
GetHum = Obj:FindFirstChildOfClass("Humanoid")
wait()
until GetHum ~= nil or (tick() - t) >= 10
end
if GetHum == nil then return end

CreateChams(Obj)
end

if Vexana.MobESP then
local t = tick()
local GetHum = Obj:FindFirstChildOfClass("Humanoid")
if GetHum == nil then
repeat
GetHum = Obj:FindFirstChildOfClass("Humanoid")
wait()
until GetHum ~= nil or (tick() - t) >= 10
end
if GetHum == nil then return end

CreateESP(Obj)
end
end)
end

Vexana.Mob_ESP_CHAMS_Ran_Once = true
end
end

function CreateChildAddedEventFor(Obj)
Obj.ChildAdded:connect(function(Obj2)
if Vexana.OutlinesEnabled then
if Obj2:IsA("BasePart") and not Plrs:GetPlayerFromCharacter(Obj2.Parent) and not Obj2.Parent:IsA("Hat") and not Obj2.Parent:IsA("Accessory") and Obj2.Parent.Name ~= "Tracers" then
local Data = { }
Data[2] = Obj2.Transparency
Obj2.Transparency = 1
local outline = Instance.new("SelectionBox")
outline.Name = "Outline"
outline.Color3 = Color3.new(0, 0, 0)
outline.SurfaceColor3 = Color3.new(0, 1, 0)
--outline.SurfaceTransparency = 0.9
outline.LineThickness = 0.01
outline.Transparency = 0.5
outline.Transparency = 0.5
outline.Adornee = Obj2
outline.Parent = Obj2
Data[1] = outline
rawset(Vexana.OutlinedParts, Obj2, Data)
end

for i, v in next, Obj2:GetDescendants() do
if v:IsA("BasePart") and not Plrs:GetPlayerFromCharacter(v.Parent) and not v.Parent:IsA("Hat") and not v.Parent:IsA("Accessory") and v.Parent.Name ~= "Tracers" then
local Data = { }
Data[2] = v.Transparency
v.Transparency = 1
local outline = Instance.new("SelectionBox")
outline.Name = "Outline"
outline.Color3 = Color3.new(0, 0, 0)
outline.SurfaceColor3 = Color3.new(0, 1, 0)
--outline.SurfaceTransparency = 0.9
outline.LineThickness = 0.01
outline.Transparency = 0.5
outline.Adornee = v
outline.Parent = v
Data[1] = outline
rawset(Vexana.OutlinedParts, v, Data)
end
CreateChildAddedEventFor(v)
end
end
CreateChildAddedEventFor(Obj2)
end)
end

function LightingHax()
if Vexana.OutlinesEnabled then
Light.TimeOfDay = "00:00:00"
end

if Vexana.FullbrightEnabled then
Light.Ambient = Color3.new(1, 1, 1)
Light.ColorShift_Bottom = Color3.new(1, 1, 1)
Light.ColorShift_Top = Color3.new(1, 1, 1)
end
end

Plrs.PlayerAdded:connect(function(Plr)
if Vexana.CharAddedEvent[Plr.Name] == nil then
Vexana.CharAddedEvent[Plr.Name] = Plr.CharacterAdded:connect(function(Char)
if Vexana.ESPEnabled then
RemoveESP(Plr)
CreateESP(Plr)
end
if Vexana.CHAMSEnabled then
RemoveChams(Plr)
CreateChams(Plr)
end
if Vexana.TracersEnabled then
CreateTracers(Plr)
end
repeat wait() until Char:FindFirstChild("HumanoidRootPart")
TracerMT[Plr.Name] = Char.HumanoidRootPart
end)
end
end)

Plrs.PlayerRemoving:connect(function(Plr)
if Vexana.CharAddedEvent[Plr.Name] ~= nil then
Vexana.CharAddedEvent[Plr.Name]:Disconnect()
Vexana.CharAddedEvent[Plr.Name] = nil
end
RemoveESP(Plr)
RemoveChams(Plr)
RemoveTracers(Plr)
TracerMT[Plr.Name] = nil
end)


-- Objects

local Library = 
loadstring(Game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()
local Window_1 = Library:NewWindow("Frogge | Main")

local Tab1 = Window_1:NewSection("ESP")

Tab1:CreateToggle("Esp", function(boolean)
Vexana.ESPEnabled = not Vexana.ESPEnabled
if Vexana.ESPEnabled then
for _, v in next, Plrs:GetPlayers() do
if v ~= MyPlr then
if Vexana.CharAddedEvent[v.Name] == nil then
Vexana.CharAddedEvent[v.Name] = v.CharacterAdded:connect(function(Char)
if Vexana.ESPEnabled then
RemoveESP(v)
CreateESP(v)
end
if Vexana.CHAMSEnabled then
RemoveChams(v)
CreateChams(v)
end
if Vexana.TracersEnabled then
RemoveTracers(v)
CreateTracers(v)
end
repeat wait() until Char:FindFirstChild("HumanoidRootPart")
TracerMT[v.Name] = Char.HumanoidRootPart
end)
end
RemoveESP(v)
CreateESP(v)
end
end
CreateMobESPChams()
else
PlayerESP:ClearAllChildren()
ItemESP:ClearAllChildren()
end
end)

Tab1:CreateToggle("Visual X-Ray", function(boolean)
Vexana.CHAMSEnabled = not Vexana.CHAMSEnabled
if Vexana.CHAMSEnabled then
for _, v in next, Plrs:GetPlayers() do
if v ~= MyPlr then
if Vexana.CharAddedEvent[v.Name] == nil then
Vexana.CharAddedEvent[v.Name] = v.CharacterAdded:connect(function(Char)
if Vexana.ESPEnabled then
RemoveESP(v)
CreateESP(v)
end
if Vexana.CHAMSEnabled then
RemoveChams(v)
CreateChams(v)
end
if Vexana.TracersEnabled then
RemoveTracers(v)
CreateTracers(v)
end
repeat wait() until Char:FindFirstChild("HumanoidRootPart")
TracerMT[v.Name] = Char.HumanoidRootPart
end)
end
RemoveChams(v)
CreateChams(v)
end
end
CreateMobESPChams()
else
PlayerChams:ClearAllChildren()
ItemChams:ClearAllChildren()
end
end)

Tab1:CreateToggle("Tracers", function(boolean)
Vexana.TracersEnabled = not Vexana.TracersEnabled
if Vexana.TracersEnabled then
for _, v in next, Plrs:GetPlayers() do
if v ~= MyPlr then
if Vexana.CharAddedEvent[v.Name] == nil then
Vexana.CharAddedEvent[v.Name] = v.CharacterAdded:connect(function(Char)
if Vexana.ESPEnabled then
RemoveESP(v)
CreateESP(v)
end
if Vexana.CHAMSEnabled then
RemoveChams(v)
CreateChams(v)
end
if Vexana.TracersEnabled then
RemoveTracers(v)
CreateTracers(v)
end
end)
end
if v.Character ~= nil then
local Tor = v.Character:FindFirstChild("HumanoidRootPart")
if Tor then
TracerMT[v.Name] = Tor
end
end
RemoveTracers(v)
CreateTracers(v)
end
end
else
for _, v in next, Plrs:GetPlayers() do
RemoveTracers(v)
end
end
end)

Tab1:CreateToggle("Debug", function(boolean)
Vexana.DebugInfo = not Vexana.DebugInfo
DebugMenu["Main"].Visible = Vexana.DebugInfo
if Vexana.DebugInfo then
            print('?')
else
            print('?')
end
end)

Tab1:CreateToggle("Visual Map X-Ray", function(boolean)
Vexana.OutlinesEnabled = not Vexana.OutlinesEnabled
if Vexana.OutlinesEnabled then
for _, v in next, workspace:GetDescendants() do
if v:IsA("BasePart") and not Plrs:GetPlayerFromCharacter(v.Parent) and not v.Parent:IsA("Hat") and not v.Parent:IsA("Accessory") and v.Parent.Name ~= "Tracers" then
local Data = { }
Data[2] = v.Transparency
v.Transparency = 1
local outline = Instance.new("SelectionBox")
outline.Name = "Outline"
outline.Color3 = Color3.new(0, 0, 0)
outline.SurfaceColor3 = Color3.new(0, 1, 0)
--outline.SurfaceTransparency = 0.9
outline.LineThickness = 0.01
outline.Transparency = 0.3
outline.Adornee = v
outline.Parent = v
Data[1] = outline
rawset(Vexana.OutlinedParts, v, Data)
end
CreateChildAddedEventFor(v)
end
CreateChildAddedEventFor(workspace)
if Vexana.LightingEvent == nil then
Vexana.LightingEvent = game:GetService("Lighting").Changed:connect(LightingHax)
end
else
for i, v in next, Vexana.OutlinedParts do
i.Transparency = v[2]
v[1]:Destroy()
end
end
end)

Tab1:CreateToggle("Fullbright", function(boolean)
Vexana.FullbrightEnabled = not Vexana.FullbrightEnabled
if Vexana.FullbrightEnabled then
if Vexana.LightingEvent == nil then
Vexana.LightingEvent = Light.Changed:connect(LightingHax)
end
else
Light.Ambient = Vexana.AmbientBackup
Light.ColorShift_Bottom = Vexana.ColorShiftBotBackup
Light.ColorShift_Top = Vexana.ColorShiftTopBackup
end
end)

Tab1:CreateToggle("crosshair", function(boolean)
Vexana.CrosshairEnabled = not Vexana.CrosshairEnabled
if Vexana.CrosshairEnabled then
local g = Instance.new("ScreenGui", CoreGui)
g.Name = "Corsshair"
local line1 = Instance.new("TextLabel", g)
line1.Text = ""
line1.Size = UDim2.new(0, 35, 0, 1)
line1.BackgroundColor3 = Vexana.Colors.Crosshair
line1.BorderSizePixel = 0
line1.ZIndex = 10
local line2 = Instance.new("TextLabel", g)
line2.Text = ""
line2.Size = UDim2.new(0, 1, 0, 35)
line2.BackgroundColor3 = Vexana.Colors.Crosshair
line2.BorderSizePixel = 0
line2.ZIndex = 10

            local viewport = MyCam.ViewportSize
            local centerx = viewport.X / 2
            local centery = viewport.Y / 2

            line1.Position = UDim2.new(0, centerx - (35 / 2), 0, centery - 35)
            line2.Position = UDim2.new(0, centerx, 0, centery - (35 / 2) - 35)

            print('?')
else
local find = CoreGui:FindFirstChild("Corsshair")
if find then
find:Destroy()
end
            
            print('?')
end
end)

Run:BindToRenderStep("UpdateESP", Enum.RenderPriority.Character.Value, function()
for _, v in next, Plrs:GetPlayers() do
if v ~= MyPlr then
UpdateESP(v)
end
end
end)

Run:BindToRenderStep("UpdateInfo", 1000, function()
Vexana.ClosestEnemy = GetClosestPlayer()
MyChar = MyPlr.Character
if Vexana.DebugInfo then
local MyHead, MyTor, MyHum = MyChar:FindFirstChild("Head"), MyChar:FindFirstChild("HumanoidRootPart"), MyChar:FindFirstChild("Humanoid")

local GetChar, GetHead, GetTor, GetHum = nil, nil, nil, nil
if Vexana.ClosestEnemy ~= nil then
GetChar = Vexana.ClosestEnemy.Character
GetHead = GetChar:FindFirstChild("Head")
GetTor = GetChar:FindFirstChild("HumanoidRootPart")
GetHum = GetChar:FindFirstChild("Humanoid")

DebugMenu["PlayerSelected"].Text = "Enemies around: " .. tostring(Vexana.ClosestEnemy)

if Vexana.ClosestEnemy.Team ~= nil then
DebugMenu["PlayerTeam"].Text = "Team: " .. tostring(Vexana.ClosestEnemy.Team)
else
DebugMenu["PlayerTeam"].Text = "Team: None"
end

if GetHum then
DebugMenu["PlayerHealth"].Text = "Health: " .. string.format("%.0f", GetHum.Health)
end
if MyTor and GetTor then
local Pos = GetTor.Position
local Dist = (MyTor.Position - Pos).magnitude
DebugMenu["PlayerPosition"].Text = "Position: (X: " .. string.format("%.3f", Pos.X) .. " Y: " .. string.format("%.3f", Pos.Y) .. " Z: " .. string.format("%.3f", Pos.Z) .. ") Distance: " .. string.format("%.0f", Dist) .. "m"

local MyCharStuff = MyChar:GetDescendants()
local GetCharStuff = GetChar:GetDescendants()
for _, v in next, GetCharStuff do
if v ~= GetTor then
table.insert(MyCharStuff, v)
end
end
local Ray = Ray.new(MyTor.Position, (Pos - MyTor.Position).unit * 300)
local part = workspace:FindPartOnRayWithIgnoreList(Ray, MyCharStuff)
if part == GetTor then
DebugMenu["BehindWall"].Text = "Player hiding: Hide"
else
DebugMenu["BehindWall"].Text = "Player hiding: Not hiding"
end

DebugMenu["Main"].Size = UDim2.new(0, DebugMenu["PlayerPosition"].TextBounds.X, 0, 200)
end
end

-- My Position
if MyTor then
local Pos = MyTor.Position
DebugMenu["Position"].Text = "My Position: (X: " .. string.format("%.3f", Pos.x) .. " Y: " .. string.format("%.3f", Pos.Y) .. " Z: " .. string.format("%.3f", Pos.Z) .. ")"
end

-- FPS
local fps = math.floor(.5 + (1 / (tick() - LastTick)))
local sum = 0
local ave = 0
table.insert(Vexana.FPSAverage, fps)
for i = 1, #Vexana.FPSAverage do
sum = sum + Vexana.FPSAverage[i]
end
DebugMenu["FPS"].Text = "FPS: " .. tostring(fps) .. " Average: " .. string.format("%.0f", (sum / #Vexana.FPSAverage))
if (tick() - LastTick) >= 15 then
Vexana.FPSAverage = { }
LastTick = tick()
end
LastTick = tick()
end
wait()
end)

local Players = game.Players
Players.PlayerAdded:Connect(function(player)
JoinSection:CreateButton(player.Name, function()
   setclipboard(''..player.Name..'')
   set()
end)
wait()
end)

local Players = game.Players
Players.PlayerRemoving:Connect(function(player)
LeaveSection:CreateButton(player.Name, function()
   setclipboard(''..player.Name..'')
   set()
end)
wait()
end)
