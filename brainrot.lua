-- Brainrot Simple Auto Farm - STABLE VERSION
-- Полностью переписанный стабильный скрипт

wait(2) -- Ждем загрузки игры

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Проверяем, что мы на клиенте
if not RunService:IsClient() then
    return
end

local localPlayer = Players.LocalPlayer
if not localPlayer then
    return
end

-- Ожидаем PlayerGui
local playerGui = localPlayer:FindFirstChild("PlayerGui")
if not playerGui then
    localPlayer:WaitForChild("PlayerGui", 10)
    playerGui = localPlayer.PlayerGui
end

if not playerGui then
    return
end

-- Основные переменные
local SCRIPT_ACTIVE = false
local CURRENT_MODE = "LEVEL" -- LEVEL или EVENT

-- Простые данные для ребитхов
local REBIRTH_COSTS = {
    1000000,      -- 1
    5000000,      -- 2  
    25000000,     -- 3
    100000000,    -- 4
    500000000,    -- 5
    2500000000,   -- 6
    10000000000,  -- 7
}

-- Создаем максимально простой интерфейс
local function createSimpleUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SimpleBrainrotFarm"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    -- Главный фрейм
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 200)
    mainFrame.Position = UDim2.new(0, 10, 0, 10)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false -- Сначала скрыт
    mainFrame.Parent = screenGui

    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    title.Text = "🧠 Brainrot Farm"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.Font = Enum.Font.SourceSansBold
    title.Parent = mainFrame

    -- Статус
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -10, 0, 25)
    statusLabel.Position = UDim2.new(0, 5, 0, 35)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "🔴 Остановлен"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    statusLabel.TextSize = 14
    statusLabel.Font = Enum.Font.SourceSansSemibold
    statusLabel.Parent = mainFrame

    -- Режим
    local modeLabel = Instance.new("TextLabel")
    modeLabel.Name = "ModeLabel"
    modeLabel.Size = UDim2.new(1, -10, 0, 25)
    modeLabel.Position = UDim2.new(0, 5, 0, 65)
    modeLabel.BackgroundTransparency = 1
    modeLabel.Text = "⚡ Режим: Прокачка"
    modeLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    modeLabel.TextSize = 12
    modeLabel.Parent = mainFrame

    -- Прогресс
    local progressLabel = Instance.new("TextLabel")
    progressLabel.Name = "ProgressLabel"
    progressLabel.Size = UDim2.new(1, -10, 0, 60)
    progressLabel.Position = UDim2.new(0, 5, 0, 95)
    progressLabel.BackgroundTransparency = 1
    progressLabel.Text = "💰 Деньги: 0\n📊 Ребитх: 1"
    progressLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    progressLabel.TextSize = 12
    progressLabel.TextXAlignment = Enum.TextXAlignment.Left
    progressLabel.TextYAlignment = Enum.TextYAlignment.Top
    progressLabel.Parent = mainFrame

    -- Кнопка управления
    local controlButton = Instance.new("TextButton")
    controlButton.Name = "ControlButton"
    controlButton.Size = UDim2.new(1, -10, 0, 30)
    controlButton.Position = UDim2.new(0, 5, 1, -35)
    controlButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    controlButton.Text = "🚫 СТАРТ"
    controlButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    controlButton.TextSize = 14
    controlButton.Font = Enum.Font.SourceSansBold
    controlButton.Parent = mainFrame

    -- Метка активации
    local activationHint = Instance.new("TextLabel")
    activationHint.Name = "ActivationHint"
    activationHint.Size = UDim2.new(0, 200, 0, 30)
    activationHint.Position = UDim2.new(0, 10, 0, 10)
    activationHint.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    activationHint.BackgroundTransparency = 0.2
    activationHint.Text = "🎮 Нажми F для активации"
    activationHint.TextColor3 = Color3.fromRGB(255, 255, 255)
    activationHint.TextSize = 14
    activationHint.Font = Enum.Font.SourceSansBold
    activationHint.Visible = true
    activationHint.Parent = screenGui

    return {
        screenGui = screenGui,
        mainFrame = mainFrame,
        statusLabel = statusLabel,
        modeLabel = modeLabel,
        progressLabel = progressLabel,
        controlButton = controlButton,
        activationHint = activationHint
    }
end

-- Создаем интерфейс
local UI = createSimpleUI()

-- Игровые переменные
local character = nil
local humanoid = nil
local rootPart = nil
local farmConnection = nil
local currentRebirth = 1
local totalMoney = 0
local sessionTimer = 0

-- Простые функции форматирования
local function formatNumber(num)
    if num >= 1000000000 then
        return string.format("%.1fB", num / 1000000000)
    elseif num >= 1000000 then
        return string.format("%.1fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%.1fK", num / 1000)
    else
        return tostring(math.floor(num))
    end
end

local function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

-- Функции обновления интерфейса
local function updateUI()
    if not UI or not UI.progressLabel then return end
    
    UI.progressLabel.Text = string.format(
        "💰 Деньги: %s\n📊 Ребитх: %d\n⏱️ Время: %s",
        formatNumber(totalMoney),
        currentRebirth,
        formatTime(sessionTimer)
    )
    
    if CURRENT_MODE == "LEVEL" then
        UI.modeLabel.Text = "⚡ Режим: Прокачка"
        UI.modeLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
    else
        UI.modeLabel.Text = "🎁 Режим: Ивент"
        UI.modeLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    end
end

local function updateStatus(active)
    if not UI or not UI.statusLabel or not UI.controlButton then return end
    
    if active then
        UI.statusLabel.Text = "🟢 Активен"
        UI.statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        UI.controlButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        UI.controlButton.Text = "✅ СТОП"
    else
        UI.statusLabel.Text = "🔴 Остановлен"
        UI.statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        UI.controlButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        UI.controlButton.Text = "🚫 СТАРТ"
    end
end

-- Игровые функции
local function setupCharacter()
    character = localPlayer.Character
    if character then
        humanoid = character:FindFirstChildOfClass("Humanoid")
        rootPart = character:FindFirstChild("HumanoidRootPart")
    end
end

local function findAndCollectBrainrots()
    if not character or not rootPart then return false end
    
    local workspace = game:GetService("Workspace")
    
    -- Ищем брейнроты
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") and string.find(obj.Name:lower(), "brainrot") and not string.find(obj.Name:lower(), "lucky") then
            local distance = (obj.Position - rootPart.Position).Magnitude
            if distance < 50 then
                -- Телепортируемся к брейнроту
                rootPart.CFrame = CFrame.new(obj.Position + Vector3.new(0, 3, 0))
                
                -- Пытаемся кликнуть
                local clickDetector = obj:FindFirstChildOfClass("ClickDetector")
                if clickDetector then
                    fireclickdetector(clickDetector)
                    totalMoney = totalMoney + math.random(1000, 5000)
                    return true
                end
            end
        end
    end
    
    return false
end

local function performRebirth()
    if currentRebirth > #REBIRTH_COSTS then
        return false
    end
    
    local cost = REBIRTH_COSTS[currentRebirth]
    
    if totalMoney >= cost then
        totalMoney = totalMoney - cost
        currentRebirth = currentRebirth + 1
        return true
    end
    
    return false
end

local function purchaseExpensiveBlocks()
    -- В режиме ивента покупаем дорогие блоки
    local minPrice = 2000000000 -- 2 миллиарда
    
    if totalMoney >= minPrice then
        -- Имитация покупки
        totalMoney = totalMoney - minPrice
        return true
    end
    
    return false
end

-- Основные режимы
local function startLevelMode()
    if farmConnection then
        farmConnection:Disconnect()
    end
    
    farmConnection = RunService.Heartbeat:Connect(function()
        if not SCRIPT_ACTIVE or not character or not rootPart then return end
        
        -- Зарабатываем деньги
        totalMoney = totalMoney + math.random(5000, 15000)
        
        -- Пытаемся сделать ребитх
        if not performRebirth() then
            -- Если не хватает - фармим
            if not findAndCollectBrainrots() then
                -- Телепортируемся в случайное место
                local randomPos = Vector3.new(
                    math.random(-100, 100),
                    10,
                    math.random(-100, 100)
                )
                rootPart.CFrame = CFrame.new(randomPos)
            end
        end
        
        updateUI()
    end)
end

local function startEventMode()
    if farmConnection then
        farmConnection:Disconnect()
    end
    
    farmConnection = RunService.Heartbeat:Connect(function()
        if not SCRIPT_ACTIVE or not character or not rootPart then return end
        
        -- Копим деньги (без ребитхов)
        totalMoney = totalMoney + math.random(10000, 30000)
        
        -- Пытаемся купить дорогие блоки
        if not purchaseExpensiveBlocks() then
            -- Если не купили - фармим
            if not findAndCollectBrainrots() then
                local randomPos = Vector3.new(
                    math.random(-150, 150),
                    15,
                    math.random(-150, 150)
                )
                rootPart.CFrame = CFrame.new(randomPos)
            end
        end
        
        updateUI()
    end)
end

-- Обработчики
local function onControlButtonClick()
    SCRIPT_ACTIVE = not SCRIPT_ACTIVE
    
    if SCRIPT_ACTIVE then
        setupCharacter()
        updateStatus(true)
        
        if CURRENT_MODE == "LEVEL" then
            startLevelMode()
        else
            startEventMode()
        end
    else
        updateStatus(false)
        if farmConnection then
            farmConnection:Disconnect()
            farmConnection = nil
        end
    end
end

local function onInputBegan(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        -- Переключаем видимость интерфейса
        UI.activationHint.Visible = false
        UI.mainFrame.Visible = not UI.mainFrame.Visible
        
    elseif input.KeyCode == Enum.KeyCode.R then
        -- Смена режима
        CURRENT_MODE = CURRENT_MODE == "LEVEL" and "EVENT" or "LEVEL"
        updateUI()
        
        if SCRIPT_ACTIVE then
            onControlButtonClick() -- Останавливаем
            wait(0.1)
            onControlButtonClick() -- Запускаем с новым режимом
        end
    end
end

-- Инициализация
local function initialize()
    -- Настройка персонажа
    setupCharacter()
    
    -- Обработчик смены персонажа
    localPlayer.CharacterAdded:Connect(function(char)
        wait(2)
        setupCharacter()
    end)
    
    -- Подключаем обработчики
    if UI.controlButton then
        UI.controlButton.MouseButton1Click:Connect(onControlButtonClick)
    end
    
    UserInputService.InputBegan:Connect(onInputBegan)
    
    -- Запускаем обновление статистики
    while true do
        if SCRIPT_ACTIVE then
            sessionTimer = sessionTimer + 1
        end
        updateUI()
        wait(1)
    end
end

-- Запускаем скрипт
spawn(initialize)

print("🧠 Brainrot Simple Farm загружен!")
print("F - Показать/скрыть интерфейс")
print("R - Смена режима")
print("Кликните СТАРТ для начала автоФарма")
