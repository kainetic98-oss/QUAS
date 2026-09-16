local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local old = PlayerGui:FindFirstChild("QUAS")
if old then
    old:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "QUAS"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

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

local authenticated = false
local KEY = "mazentaman"

unlock.Activated:Connect(function()
    if keyBox.Text == KEY then
        authenticated = true
        status.Text = "UNLOCKED"
        status.TextColor3 = Color3.fromRGB(100, 255, 150)
    else
        authenticated = false
        status.Text = "INVALID KEY"
        status.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

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

    button.Activated:Connect(function()
        if authenticated then
            callback()
        end
    end)

    return button
end

local antiSit = false

local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if not humanoid then
        return
    end

    humanoid.StateChanged:Connect(function(_, newState)
        if antiSit and newState == Enum.HumanoidStateType.Seated then
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end

if player.Character then
    setupCharacter(player.Character)
end

player.CharacterAdded:Connect(setupCharacter)

makeButton("ANTI-SIT ON", 20, 210, function()
    antiSit = true
end)

makeButton("ANTI-SIT OFF", 215, 210, function()
    antiSit = false
end)

makeButton("RESET CHARACTER", 20, 265, function()
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid.Health = 0
    end
end)

makeButton("HIDE", 215, 265, function()
    main.Visible = false
end)

makeButton("SHOW", 20, 320, function()
    main.Visible = true
end)

makeButton("RELOAD GUI", 215, 320, function()
    main.Visible = false
    task.wait()
    main.Visible = true
end)

local UserInputService = game:GetService("UserInputService")

local dragging = false
local dragStart
local startPos

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        local delta = input.Position - dragStart

        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

print("[QUAS] Loaded successfully")
