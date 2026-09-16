-- QUAS.lua
-- Roblox Studio version

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local KEY = "mazentaman"

local remote = ReplicatedStorage:WaitForChild("QUAS_Action")

local gui = Instance.new("ScreenGui")
gui.Name = "QUAS"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(420, 500)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(10, 20, 42)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 55)
title.BackgroundTransparency = 1
title.Text = "QUAS"
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = main

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, -40, 0, 42)
keyBox.Position = UDim2.fromOffset(20, 65)
keyBox.PlaceholderText = "Enter QUAS key"
keyBox.Text = ""
keyBox.TextSize = 16
keyBox.TextColor3 = Color3.new(1, 1, 1)
keyBox.BackgroundColor3 = Color3.fromRGB(25, 40, 70)
keyBox.Parent = main

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 8)
keyCorner.Parent = keyBox

local unlock = Instance.new("TextButton")
unlock.Size = UDim2.new(1, -40, 0, 42)
unlock.Position = UDim2.fromOffset(20, 115)
unlock.Text = "UNLOCK"
unlock.Font = Enum.Font.GothamBold
unlock.TextSize = 16
unlock.TextColor3 = Color3.new(1, 1, 1)
unlock.BackgroundColor3 = Color3.fromRGB(35, 70, 130)
unlock.Parent = main

local unlockCorner = Instance.new("UICorner")
unlockCorner.CornerRadius = UDim.new(0, 8)
unlockCorner.Parent = unlock

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -40, 0, 25)
status.Position = UDim2.fromOffset(20, 165)
status.BackgroundTransparency = 1
status.Text = "LOCKED"
status.TextSize = 14
status.TextColor3 = Color3.fromRGB(180, 180, 180)
status.Parent = main

local function makeButton(text, x, y, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.fromOffset(175, 42)
	button.Position = UDim2.fromOffset(x, y)
	button.Text = text
	button.Font = Enum.Font.GothamBold
	button.TextSize = 14
	button.TextColor3 = Color3.new(1, 1, 1)
	button.BackgroundColor3 = Color3.fromRGB(24, 43, 78)
	button.Parent = main

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = button

	button.Activated:Connect(callback)

	return button
end

local authenticated = false

unlock.Activated:Connect(function()
	remote:FireServer("Authenticate", {
		key = keyBox.Text
	})
end)

remote.OnClientEvent:Connect(function(message, value)
	if message == "AuthResult" then
		authenticated = value == true

		if authenticated then
			status.Text = "UNLOCKED"
			status.TextColor3 = Color3.fromRGB(100, 255, 150)
		else
			status.Text = "INVALID KEY"
			status.TextColor3 = Color3.fromRGB(255, 100, 100)
		end
	end
end)

makeButton("FLING EVERYONE", 20, 210, function()
	if not authenticated then return end

	remote:FireServer("Fling", {
		mode = "Everyone"
	})
end)

makeButton("FLING NON-FRIENDS", 215, 210, function()
	if not authenticated then return end

	remote:FireServer("Fling", {
		mode = "NonFriends"
	})
end)

makeButton("ANTI-SIT ON", 20, 265, function()
	if not authenticated then return end

	remote:FireServer("AntiSit", {
		enabled = true
	})
end)

makeButton("ANTI-SIT OFF", 215, 265, function()
	if not authenticated then return end

	remote:FireServer("AntiSit", {
		enabled = false
	})
end)

makeButton("RESET", 20, 320, function()
	if not authenticated then return end

	remote:FireServer("Reset")
end)

makeButton("HIDE", 215, 320, function()
	main.Visible = false
end)
