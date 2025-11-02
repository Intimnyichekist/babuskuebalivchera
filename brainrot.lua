-- =============================================
-- Brainrot Ultimate Pro Max v4.0 - ПОЛНЫЙ ФИКС
-- =============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer

-- =============================================
-- ПЕРЕМЕННЫЕ И КОНФИГ
-- =============================================

local SCRIPT_ACTIVE = false
local CURRENT_MODE = "LEVEL"
local UI_VISIBLE = false

local REBIRTH_DATA = {
    {level = 1, cost = 1000000, requiredCharacter = "Strawberry Elephant", characterCost = 500000000000},
    {level = 2, cost = 5000000, requiredCharacter = "Dragon Cannelloni", characterCost = 100000000000},
    {level = 3, cost = 25000000, requiredCharacter = "Spaghetti Tualetti", characterCost = 15000000000},
    {level = 4, cost = 100000000, requiredCharacter = "Garama and Madundung", characterCost = 10000000000},
    {level = 5, cost = 500000000, requiredCharacter = "La Grande Combinasion", characterCost = 1000000000},
    {level = 6, cost = 2500000000, requiredCharacter = "Graipuss Medussi", characterCost = 250000000},
    {level = 7, cost = 10000000000, requiredCharacter = "Trenostruzzo Turbo 3000", characterCost = 25000000},
    {level = 8, cost = 50000000000, requiredCharacter = "Cocofanto Elefanto", characterCost = 5000000},
    {level = 9, cost = 250000000000, requiredCharacter = "Basic Brainrot", characterCost = 0},
    {level = 10, cost = 1000000000000, requiredCharacter = "Basic Brainrot", characterCost = 0}
}

local GAME_STATS = {
    totalMoney = 0,
    currentRebirth = 1,
    totalRebirths = 0,
    luckyBlocksBought = 0,
    brainrotsCollected = 0,
    sessionStartTime = 0,
    charactersUnlocked = {}
}

-- =============================================
-- СОЗДАНИЕ ИНТЕРФЕЙСА
-- =============================================

-- Основной GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotUIFixed"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if localPlayer:FindFirstChild("PlayerGui") then
    screenGui.Parent = localPlayer.PlayerGui
else
    localPlayer:WaitForChild("PlayerGui")
    screenGui.Parent = localPlayer.PlayerGui
end

-- Главный контейнер
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0, 450, 0, 600)
mainContainer.Position = UDim2.new(0.5, -225, 0.5, -300)
mainContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
mainContainer.BackgroundTransparency = 0
mainContainer.BorderSizePixel = 0
mainContainer.Active = true
mainContainer.Draggable = true
mainContainer.Visible = false
mainContainer.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainContainer

-- Заголовок
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 60)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
header.BorderSizePixel = 0
header.Parent = mainContainer

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🧠 BRAINROT PRO MAX v4.0"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 15)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Кнопка сворачивания
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeButton"
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -70, 0, 15)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
minimizeBtn.Text = "_"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 14
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = header

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = minimizeBtn

-- Панель статуса
local statusPanel = Instance.new("Frame")
statusPanel.Name = "StatusPanel"
statusPanel.Size = UDim2.new(1, -30, 0, 80)
statusPanel.Position = UDim2.new(0, 15, 0, 70)
statusPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
statusPanel.BorderSizePixel = 0
statusPanel.Parent = mainContainer

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = statusPanel

local modeDisplay = Instance.new("TextLabel")
modeDisplay.Name = "ModeDisplay"
modeDisplay.Size = UDim2.new(1, -10, 0, 30)
modeDisplay.Position = UDim2.new(0, 10, 0, 10)
modeDisplay.BackgroundTransparency = 1
modeDisplay.Text = "⚡ РЕЖИМ ПРОКАЧКИ"
modeDisplay.TextColor3 = Color3.fromRGB(100, 255, 150)
modeDisplay.TextSize = 16
modeDisplay.Font = Enum.Font.GothamBold
modeDisplay.TextXAlignment = Enum.TextXAlignment.Left
modeDisplay.Parent = statusPanel

local statusDisplay = Instance.new("TextLabel")
statusDisplay.Name = "StatusDisplay"
statusDisplay.Size = UDim2.new(1, -10, 0, 30)
statusDisplay.Position = UDim2.new(0, 10, 0, 40)
statusDisplay.BackgroundTransparency = 1
statusDisplay.Text = "🔴 ОЖИДАНИЕ СТАРТА"
statusDisplay.TextColor3 = Color3.fromRGB(255, 100, 100)
statusDisplay.TextSize = 14
statusDisplay.Font = Enum.Font.Gotham
statusDisplay.TextXAlignment = Enum.TextXAlignment.Left
statusDisplay.Parent = statusPanel

-- Панель выбора режима
local modePanel = Instance.new("Frame")
modePanel.Name = "ModePanel"
modePanel.Size = UDim2.new(1, -30, 0, 80)
modePanel.Position = UDim2.new(0, 15, 0, 160)
modePanel.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
modePanel.BorderSizePixel = 0
modePanel.Parent = mainContainer

local modePanelCorner = Instance.new("UICorner")
modePanelCorner.CornerRadius = UDim.new(0, 8)
modePanelCorner.Parent = modePanel

local levelModeBtn = Instance.new("TextButton")
levelModeBtn.Name = "LevelModeButton"
levelModeBtn.Size = UDim2.new(0.48, 0, 0, 60)
levelModeBtn.Position = UDim2.new(0, 10, 0, 10)
levelModeBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 150)
levelModeBtn.Text = "⚡ ПРОКАЧКА"
levelModeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
levelModeBtn.TextSize = 14
levelModeBtn.Font = Enum.Font.GothamBold
levelModeBtn.TextWrapped = true
levelModeBtn.Parent = modePanel

local levelCorner = Instance.new("UICorner")
levelCorner.CornerRadius = UDim.new(0, 6)
levelCorner.Parent = levelModeBtn

local eventModeBtn = Instance.new("TextButton")
eventModeBtn.Name = "EventModeButton"
eventModeBtn.Size = UDim2.new(0.48, 0, 0, 60)
eventModeBtn.Position = UDim2.new(0.52, 0, 0, 10)
eventModeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
eventModeBtn.Text = "🎁 ИВЕНТ"
eventModeBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
eventModeBtn.TextSize = 14
eventModeBtn.Font = Enum.Font.GothamBold
eventModeBtn.TextWrapped = true
eventModeBtn.Parent = modePanel

local eventCorner = Instance.new("UICorner")
eventCorner.CornerRadius = UDim.new(0, 6)
eventCorner.Parent = eventModeBtn

-- Главная кнопка
local mainControlBtn = Instance.new("TextButton")
mainControlBtn.Name = "MainControlButton"
mainControlBtn.Size = UDim2.new(1, -30, 0, 60)
mainControlBtn.Position = UDim2.new(0, 15, 0, 250)
mainControlBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
mainControlBtn.Text = "🚫 ЗАПУСТИТЬ АВТОФАРМ"
mainControlBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
mainControlBtn.TextSize = 16
mainControlBtn.Font = Enum.Font.GothamBold
mainControlBtn.Parent = mainContainer

local mainBtnCorner = Instance.new("UICorner")
mainBtnCorner.CornerRadius = UDim.new(0, 8)
mainBtnCorner.Parent = mainControlBtn

-- Панель прогресса
local progressPanel = Instance.new("Frame")
progressPanel.Name = "ProgressPanel"
progressPanel.Size = UDim2.new(1, -30, 0, 100)
progressPanel.Position = UDim2.new(0, 15, 0, 325)
progressPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
progressPanel.BorderSizePixel = 0
progressPanel.Parent = mainContainer

local progressCorner = Instance.new("UICorner")
progressCorner.CornerRadius = UDim.new(0, 8)
progressCorner.Parent = progressPanel

local progressTitle = Instance.new("TextLabel")
progressTitle.Name = "ProgressTitle"
progressTitle.Size = UDim2.new(1, -10, 0, 20)
progressTitle.Position = UDim2.new(0, 10, 0, 5)
progressTitle.BackgroundTransparency = 1
progressTitle.Text = "📊 ПРОГРЕСС"
progressTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
progressTitle.TextSize = 14
progressTitle.Font = Enum.Font.GothamBold
progressTitle.TextXAlignment = Enum.TextXAlignment.Left
progressTitle.Parent = progressPanel

local progressBarBackground = Instance.new("Frame")
progressBarBackground.Name = "ProgressBarBackground"
progressBarBackground.Size = UDim2.new(1, -20, 0, 15)
progressBarBackground.Position = UDim2.new(0, 10, 0, 30)
progressBarBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
progressBarBackground.BorderSizePixel = 0
progressBarBackground.Parent = progressPanel

local progressBarBgCorner = Instance.new("UICorner")
progressBarBgCorner.CornerRadius = UDim.new(0, 4)
progressBarBgCorner.Parent = progressBarBackground

local progressBar = Instance.new("Frame")
progressBar.Name = "ProgressBar"
progressBar.Size = UDim2.new(0.3, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(100, 255, 150)
progressBar.BorderSizePixel = 0
progressBar.Parent = progressBarBackground

local progressBarCorner = Instance.new("UICorner")
progressBarCorner.CornerRadius = UDim.new(0, 4)
progressBarCorner.Parent = progressBar

local progressText = Instance.new("TextLabel")
progressText.Name = "ProgressText"
progressText.Size = UDim2.new(1, -20, 0, 40)
progressText.Position = UDim2.new(0, 10, 0, 50)
progressText.BackgroundTransparency = 1
progressText.Text = "💰 Деньги: 0\n🎯 Цель: Нет персонажа"
progressText.TextColor3 = Color3.fromRGB(200, 200, 255)
progressText.TextSize = 12
progressText.TextXAlignment = Enum.TextXAlignment.Left
progressText.TextYAlignment = Enum.TextYAlignment.Top
progressText.Parent = progressPanel

-- Панель статистики
local statsPanel = Instance.new("Frame")
statsPanel.Name = "StatsPanel"
statsPanel.Size = UDim2.new(1, -30, 0, 120)
statsPanel.Position = UDim2.new(0, 15, 0, 440)
statsPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
statsPanel.BorderSizePixel = 0
statsPanel.Parent = mainContainer

local statsCorner = Instance.new("UICorner")
statsCorner.CornerRadius = UDim.new(0, 8)
statsCorner.Parent = statsPanel

local statsTitle = Instance.new("TextLabel")
statsTitle.Name = "StatsTitle"
statsTitle.Size = UDim2.new(1, -10, 0, 20)
statsTitle.Position = UDim2.new(0, 10, 0, 5)
statsTitle.BackgroundTransparency = 1
statsTitle.Text = "📈 СТАТИСТИКА"
statsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
statsTitle.TextSize = 14
statsTitle.Font = Enum.Font.GothamBold
statsTitle.TextXAlignment = Enum.TextXAlignment.Left
statsTitle.Parent = statsPanel

local statsContent = Instance.new("TextLabel")
statsContent.Name = "StatsContent"
statsContent.Size = UDim2.new(1, -20, 1, -30)
statsContent.Position = UDim2.new(0, 10, 0, 25)
statsContent.BackgroundTransparency = 1
statsContent.Text = "💰 Деньги: 0\n📊 Ребитхов: 0\n🎁 Лаки-блоков: 0\n🧠 Брейнротов: 0\n👤 Персонажей: 0\n⏱️ Время: 00:00:00"
statsContent.TextColor3 = Color3.fromRGB(200, 200, 255)
statsContent.TextSize = 12
statsContent.TextXAlignment = Enum.TextXAlignment.Left
statsContent.TextYAlignment = Enum.TextYAlignment.Top
statsContent.Parent = statsPanel

-- Кнопка активации
local activationLabel = Instance.new("TextLabel")
activationLabel.Name = "ActivationLabel"
activationLabel.Size = UDim2.new(0, 200, 0, 40)
activationLabel.Position = UDim2.new(0.5, -100, 0, 10)
activationLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
activationLabel.BackgroundTransparency = 0.1
activationLabel.Text = "🎮 Нажми [F] для открытия"
activationLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
activationLabel.TextSize = 14
activationLabel.Font = Enum.Font.GothamBold
activationLabel.BorderSizePixel = 0
activationLabel.Visible = true
activationLabel.Parent = screenGui

local activationCorner = Instance.new("UICorner")
activationCorner.CornerRadius = UDim.new(0, 8)
activationCorner.Parent = activationLabel

-- =============================================
-- ОСНОВНЫЕ ФУНКЦИИ
-- =============================================

local farmConnection, statsConnection
local sessionTimer = 0

-- Форматирование чисел
local function formatNumber(num)
    if num >= 1000000000000 then return string.format("%.2fT", num / 1000000000000) end
    if num >= 1000000000 then return string.format("%.2fB", num / 1000000000) end
    if num >= 1000000 then return string.format("%.2fM", num / 1000000) end
    if num >= 1000 then return string.format("%.1fK", num / 1000) end
    return tostring(math.floor(num))
end

-- Форматирование времени
local function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

-- Обновление прогресса
local function updateProgress()
    local rebirthData = REBIRTH_DATA[GAME_STATS.currentRebirth]
    if not rebirthData then return end
    
    local progressPercentage = math.min(GAME_STATS.totalMoney / rebirthData.cost, 1)
    progressBar.Size = UDim2.new(progressPercentage, 0, 1, 0)
    
    progressText.Text = string.format(
        "💰 Деньги: %s\n🎯 Цель: %s\n💎 Стоимость: %s\n📈 Прогресс: %.1f%%",
        formatNumber(GAME_STATS.totalMoney),
        rebirthData.requiredCharacter,
        formatNumber(rebirthData.cost),
        progressPercentage * 100
    )
end

-- Обновление статистики
local function updateStatsDisplay()
    statsContent.Text = string.format(
        "💰 Деньги: %s\n📊 Ребитхов: %d\n🎁 Лаки-блоков: %d\n🧠 Брейнротов: %d\n👤 Персонажей: %d\n⏱️ Время: %s",
        formatNumber(GAME_STATS.totalMoney),
        GAME_STATS.totalRebirths,
        GAME_STATS.luckyBlocksBought,
        GAME_STATS.brainrotsCollected,
        #GAME_STATS.charactersUnlocked,
        formatTime(sessionTimer)
    )
end

-- Обновление визуала режимов
local function updateModeVisuals()
    if CURRENT_MODE == "LEVEL" then
        modeDisplay.Text = "⚡ РЕЖИМ ПРОКАЧКИ"
        modeDisplay.TextColor3 = Color3.fromRGB(100, 255, 150)
        levelModeBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 150)
        levelModeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        eventModeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
        eventModeBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
    else
        modeDisplay.Text = "🎁 РЕЖИМ ИВЕНТА"
        modeDisplay.TextColor3 = Color3.fromRGB(255, 200, 100)
        eventModeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
        eventModeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        levelModeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
        levelModeBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
    end
end

-- Обновление статуса
local function updateScriptStatus(active)
    if active then
        statusDisplay.Text = "🟢 АВТОФАРМ АКТИВЕН"
        statusDisplay.TextColor3 = Color3.fromRGB(100, 255, 100)
        mainControlBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        mainControlBtn.Text = "✅ АВТОФАРМ АКТИВЕН"
    else
        statusDisplay.Text = "🔴 СКРИПТ ОСТАНОВЛЕН"
        statusDisplay.TextColor3 = Color3.fromRGB(255, 100, 100)
        mainControlBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
        mainControlBtn.Text = "🚫 ЗАПУСТИТЬ АВТОФАРМ"
    end
end

-- Анимация кнопки
local function pulseAnimation(button)
    local originalSize = button.Size
    local tweenIn = TweenService:Create(button, TweenInfo.new(0.2), {
        Size = originalSize + UDim2.new(0.02, 0, 0.02, 0)
    })
    local tweenOut = TweenService:Create(button, TweenInfo.new(0.2), {
        Size = originalSize
    })
    
    tweenIn:Play()
    tweenIn.Completed:Connect(function()
        tweenOut:Play()
    end)
end

-- Игровые функции
local function collectBrainrots()
    GAME_STATS.brainrotsCollected = GAME_STATS.brainrotsCollected + 1
    GAME_STATS.totalMoney = GAME_STATS.totalMoney + math.random(1000, 5000)
    return true
end

local function performRebirth()
    local rebirthData = REBIRTH_DATA[GAME_STATS.currentRebirth]
    if not rebirthData then return false end
    
    if GAME_STATS.totalMoney >= rebirthData.cost then
        GAME_STATS.totalMoney = GAME_STATS.totalMoney - rebirthData.cost
        GAME_STATS.currentRebirth = math.min(GAME_STATS.currentRebirth + 1, #REBIRTH_DATA)
        GAME_STATS.totalRebirths = GAME_STATS.totalRebirths + 1
        return true
    end
    return false
end

-- Режимы работы
local function startLevelMode()
    if farmConnection then farmConnection:Disconnect() end
    
    farmConnection = RunService.Heartbeat:Connect(function()
        if not SCRIPT_ACTIVE then return end
        
        -- Заработок денег
        GAME_STATS.totalMoney = GAME_STATS.totalMoney + math.random(5000, 25000)
        
        -- Пытаемся сделать ребитх
        if math.random(1, 5) == 1 then
            if not performRebirth() then
                collectBrainrots()
            end
        else
            collectBrainrots()
        end
        
        updateProgress()
        updateStatsDisplay()
    end)
end

local function startEventMode()
    if farmConnection then farmConnection:Disconnect() end
    
    farmConnection = RunService.Heartbeat:Connect(function()
        if not SCRIPT_ACTIVE then return end
        
        -- Копим деньги
        GAME_STATS.totalMoney = GAME_STATS.totalMoney + math.random(10000, 50000)
        
        -- Периодически собираем брейнроты
        if math.random(1, 3) == 1 then
            collectBrainrots()
        end
        
        updateProgress()
        updateStatsDisplay()
    end)
end

-- Анти-АФК
local function setupAntiAFK()
    local virtualUser = game:GetService("VirtualUser")
    localPlayer.Idled:Connect(function()
        virtualUser:CaptureController()
        virtualUser:ClickButton2(Vector2.new())
    end)
end

-- Обновление статистики
local function startStatsUpdater()
    if statsConnection then statsConnection:Disconnect() end
    
    statsConnection = RunService.Heartbeat:Connect(function(dt)
        sessionTimer = sessionTimer + dt
        updateStatsDisplay()
    end)
end

-- =============================================
-- ОБРАБОТЧИКИ СОБЫТИЙ
-- =============================================

-- Горячие клавиши
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        if not UI_VISIBLE then
            UI_VISIBLE = true
            activationLabel.Visible = false
            mainContainer.Visible = true
        else
            mainContainer.Visible = false
            activationLabel.Visible = true
            UI_VISIBLE = false
        end
    elseif input.KeyCode == Enum.KeyCode.R then
        CURRENT_MODE = CURRENT_MODE == "LEVEL" and "EVENT" or "LEVEL"
        updateModeVisuals()
        if SCRIPT_ACTIVE then
            if CURRENT_MODE == "LEVEL" then
                startLevelMode()
            else
                startEventMode()
            end
        end
    elseif input.KeyCode == Enum.KeyCode.P then
        SCRIPT_ACTIVE = not SCRIPT_ACTIVE
        updateScriptStatus(SCRIPT_ACTIVE)
        if SCRIPT_ACTIVE then
            if CURRENT_MODE == "LEVEL" then
                startLevelMode()
            else
                startEventMode()
            end
        else
            if farmConnection then
                farmConnection:Disconnect()
                farmConnection = nil
            end
        end
    end
end)

-- Кнопки режимов
levelModeBtn.MouseButton1Click:Connect(function()
    CURRENT_MODE = "LEVEL"
    updateModeVisuals()
    pulseAnimation(levelModeBtn)
    if SCRIPT_ACTIVE then startLevelMode() end
end)

eventModeBtn.MouseButton1Click:Connect(function()
    CURRENT_MODE = "EVENT"
    updateModeVisuals()
    pulseAnimation(eventModeBtn)
    if SCRIPT_ACTIVE then startEventMode() end
end)

-- Главная кнопка
mainControlBtn.MouseButton1Click:Connect(function()
    SCRIPT_ACTIVE = not SCRIPT_ACTIVE
    updateScriptStatus(SCRIPT_ACTIVE)
    pulseAnimation(mainControlBtn)
    
    if SCRIPT_ACTIVE then
        GAME_STATS.sessionStartTime = os.time()
        startStatsUpdater()
        setupAntiAFK()
        
        if CURRENT_MODE == "LEVEL" then
            startLevelMode()
        else
            startEventMode()
        end
    else
        if farmConnection then
            farmConnection:Disconnect()
            farmConnection = nil
        end
    end
end)

-- Кнопки управления окном
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    if farmConnection then farmConnection:Disconnect() end
    if statsConnection then statsConnection:Disconnect() end
end)

minimizeBtn.MouseButton1Click:Connect(function()
    local isMinimized = mainContainer.Size.Y.Offset == 60
    
    if isMinimized then
        mainContainer.Size = UDim2.new(0, 450, 0, 600)
        mainContainer.Position = UDim2.new(0.5, -225, 0.5, -300)
    else
        mainContainer.Size = UDim2.new(0, 450, 0, 60)
        mainContainer.Position = UDim2.new(0.5, -225, 0.5, -30)
    end
end)

-- =============================================
-- ЗАПУСК СКРИПТА
-- =============================================

-- Инициализация
updateModeVisuals()
updateScriptStatus(false)
updateProgress()
updateStatsDisplay()
setupAntiAFK()
startStatsUpdater()

print("==========================================")
print("🧠 BRAINROT PRO MAX v4.0 - ЗАПУЩЕН!")
print("==========================================")
print("🎮 УПРАВЛЕНИЕ:")
print("   F - Показать/скрыть интерфейс")
print("   R - Смена режима (Прокачка/Ивент)")  
print("   P - Старт/Стоп автофарма")
print("==========================================")
