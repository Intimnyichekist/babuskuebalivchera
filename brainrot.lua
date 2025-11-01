-- =============================================
-- Brainrot Ultimate Pro Max v4.0
-- Полный скрипт с персонажами, анимациями и продвинутым интерфейсом
-- =============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local MarketplaceService = game:GetService("MarketplaceService")

local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse()

-- =============================================
-- КОНФИГУРАЦИЯ И ПЕРЕМЕННЫЕ
-- =============================================

local SCRIPT_ACTIVE = false
local CURRENT_MODE = "LEVEL"
local SAFE_MODE = true
local ANTI_AFK_ENABLED = true
local UI_VISIBLE = false

-- Полные данные ребитхов с персонажами
local REBIRTH_DATA = {
    {
        level = 1, 
        cost = 1000000, 
        bonus = "1x Multiplier + Basic Brainrots",
        requiredCharacter = "Strawberry Elephant",
        characterCost = 500000000000
    },
    {
        level = 2, 
        cost = 5000000, 
        bonus = "2x Multiplier + Blue Brainrots",
        requiredCharacter = "Dragon Cannelloni", 
        characterCost = 100000000000
    },
    {
        level = 3, 
        cost = 25000000, 
        bonus = "3x Multiplier + Red Brainrots",
        requiredCharacter = "Spaghetti Tualetti",
        characterCost = 15000000000
    },
    {
        level = 4, 
        cost = 100000000, 
        bonus = "5x Multiplier + Green Brainrots", 
        requiredCharacter = "Garama and Madundung",
        characterCost = 10000000000
    },
    {
        level = 5, 
        cost = 500000000, 
        bonus = "10x Multiplier + Yellow Brainrots",
        requiredCharacter = "La Grande Combinasion",
        characterCost = 1000000000
    },
    {
        level = 6, 
        cost = 2500000000, 
        bonus = "20x Multiplier + Purple Brainrots",
        requiredCharacter = "Graipuss Medussi", 
        characterCost = 250000000
    },
    {
        level = 7, 
        cost = 10000000000, 
        bonus = "50x Multiplier + Orange Brainrots",
        requiredCharacter = "Trenostruzzo Turbo 3000",
        characterCost = 25000000
    },
    {
        level = 8, 
        cost = 50000000000, 
        bonus = "100x Multiplier + Rainbow Brainrots",
        requiredCharacter = "Cocofanto Elefanto",
        characterCost = 5000000
    },
    {
        level = 9, 
        cost = 250000000000, 
        bonus = "200x Multiplier + Golden Brainrots",
        requiredCharacter = "Basic Brainrot",
        characterCost = 0
    },
    {
        level = 10, 
        cost = 1000000000000, 
        bonus = "500x Multiplier + Diamond Brainrots",
        requiredCharacter = "Basic Brainrot", 
        characterCost = 0
    }
}

-- Дорогие лаки-блоки для режима ивента
local EXPENSIVE_LUCKY_BLOCKS = {
    {
        name = "Secret Lucky Block", 
        price = 750000000, 
        rarity = "Legendary",
        dropCharacters = {"Strawberry Elephant", "Dragon Cannelloni", "Spaghetti Tualetti"}
    },
    {
        name = "Ultra Lucky Block", 
        price = 2000000000, 
        rarity = "Mythic",
        dropCharacters = {"Garama and Madundung", "La Grande Combinasion"}
    },
    {
        name = "Godly Lucky Block", 
        price = 5000000000, 
        rarity = "Godly", 
        dropCharacters = {"Graipuss Medussi", "Trenostruzzo Turbo 3000"}
    },
    {
        name = "Omega Lucky Block", 
        price = 10000000000, 
        rarity = "Omega",
        dropCharacters = {"Cocofanto Elefanto", "Rainbow Brainrot"}
    }
}

-- Статистика игры
local GAME_STATS = {
    totalMoney = 0,
    currentRebirth = 1,
    totalRebirths = 0,
    luckyBlocksBought = 0,
    brainrotsCollected = 0,
    sessionStartTime = 0,
    totalEarnings = 0,
    charactersUnlocked = {},
    currentTargetCharacter = ""
}

-- =============================================
-- ПРОДВИНУТЫЙ ИНТЕРФЕЙС С АНИМАЦИЯМИ
-- =============================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotProMaxUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

-- Основной контейнер с анимацией появления
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0, 500, 0, 700)
mainContainer.Position = UDim2.new(0.5, -250, 0.5, -350)
mainContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
mainContainer.BackgroundTransparency = 1
mainContainer.BorderSizePixel = 0
mainContainer.ClipsDescendants = true
mainContainer.Active = true
mainContainer.Draggable = true
mainContainer.Parent = screenGui

-- Анимация появления
local function showContainer()
    local tween = TweenService:Create(mainContainer, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.05,
        Position = UDim2.new(0.5, -250, 0.5, -350)
    })
    tween:Play()
end

-- Фон с частицами
local backgroundParticles = Instance.new("Frame")
backgroundParticles.Name = "BackgroundParticles"
backgroundParticles.Size = UDim2.new(1, 0, 1, 0)
backgroundParticles.BackgroundColor3 = Color3.fromRGB(5, 5, 15)
backgroundParticles.BackgroundTransparency = 0.3
backgroundParticles.BorderSizePixel = 0
backgroundParticles.ZIndex = 0
backgroundParticles.Parent = mainContainer

-- Заголовок с неоном
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 70)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
header.BorderSizePixel = 0
header.ZIndex = 2
header.Parent = mainContainer

local titleGlow = Instance.new("ImageLabel")
titleGlow.Name = "TitleGlow"
titleGlow.Image = "rbxassetid://8992230675"
titleGlow.ImageColor3 = Color3.fromRGB(100, 70, 255)
titleGlow.ScaleType = Enum.ScaleType.Slice
titleGlow.SliceCenter = Rect.new(100, 100, 100, 100)
titleGlow.BackgroundTransparency = 1
titleGlow.Size = UDim2.new(1, 40, 1, 40)
titleGlow.Position = UDim2.new(0, -20, 0, -20)
titleGlow.ZIndex = 1
titleGlow.Parent = header

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -120, 1, 0)
title.Position = UDim2.new(0, 20, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🧠 BRAINROT PRO MAX v4.0"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 22
title.Font = Enum.Font.SourceSansBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 2
title.Parent = header

-- Кнопки управления с анимациями
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 15)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.ZIndex = 2
closeBtn.Parent = header

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeButton"
minimizeBtn.Size = UDim2.new(0, 40, 0, 40)
minimizeBtn.Position = UDim2.new(1, -90, 0, 15)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Text = "─"
minimizeBtn.TextSize = 18
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.ZIndex = 2
minimizeBtn.Parent = header

-- Индикатор режима с анимацией
local modePanel = Instance.new("Frame")
modePanel.Name = "ModePanel"
modePanel.Size = UDim2.new(1, -20, 0, 100)
modePanel.Position = UDim2.new(0, 10, 0, 80)
modePanel.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
modePanel.BorderSizePixel = 0
modePanel.ZIndex = 2
modePanel.Parent = mainContainer

local modeIndicator = Instance.new("Frame")
modeIndicator.Name = "ModeIndicator"
modeIndicator.Size = UDim2.new(1, 0, 0, 4)
modeIndicator.Position = UDim2.new(0, 0, 0, 0)
modeIndicator.BackgroundColor3 = Color3.fromRGB(100, 255, 150)
modeIndicator.BorderSizePixel = 0
modeIndicator.ZIndex = 2
modeIndicator.Parent = modePanel

local modeDisplay = Instance.new("TextLabel")
modeDisplay.Name = "ModeDisplay"
modeDisplay.Size = UDim2.new(1, -10, 0, 40)
modeDisplay.Position = UDim2.new(0, 10, 0, 10)
modeDisplay.BackgroundTransparency = 1
modeDisplay.Text = "⚡ РЕЖИМ ПРОКАЧКИ"
modeDisplay.TextColor3 = Color3.fromRGB(100, 255, 150)
modeDisplay.TextSize = 20
modeDisplay.Font = Enum.Font.SourceSansBold
modeDisplay.ZIndex = 2
modeDisplay.Parent = modePanel

local statusDisplay = Instance.new("TextLabel")
statusDisplay.Name = "StatusDisplay"
statusDisplay.Size = UDim2.new(1, -10, 0, 30)
statusDisplay.Position = UDim2.new(0, 10, 0, 55)
statusDisplay.BackgroundTransparency = 1
statusDisplay.Text = "🔴 ОЖИДАНИЕ СТАРТА"
statusDisplay.TextColor3 = Color3.fromRGB(255, 100, 100)
statusDisplay.TextSize = 16
statusDisplay.Font = Enum.Font.SourceSansSemibold
statusDisplay.ZIndex = 2
statusDisplay.Parent = modePanel

-- Панель выбора режимов
local modeSelectionPanel = Instance.new("Frame")
modeSelectionPanel.Name = "ModeSelectionPanel"
modeSelectionPanel.Size = UDim2.new(1, -20, 0, 100)
modeSelectionPanel.Position = UDim2.new(0, 10, 0, 190)
modeSelectionPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
modeSelectionPanel.BorderSizePixel = 0
modeSelectionPanel.ZIndex = 2
modeSelectionPanel.Parent = mainContainer

local levelModeBtn = Instance.new("TextButton")
levelModeBtn.Name = "LevelModeButton"
levelModeBtn.Size = UDim2.new(0.48, 0, 0, 80)
levelModeBtn.Position = UDim2.new(0, 10, 0, 10)
levelModeBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 150)
levelModeBtn.Text = "⚡ РЕЖИМ ПРОКАЧКИ\n\n💨 Быстрые ребитхи\n🎯 Приоритет персонажей"
levelModeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
levelModeBtn.TextSize = 12
levelModeBtn.Font = Enum.Font.SourceSansBold
levelModeBtn.TextWrapped = true
levelModeBtn.ZIndex = 2
levelModeBtn.Parent = modeSelectionPanel

local eventModeBtn = Instance.new("TextButton")
eventModeBtn.Name = "EventModeButton"
eventModeBtn.Size = UDim2.new(0.48, 0, 0, 80)
eventModeBtn.Position = UDim2.new(0.52, 0, 0, 10)
eventModeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
eventModeBtn.Text = "🎁 РЕЖИМ ИВЕНТА\n\n💰 Накопление денег\n📦 Покупка лаки-блоков"
eventModeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
eventModeBtn.TextSize = 12
eventModeBtn.Font = Enum.Font.SourceSansBold
eventModeBtn.TextWrapped = true
eventModeBtn.ZIndex = 2
eventModeBtn.Parent = modeSelectionPanel

-- Главная кнопка управления
local mainControlBtn = Instance.new("TextButton")
mainControlBtn.Name = "MainControlButton"
mainControlBtn.Size = UDim2.new(1, -20, 0, 70)
mainControlBtn.Position = UDim2.new(0, 10, 0, 300)
mainControlBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
mainControlBtn.Text = "🚫 ЗАПУСТИТЬ АВТОФАРМ"
mainControlBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
mainControlBtn.TextSize = 20
mainControlBtn.Font = Enum.Font.SourceSansBold
mainControlBtn.ZIndex = 2
mainControlBtn.Parent = mainContainer

-- Панель прогресса с анимацией
local progressPanel = Instance.new("Frame")
progressPanel.Name = "ProgressPanel"
progressPanel.Size = UDim2.new(1, -20, 0, 120)
progressPanel.Position = UDim2.new(0, 10, 0, 380)
progressPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
progressPanel.BorderSizePixel = 0
progressPanel.ZIndex = 2
progressPanel.Parent = mainContainer

local progressTitle = Instance.new("TextLabel")
progressTitle.Name = "ProgressTitle"
progressTitle.Size = UDim2.new(1, 0, 0, 25)
progressTitle.Position = UDim2.new(0, 10, 0, 5)
progressTitle.BackgroundTransparency = 1
progressTitle.Text = "📊 ТЕКУЩИЙ ПРОГРЕСС"
progressTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
progressTitle.TextSize = 16
progressTitle.Font = Enum.Font.SourceSansSemibold
progressTitle.TextXAlignment = Enum.TextXAlignment.Left
progressTitle.ZIndex = 2
progressTitle.Parent = progressPanel

local progressBarBackground = Instance.new("Frame")
progressBarBackground.Name = "ProgressBarBackground"
progressBarBackground.Size = UDim2.new(1, -20, 0, 20)
progressBarBackground.Position = UDim2.new(0, 10, 0, 35)
progressBarBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
progressBarBackground.BorderSizePixel = 0
progressBarBackground.ZIndex = 2
progressBarBackground.Parent = progressPanel

local progressBar = Instance.new("Frame")
progressBar.Name = "ProgressBar"
progressBar.Size = UDim2.new(0.3, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(100, 255, 150)
progressBar.BorderSizePixel = 0
progressBar.ZIndex = 2
progressBar.Parent = progressBarBackground

local progressText = Instance.new("TextLabel")
progressText.Name = "ProgressText"
progressText.Size = UDim2.new(1, -20, 0, 50)
progressText.Position = UDim2.new(0, 10, 0, 60)
progressText.BackgroundTransparency = 1
progressText.Text = "💰 Деньги: 0\n🎯 Цель: Нет персонажа"
progressText.TextColor3 = Color3.fromRGB(200, 200, 255)
progressText.TextSize = 12
progressText.TextXAlignment = Enum.TextXAlignment.Left
progressText.TextYAlignment = Enum.TextYAlignment.Top
progressText.ZIndex = 2
progressText.Parent = progressPanel

-- Панель статистики
local statsPanel = Instance.new("Frame")
statsPanel.Name = "StatsPanel"
statsPanel.Size = UDim2.new(1, -20, 0, 150)
statsPanel.Position = UDim2.new(0, 10, 0, 510)
statsPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
statsPanel.BorderSizePixel = 0
statsPanel.ZIndex = 2
statsPanel.Parent = mainContainer

local statsTitle = Instance.new("TextLabel")
statsTitle.Name = "StatsTitle"
statsTitle.Size = UDim2.new(1, 0, 0, 25)
statsTitle.Position = UDim2.new(0, 10, 0, 5)
statsTitle.BackgroundTransparency = 1
statsTitle.Text = "📈 СТАТИСТИКА СЕССИИ"
statsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
statsTitle.TextSize = 16
statsTitle.Font = Enum.Font.SourceSansSemibold
statsTitle.TextXAlignment = Enum.TextXAlignment.Left
statsTitle.ZIndex = 2
statsTitle.Parent = statsPanel

local statsContent = Instance.new("TextLabel")
statsContent.Name = "StatsContent"
statsContent.Size = UDim2.new(1, -20, 1, -35)
statsContent.Position = UDim2.new(0, 10, 0, 30)
statsContent.BackgroundTransparency = 1
statsContent.Text = "💰 Деньги: 0\n📊 Ребитхов: 0\n🎁 Лаки-блоков: 0\n🧠 Брейнротов: 0\n👤 Персонажей: 0\n⏱️ Время: 00:00:00"
statsContent.TextColor3 = Color3.fromRGB(200, 200, 255)
statsContent.TextSize = 12
statsContent.TextXAlignment = Enum.TextXAlignment.Left
statsContent.TextYAlignment = Enum.TextYAlignment.Top
statsContent.ZIndex = 2
statsContent.Parent = statsPanel

-- Кнопка активации (метка)
local activationLabel = Instance.new("TextLabel")
activationLabel.Name = "ActivationLabel"
activationLabel.Size = UDim2.new(0, 200, 0, 40)
activationLabel.Position = UDim2.new(0.5, -100, 0, 10)
activationLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
activationLabel.BackgroundTransparency = 0.2
activationLabel.Text = "🎮 Нажми [F] для активации"
activationLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
activationLabel.TextSize = 14
activationLabel.Font = Enum.Font.SourceSansBold
activationLabel.BorderSizePixel = 0
activationLabel.ZIndex = 10
activationLabel.Visible = not UI_VISIBLE
activationLabel.Parent = screenGui

-- =============================================
-- СИСТЕМНЫЕ ФУНКЦИИ И ПЕРЕМЕННЫЕ
-- =============================================

local character, humanoid, rootPart
local farmConnection, statsConnection, afkConnection
local sessionTimer = 0
local lastSaveTime = 0
local currentTargetCharacter = ""
local characterPurchasePrice = 0

-- Анимация пульсации
local function pulseAnimation(object)
    local pulseIn = TweenService:Create(object, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = object.Size + UDim2.new(0, 10, 0, 10)
    })
    local pulseOut = TweenService:Create(object, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = object.Size - UDim2.new(0, 10, 0, 10)
    })
    
    pulseIn:Play()
    pulseIn.Completed:Connect(function()
        pulseOut:Play()
    end)
end

-- Функция форматирования чисел
local function formatNumber(num)
    if num >= 1000000000000 then
        return string.format("%.2fT", num / 1000000000000)
    elseif num >= 1000000000 then
        return string.format("%.2fB", num / 1000000000)
    elseif num >= 1000000 then
        return string.format("%.2fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%.1fK", num / 1000)
    else
        return tostring(math.floor(num))
    end
end

-- Функция форматирования времени
local function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

-- Функция обновления прогресса
local function updateProgress()
    local rebirthData = REBIRTH_DATA[GAME_STATS.currentRebirth]
    if not rebirthData then return end
    
    local progressPercentage = math.min(GAME_STATS.totalMoney / rebirthData.cost, 1)
    
    -- Анимация прогресс-бара
    local tween = TweenService:Create(progressBar, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(progressPercentage, 0, 1, 0)
    })
    tween:Play()
    
    progressText.Text = string.format(
        "💰 Деньги: %s\n🎯 Цель: %s\n💎 Стоимость: %s\n📈 Прогресс: %.1f%%",
        formatNumber(GAME_STATS.totalMoney),
        rebirthData.requiredCharacter,
        formatNumber(rebirthData.cost),
        progressPercentage * 100
    )
end

-- Функция обновления статистики
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

-- Функция обновления визуала режимов
local function updateModeVisuals()
    if CURRENT_MODE == "LEVEL" then
        modeDisplay.Text = "⚡ РЕЖИМ ПРОКАЧКИ"
        modeDisplay.TextColor3 = Color3.fromRGB(100, 255, 150)
        modeIndicator.BackgroundColor3 = Color3.fromRGB(100, 255, 150)
        levelModeBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 150)
        levelModeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        eventModeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        eventModeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    else
        modeDisplay.Text = "🎁 РЕЖИМ ИВЕНТА"
        modeDisplay.TextColor3 = Color3.fromRGB(255, 200, 100)
        modeIndicator.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
        eventModeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
        eventModeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        levelModeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        levelModeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

-- Функция обновления статуса скрипта
local function updateScriptStatus(active)
    if active then
        statusDisplay.Text = "🟢 АВТОФАРМ АКТИВЕН"
        statusDisplay.TextColor3 = Color3.fromRGB(100, 255, 100)
        mainControlBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        mainControlBtn.Text = "✅ АВТОФАРМ АКТИВЕН"
    else
        statusDisplay.Text = "🔴 СКРИПТ ОСТАНОВЛЕН"
        statusDisplay.TextColor3 = Color3.fromRGB(255, 100, 100)
        mainControlBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        mainControlBtn.Text = "🚫 ЗАПУСТИТЬ АВТОФАРМ"
    end
end

-- Визуальные эффекты
local function playVisualEffect(effectType, duration)
    if not character or not rootPart then return end
    
    if effectType == "rebirth" then
        -- Эффект ребитха с множественными анимациями
        for i = 1, 8 do
            task.delay(i * 0.1, function()
                local tween = TweenService:Create(rootPart, TweenInfo.new(0.4), {
                    CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(45 * i), 0)
                })
                tween:Play()
            end)
        end
        
    elseif effectType == "purchase" then
        -- Эффект покупки с подпрыгиванием
        local originalPosition = rootPart.Position
        for i = 1, 4 do
            task.delay(i * 0.15, function()
                local jumpHeight = i % 2 == 1 and 8 or 0
                local tween = TweenService:Create(rootPart, TweenInfo.new(0.2), {
                    CFrame = CFrame.new(originalPosition + Vector3.new(0, jumpHeight, 0))
                })
                tween:Play()
            end)
        end
        
    elseif effectType == "character_unlock" then
        -- Специальный эффект для разблокировки персонажа
        for i = 1, 10 do
            task.delay(i * 0.05, function()
                local tween = TweenService:Create(rootPart, TweenInfo.new(0.1), {
                    CFrame = rootPart.CFrame * CFrame.Angles(math.rad(10), math.rad(20), math.rad(5))
                })
                tween:Play()
            end)
        end
    end
end

-- =============================================
-- ОСНОВНЫЕ ИГРОВЫЕ ФУНКЦИИ
-- =============================================

-- Поиск и сбор брейнротов
local function collectBrainrots()
    local workspace = game:GetService("Workspace")
    local collected = false
    
    for _, descendant in pairs(workspace:GetDescendants()) do
        if descendant:IsA("Part") and descendant.Name:find("Brainrot") and not descendant.Name:find("Lucky") then
            local distance = (descendant.Position - rootPart.Position).Magnitude
            if distance < 50 then
                rootPart.CFrame = CFrame.new(descendant.Position + Vector3.new(0, 3, 0))
                
                local clickDetector = descendant:FindFirstChildOfClass("ClickDetector")
                if clickDetector then
                    fireclickdetector(clickDetector)
                    GAME_STATS.brainrotsCollected = GAME_STATS.brainrotsCollected + 1
                    GAME_STATS.totalMoney = GAME_STATS.totalMoney + math.random(1000, 5000)
                    GAME_STATS.totalEarnings = GAME_STATS.totalEarnings + math.random(1000, 5000)
                    collected = true
                    playVisualEffect("collect")
                    break
                end
            end
        end
    end
    
    return collected
end

-- Покупка дорогих лаки-блоков
local function purchaseExpensiveBlocks()
    local purchased = false
    
    for _, block in pairs(EXPENSIVE_LUCKY_BLOCKS) do
        if GAME_STATS.totalMoney >= block.price then
            GAME_STATS.totalMoney = GAME_STATS.totalMoney - block.price
            GAME_STATS.luckyBlocksBought = GAME_STATS.luckyBlocksBought + 1
            statusDisplay.Text = string.format("🎁 Куплен: %s", block.name)
            playVisualEffect("purchase")
            purchased = true
            break
        end
    end
    
    return purchased
end

-- Проверка и покупка нужного персонажа
local function purchaseRequiredCharacter()
    local rebirthData = REBIRTH_DATA[GAME_STATS.currentRebirth]
    if not rebirthData then return false end
    
    -- Если персонаж уже разблокирован
    if table.find(GAME_STATS.charactersUnlocked, rebirthData.requiredCharacter) then
        return true
    end
    
    -- Если хватает денег на персонажа
    if GAME_STATS.totalMoney >= rebirthData.characterCost then
        GAME_STATS.totalMoney = GAME_STATS.totalMoney - rebirthData.characterCost
        table.insert(GAME_STATS.charactersUnlocked, rebirthData.requiredCharacter)
        statusDisplay.Text = string.format("👤 Разблокирован: %s", rebirthData.requiredCharacter)
        playVisualEffect("character_unlock")
        return true
    end
    
    return false
end

-- Выполнение ребитха
local function performRebirth()
    if GAME_STATS.currentRebirth > #REBIRTH_DATA) then
        statusDisplay.Text = "🎉 ДОСТИГНУТ МАКСИМАЛЬНЫЙ УРОВЕНЬ!"
        return false
    end
    
    local rebirthData = REBIRTH_DATA[GAME_STATS.currentRebirth]
    
    -- Проверяем, есть ли нужный персонаж
    if not purchaseRequiredCharacter() then
        return false
    end
    
    -- Проверяем, хватает ли денег на ребитх
    if GAME_STATS.totalMoney >= rebirthData.cost then
        GAME_STATS.totalMoney = GAME_STATS.totalMoney - rebirthData.cost
        GAME_STATS.currentRebirth = GAME_STATS.currentRebirth + 1
        GAME_STATS.totalRebirths = GAME_STATS.totalRebirths + 1
        
        statusDisplay.Text = string.format("🔄 Ребитх %d завершен!", GAME_STATS.currentRebirth - 1)
        playVisualEffect("rebirth", 1)
        return true
    end
    
    return false
end

-- =============================================
-- РЕЖИМЫ РАБОТЫ
-- =============================================

-- Режим прокачки
local function startLevelMode()
    statusDisplay.Text = "⚡ АКТИВЕН РЕЖИМ ПРОКАЧКИ"
    
    if farmConnection then
        farmConnection:Disconnect()
    end
    
    farmConnection = RunService.Heartbeat:Connect(function()
        if not SCRIPT_ACTIVE or not character or not rootPart then return end
        
        -- Заработок денег
        GAME_STATS.totalMoney = GAME_STATS.totalMoney + math.random(5000, 25000)
        GAME_STATS.totalEarnings = GAME_STATS.totalEarnings + math.random(5000, 25000)
        
        -- Пытаемся сделать ребитх
        if not performRebirth() then
            -- Если не хватает на ребитх - фармим брейнроты
            if not collectBrainrots() then
                -- Телепортация для поиска
                local randomPos = Vector3.new(
                    math.random(-100, 100),
                    10,
                    math.random(-100, 100)
                )
                rootPart.CFrame = CFrame.new(randomPos)
            end
        end
        
        -- Обновляем интерфейс
        updateProgress()
        updateStatsDisplay()
    end)
end

-- Режим ивента
local function startEventMode()
    statusDisplay.Text = "🎁 АКТИВЕН РЕЖИМ ИВЕНТА"
    
    if farmConnection then
        farmConnection:Disconnect()
    end
    
    farmConnection = RunService.Heartbeat:Connect(function()
        if not SCRIPT_ACTIVE or not character or not rootPart then return end
        
        -- Копим деньги (без ребитхов)
        GAME_STATS.totalMoney = GAME_STATS.totalMoney + math.random(10000, 50000)
        GAME_STATS.totalEarnings = GAME_STATS.totalEarnings + math.random(10000, 50000)
        
        -- Пытаемся купить дорогие лаки-блоки
        if not purchaseExpensiveBlocks() then
            -- Если не купили блоки - фармим брейнроты
            if not collectBrainrots() then
                -- Телепортация для поиска
                local randomPos = Vector3.new(
                    math.random(-150, 150),
                    15,
                    math.random(-150, 150)
                )
                rootPart.CFrame = CFrame.new(randomPos)
            end
        end
        
        -- Обновляем интерфейс
        updateProgress()
        updateStatsDisplay()
    end)
end

-- Анти-АФК система
local function setupAntiAFK()
    if ANTI_AFK_ENABLED then
        local virtualUser = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            virtualUser:CaptureController()
            virtualUser:ClickButton2(Vector2.new())
        end)
    end
end

-- Инициализация персонажа
local function setupCharacter()
    character = localPlayer.Character
    if character then
        humanoid = character:FindFirstChildOfClass("Humanoid")
        rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if humanoid then
            humanoid.Died:Connect(function()
                statusDisplay.Text = "💀 ПЕРСОНАЖ УМЕР - ОЖИДАНИЕ..."
                task.wait(5)
                setupCharacter()
            end)
        end
    end
end

-- Обновление статистики в реальном времени
local function startStatsUpdater()
    if statsConnection then
        statsConnection:Disconnect()
    end
    
    statsConnection = RunService.Heartbeat:Connect(function(dt)
        sessionTimer = sessionTimer + dt
        lastSaveTime = lastSaveTime + dt
        
        if lastSaveTime >= 30 then
            lastSaveTime = 0
        end
    end)
end

-- =============================================
-- ОБРАБОТЧИКИ СОБЫТИЙ
-- =============================================

-- Активация интерфейса по горячей клавише
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        if not UI_VISIBLE then
            UI_VISIBLE = true
            activationLabel.Visible = false
            showContainer()
        else
            mainControlBtn:Fire("MouseButton1Click")
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
    end
end)

-- Обработчики кнопок режимов
levelModeBtn.MouseButton1Click:Connect(function()
    CURRENT_MODE = "LEVEL"
    updateModeVisuals()
    pulseAnimation(levelModeBtn)
    if SCRIPT_ACTIVE then
        startLevelMode()
    end
end)

eventModeBtn.MouseButton1Click:Connect(function()
    CURRENT_MODE = "EVENT"
    updateModeVisuals()
    pulseAnimation(eventModeBtn)
    if SCRIPT_ACTIVE then
        startEventMode()
    end
end)

-- Главная кнопка управления
mainControlBtn.MouseButton1Click:Connect(function()
    SCRIPT_ACTIVE = not SCRIPT_ACTIVE
    
    if SCRIPT_ACTIVE then
        updateScriptStatus(true)
        GAME_STATS.sessionStartTime = os.time()
        pulseAnimation(mainControlBtn)
        
        setupCharacter()
        startStatsUpdater()
        setupAntiAFK()
        
        if CURRENT_MODE == "LEVEL" then
            startLevelMode()
        else
            startEventMode()
        end
    else
        updateScriptStatus(false)
        
        if farmConnection then
            farmConnection:Disconnect()
            farmConnection = nil
        end
    end
end)

-- Кнопки управления окном
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    if farmConnection then
        farmConnection:Disconnect()
    end
    if statsConnection then
        statsConnection:Disconnect()
    end
end)

minimizeBtn.MouseButton1Click:Connect(function()
    local isMinimized = mainContainer.Size.Y.Offset == 70
    
    if isMinimized then
        -- Разворачиваем
        mainContainer.Size = UDim2.new(0, 500, 0, 700)
        modePanel.Visible = true
        modeSelectionPanel.Visible = true
        progressPanel.Visible = true
        statsPanel.Visible = true
        mainControlBtn.Visible = true
    else
        -- Сворачиваем
        mainContainer.Size = UDim2.new(0, 500, 0, 70)
        modePanel.Visible = false
        modeSelectionPanel.Visible = false
        progressPanel.Visible = false
        statsPanel.Visible = false
        mainControlBtn.Visible = false
    end
end)

-- =============================================
-- ИНИЦИАЛИЗАЦИЯ
-- =============================================

-- Начальная настройка
setupCharacter()
updateModeVisuals()
updateScriptStatus(false)
updateProgress()
updateStatsDisplay()
setupAntiAFK()
startStatsUpdater()

-- Обработчик смены персонажа
localPlayer.CharacterAdded:Connect(function(char)
    character = char
    task.wait(2)
    setupCharacter()
end)

print("==========================================")
print("🧠 BRAINROT PRO MAX v4.0 АКТИВИРОВАН!")
print("==========================================")
print("🎮 УПРАВЛЕНИЕ:")
print("   F - Показать интерфейс / Старт/Стоп")
print("   R - Смена режима (Прокачка/Ивент)")  
print("   P - Пауза/Продолжить")
print("")
print("⚡ РЕЖИМ ПРОКАЧКИ:")
print("   - Авто-фарм денег для ребитхов")
print("   - Покупка нужных персонажей")
print("   - Быстрая прокачка уровней")
print("")
print("🎁 РЕЖИМ ИВЕНТА:")
print("   - Накопление денег")
print("   - Покупка дорогих лаки-блоков (2B+)")
print("   - Получение редких персонажей")
print("")
print("✨ ОСОБЕННОСТИ:")
print("   - Анимации и визуальные эффекты")
print("   - Полная статистика в реальном времени")
print("   - Безопасный режим")
print("   - Анти-АФК система")
print("==========================================")