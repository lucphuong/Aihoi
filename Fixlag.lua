-- ⚡ FixLag_99 | Script giảm lag cực mạnh (xoá gần như toàn bộ hiệu ứng & bầu trời)
-- Upload file này lên GitHub rồi dùng lệnh loadstring bên dưới:
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/<username>/<repo>/main/FixLag_99.lua"))()

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

local function safe(fn)
    local s,e = pcall(fn)
    if not s then warn("FixLag_99 lỗi nhỏ:", e) end
end

-- Xoá hiệu ứng Lighting
safe(function()
	for _,v in pairs(Lighting:GetChildren()) do
		if v:IsA("Sky") or v:IsA("BloomEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Atmosphere") then
			v:Destroy()
		end
	end
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 1e10
	Lighting.Brightness = 2
	pcall(function()
		Lighting.EnvironmentDiffuseScale = 0
		Lighting.EnvironmentSpecularScale = 0
	end)
end)

-- Xoá hiệu ứng từng object
local function clean(obj)
	safe(function()
		if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Explosion") then
			obj:Destroy()
		elseif obj:IsA("Decal") or obj:IsA("Texture") then
			obj:Destroy()
		elseif obj:IsA("BasePart") or obj:IsA("MeshPart") then
			obj.Material = Enum.Material.SmoothPlastic
			obj.Reflectance = 0
			obj.CastShadow = false
			pcall(function() obj.Color = Color3.new(0.8,0.8,0.8) end)
			if obj:IsA("MeshPart") then obj.TextureID = "" end
		end
	end)
end

for _,v in pairs(Workspace:GetDescendants()) do
	clean(v)
end

Workspace.DescendantAdded:Connect(function(obj)
	RunService.Heartbeat:Wait()
	clean(obj)
end)

safe(function()
	local terrain = Workspace:FindFirstChildOfClass("Terrain")
	if terrain then
		terrain.WaterWaveSize = 0
		terrain.WaterWaveSpeed = 0
		terrain.WaterReflectance = 0
		terrain.WaterTransparency = 1
	end
end)

safe(function()
	if Player:FindFirstChild("PlayerGui") then
		for _,g in pairs(Player.PlayerGui:GetDescendants()) do
			if g:IsA("ImageLabel") or g:IsA("ImageButton") then
				g.Image = ""
			end
		end
	end
end)

safe(function()
	if settings and settings().Rendering then
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	end
end)

safe(function()
	StarterGui:SetCore("SendNotification", {
		Title = "✅ FixLag_99",
		Text = "Đã xoá bầu trời, hiệu ứng & 99% đồ họa!",
		Duration = 4
	})
end)
