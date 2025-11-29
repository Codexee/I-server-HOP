local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")

local frameWidth, frameHeight, timeLimit = 75, 75, 180

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local idleTime = 0
local lastPos = rootPart.Position

local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, frameWidth, 0, frameHeight)
frame.Position = UDim2.new(0.5, -frameWidth/2, 0.5, -frameHeight/2)
frame.BackgroundColor3 = Color3.new(1, 1, 1)
frame.BackgroundTransparency = 0.45
frame.ClipsDescendants = true
frame.BorderSizePixel = 0
frame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0.3, 0)
frameCorner.Parent = frame

local timerLabel = Instance.new("TextLabel")
timerLabel.Size = UDim2.new(1, 0, 1, 0)
timerLabel.BackgroundTransparency = 1
timerLabel.BorderSizePixel = 0
timerLabel.Text = "0"
timerLabel.TextScaled = true
timerLabel.Font = Enum.Font.GothamBold
timerLabel.TextColor3 = Color3.new(0, 0, 0)
timerLabel.TextXAlignment = Enum.TextXAlignment.Center
timerLabel.TextYAlignment = Enum.TextYAlignment.Center
timerLabel.Parent = frame

local textConstraint = Instance.new("UITextSizeConstraint")
textConstraint.MaxTextSize = frameHeight/2
textConstraint.Parent = timerLabel

local dragging = false
local dragInput, dragStart, startPos

local function updateInput(input)
    local d = input.Position - dragStart
    frame.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + d.X,
        startPos.Y.Scale, startPos.Y.Offset + d.Y
    )
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

task.spawn(function()
    while task.wait(1) do
        local pos = rootPart.Position
        if (pos - lastPos).Magnitude < 0.1 then
            idleTime += 1
        else
            idleTime = 0
        end
        lastPos = pos
        timerLabel.Text = tostring(idleTime)
        if idleTime >= timeLimit then
            TeleportService:Teleport(game.PlaceId, player)
        end
    end
end)
Save
New
Duplicate & Edit
Raw Text