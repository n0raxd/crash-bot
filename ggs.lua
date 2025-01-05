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
    search(game.ReplicatedStorage)
    search(game.ServerStorage)

    return keypads
end

-- Get all keypads from Gear Machines
local foundKeypads = findGearMachineKeypads()

-- Print and store keypads globally for debugging purposes
for index, keypad in ipairs(foundKeypads) do
    _G["keypad" .. index] = keypad
    print("keypad" .. index .. ": " .. keypad:GetFullName())
end

-- Variable to keep track of the current keypad being processed
local currentKeypad

-- Function to simulate typing on the keypad
function typegear(inputValue)
    if not currentKeypad then
        warn("No keypad selected.")
        return
    end

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
end

-- Process all keypads found
for _, keypad in ipairs(foundKeypads) do
    currentKeypad = keypad -- Set the current keypad
    fireclickdetector(keypad:FindFirstChild("Clear"):FindFirstChild("RangeC"))
    typegear(_G.gearid) -- Example input sequence, replace with your own
end
local RunService = game:GetService("RunService")

local heartbeatConnection

heartbeatConnection = RunService.Heartbeat:Connect(function()
    if _G.running == true then  -- Check if _G.running is true
        for _, keypad in ipairs(foundKeypads) do
            local enterButton = keypad:FindFirstChild("Enter")
            if enterButton then
                local clickDetector = enterButton:FindFirstChild("RangeC")
                if clickDetector then
                    fireclickdetector(clickDetector)
                end
            end
        end
    elseif _G.running == false then  -- If _G.running is false, clear the keypads
        for _, keypad in ipairs(foundKeypads) do
            local clearButton = keypad:FindFirstChild("Clear")
            if clearButton then
                local clearClickDetector = clearButton:FindFirstChild("RangeC")
                if clearClickDetector then
                    fireclickdetector(clearClickDetector)
                    print("Cleared keypad: " .. keypad.Name)
                else
                    warn("Click detector 'RangeC' not found in Clear button for keypad: " .. keypad.Name)
                end
            else
                warn("'Clear' button not found in keypad: " .. keypad.Name)
            end
        end
        
        -- Disconnect the heartbeat loop after clearing the keypads
        if heartbeatConnection then
            heartbeatConnection:Disconnect()
            print("Heartbeat loop disconnected after clearing keypads.")
        end
    end
end)
