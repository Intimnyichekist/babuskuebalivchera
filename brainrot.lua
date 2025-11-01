-- =============================================
-- Brainrot Ultimate Pro Max v4.1 - FIXED
-- Исправленная версия с обработкой ошибок
-- =============================================

local success, error = pcall(function()
    -- Проверяем доступность сервисов
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local HttpService = game:GetService("HttpService")
    
    -- Проверяем, что скрипт выполняется на клиенте
    if not RunService:IsClient() then
        error("Скрипт должен быть LocalScript!")
        return
    end

    local localPlayer = Players.LocalPlayer
    if not localPlayer then
        error("LocalPlayer не найден!")
        return
    end

    -- =============================================
    -- КОНФИГУРАЦИЯ И ПЕРЕМЕННЫЕ
    -- =============================================

    local SCRIPT_ACTIVE = false
    local CURRENT_MODE = "LEVEL"
    local SAFE_MODE = true
    local ANTI_AFK_ENABLED = true
    local UI_VISIBLE = false

    -- Данные ребитхов с персонажами
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
    -- БЕЗОПАСНОЕ СОЗДАНИЕ ИНТЕРФЕЙСА
    -- =============================================

    local function safeCreateInstance(className, properties)
        local success, instance = pcall(function()
            local inst = Instance.new(className)
            for property, value in pairs(properties) do
                pcall(function()
                    inst[property] = value
                end)
            end
            return inst
        end)
        return success and instance or nil
    end

    -- Создаем основной GUI
    local screenGui = safeCreateInstance("ScreenGui", {
        Name = "BrainrotProMaxUI",
        ResetOnSpawn = false
    })
    
    if not screenGui then
        error("Не удалось создать ScreenGui!")
        return
    end

    -- Ждем PlayerGui
    local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
    if not playerGui then
        localPlayer:WaitForChild("PlayerGui", 10)
        playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
    end

    if not playerGui then
        error("PlayerGui не найден!")
        return
    end

    screenGui.Parent = playerGui

    -- Основной контейнер
    local mainContainer = safeCreateInstance("Frame", {
        Name = "MainContainer",
        Size = UDim2.new(0, 450, 0, 600),
        Position = UDim2.new(0.5, -225, 0.5, -300),
        BackgroundColor3 = Color3.fromRGB(10, 10, 20),
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Active = true,
        Draggable = true
    })
    
    if not mainContainer then
        error("Не удалось создать основной контейнер!")
        return
    end

    mainContainer.Parent = screenGui

    -- Упрощенный заголовок
    local header = safeCreateInstance("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(20, 20, 35),
        BorderSizePixel = 0
    })
    header.Parent = mainContainer

    local title = safeCreateInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = "🧠 BRAINROT PRO MAX v4.1",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        Font = Enum.Font.SourceSansBold,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    title.Parent = header

    -- Кнопки управления
    local closeBtn = safeCreateInstance("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0.5, -15),
        BackgroundColor3 = Color3.fromRGB(255, 60, 60),
        Text = "✕",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Font = Enum.Font.SourceSansBold
    })
    closeBtn.Parent = header

    -- Панель статуса
    local statusPanel = safeCreateInstance("Frame", {
        Name = "StatusPanel",
        Size = UDim2.new(1, -20, 0, 80),
        Position = UDim2.new(0, 10, 0, 60),
        BackgroundColor3 = Color3.fromRGB(15, 15, 25),
        BorderSizePixel = 0
    })
    statusPanel.Parent = mainContainer

    local modeDisplay = safeCreateInstance("TextLabel", {
        Name = "ModeDisplay",
        Size = UDim2.new(1, -10, 0, 30),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        Text = "⚡ РЕЖИМ ПРОКАЧКИ",
        TextColor3 = Color3.fromRGB(100, 255, 150),
        TextSize = 16,
        Font = Enum.Font.SourceSansBold
    })
    modeDisplay.Parent = statusPanel

    local statusDisplay = safeCreateInstance("TextLabel", {
        Name = "StatusDisplay",
        Size = UDim2.new(1, -10, 0, 25),
        Position = UDim2.new(0, 10, 0, 45),
        BackgroundTransparency = 1,
        Text = "🔴 ОЖИДАНИЕ СТАРТА",
        TextColor3 = Color3.fromRGB(255, 100, 100),
        TextSize = 14,
        Font = Enum.Font.SourceSansSemibold
    })
    statusDisplay.Parent = statusPanel

    -- Кнопки выбора режима
    local modeSelectionPanel = safeCreateInstance("Frame", {
        Name = "ModeSelectionPanel",
        Size = UDim2.new(1, -20, 0, 80),
        Position = UDim2.new(0, 10, 0, 150),
        BackgroundColor3 = Color3.fromRGB(15, 15, 25),
        BorderSizePixel = 0
    })
    modeSelectionPanel.Parent = mainContainer

    local levelModeBtn = safeCreateInstance("TextButton", {
        Name = "LevelModeButton",
        Size = UDim2.new(0.48, 0, 0, 60),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Color3.fromRGB(100, 255, 150),
        Text = "⚡ ПРОКАЧКА\nБыстрые ребитхи",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = 12,
        Font = Enum.Font.SourceSansBold,
        TextWrapped = true
    })
    levelModeBtn.Parent = modeSelectionPanel

    local eventModeBtn = safeCreateInstance("TextButton", {
        Name = "EventModeButton",
        Size = UDim2.new(0.48, 0, 0, 60),
        Position = UDim2.new(0.52, 0, 0, 10),
        BackgroundColor3 = Color3.fromRGB(60, 60, 80),
        Text = "🎁 ИВЕНТ\nЛаки-блоки от 2B",
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = 12,
        Font = Enum.Font.SourceSansBold,
        TextWrapped = true
    })
    eventModeBtn.Parent = modeSelectionPanel

    -- Главная кнопка управления
    local mainControlBtn = safeCreateInstance("TextButton", {
        Name = "MainControlButton",
        Size = UDim2.new(1, -20, 0, 50),
        Position = UDim2.new(0, 10, 0, 240),
        BackgroundColor3 = Color3.fromRGB(255, 60, 60),
        Text = "🚫 ЗАПУСТИТЬ АВТОФАРМ",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Font = Enum.Font.SourceSansBold
    })
    mainControlBtn.Parent = mainContainer

    -- Панель прогресса
    local progressPanel = safeCreateInstance("Frame", {
        Name = "ProgressPanel",
        Size = UDim2.new(1, -20, 0, 100),
        Position = UDim2.new(0, 10, 0, 300),
        BackgroundColor3 = Color3.fromRGB(15, 15, 25),
        BorderSizePixel = 0
    })
    progressPanel.Parent = mainContainer

    local progressText = safeCreateInstance("TextLabel", {
        Name = "ProgressText",
        Size = UDim2.new(1, -20, 1, -10),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = "💰 Деньги: 0\n🎯 Цель: Нет персонажа\n📊 Ребитх: 1",
        TextColor3 = Color3.fromRGB(200, 200, 255),
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    })
    progressText.Parent = progressPanel

    -- Панель статистики
    local statsPanel = safeCreateInstance("Frame", {
        Name = "StatsPanel",
        Size = UDim2.new(1, -20, 0, 120),
        Position = UDim2.new(0, 10, 0, 410),
        BackgroundColor3 = Color3.fromRGB(15, 15, 25),
        BorderSizePixel = 0
    })
    statsPanel.Parent = mainContainer

    local statsContent = safeCreateInstance("TextLabel", {
        Name = "StatsContent",
        Size = UDim2.new(1, -20, 1, -10),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = "💰 Деньги: 0\n📊 Ребитхов: 0\n🎁 Лаки-блоков: 0\n🧠 Брейнротов: 0\n⏱️ Время: 00:00:00",
        TextColor3 = Color3.fromRGB(200, 200, 255),
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    })
    statsContent.Parent = statsPanel

    -- Кнопка активации
    local activationLabel = safeCreateInstance("TextLabel", {
        Name = "ActivationLabel",
        Size = UDim2.new(0, 200, 0, 40),
        Position = UDim2.new(0.5, -100, 0, 10),
        BackgroundColor3 = Color3.fromRGB(30, 30, 45),
        BackgroundTransparency = 0.2,
        Text = "🎮 Нажми [F] для активации",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.SourceSansBold,
        BorderSizePixel = 0,
        Visible = true
    })
    activationLabel.Parent = screenGui

    -- =============================================
    -- СИСТЕМНЫЕ ФУНКЦИИ
    -- =============================================

    local character, humanoid, rootPart
    local farmConnection, statsConnection
    local sessionTimer = 0

    -- Безопасная функция форматирования чисел
    local function formatNumber(num)
        if type(num) ~= "number" then return "0" end
        
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

    -- Безопасная функция форматирования времени
    local function formatTime(seconds)
        if type(seconds) ~= "number" then return "00:00:00" end
        
        local hours = math.floor(seconds / 3600)
        local minutes = math.floor((seconds % 3600) / 60)
        local secs = seconds % 60
        return string.format("%02d:%02d:%02d", hours, minutes, secs)
    end

    -- Безопасное обновление интерфейса
    local function safeUpdateUI()
        pcall(function()
            progressText.Text = string.format(
                "💰 Деньги: %s\n🎯 Цель: %s\n📊 Ребитх: %d",
                formatNumber(GAME_STATS.totalMoney),
                REBIRTH_DATA[GAME_STATS.currentRebirth] and REBIRTH_DATA[GAME_STATS.currentRebirth].requiredCharacter or "Нет",
                GAME_STATS.currentRebirth
            )
            
            statsContent.Text = string.format(
                "💰 Деньги: %s\n📊 Ребитхов: %d\n🎁 Лаки-блоков: %d\n🧠 Брейнротов: %d\n⏱️ Время: %s",
                formatNumber(GAME_STATS.totalMoney),
                GAME_STATS.totalRebirths,
                GAME_STATS.luckyBlocksBought,
                GAME_STATS.brainrotsCollected,
                formatTime(sessionTimer)
            )
        end)
    end

    -- Безопасное обновление режимов
    local function updateModeVisuals()
        pcall(function()
            if CURRENT_MODE == "LEVEL" then
                modeDisplay.Text = "⚡ РЕЖИМ ПРОКАЧКИ"
                modeDisplay.TextColor3 = Color3.fromRGB(100, 255, 150)
                levelModeBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 150)
                levelModeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
                eventModeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                eventModeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            else
                modeDisplay.Text = "🎁 РЕЖИМ ИВЕНТА"
                modeDisplay.TextColor3 = Color3.fromRGB(255, 200, 100)
                eventModeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
                eventModeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
                levelModeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                levelModeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end)
    end

    -- Безопасное обновление статуса
    local function updateScriptStatus(active)
        pcall(function()
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
        end)
    end

    -- Безопасная инициализация персонажа
    local function setupCharacter()
        pcall(function()
            character = localPlayer.Character
            if character then
                humanoid = character:FindFirstChildOfClass("Humanoid")
                rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
            end
        end)
    end

    -- Безопасный сбор брейнротов
    local function collectBrainrots()
        if not character or not rootPart then return false end
        
        local collected = false
        pcall(function()
            local workspace = game:GetService("Workspace")
            
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
                            collected = true
                            break
                        end
                    end
                end
            end
        end)
        
        return collected
    end

    -- Безопасная покупка блоков
    local function purchaseExpensiveBlocks()
        local purchased = false
        
        pcall(function()
            for _, block in pairs(EXPENSIVE_LUCKY_BLOCKS) do
                if GAME_STATS.totalMoney >= block.price then
                    GAME_STATS.totalMoney = GAME_STATS.totalMoney - block.price
                    GAME_STATS.luckyBlocksBought = GAME_STATS.luckyBlocksBought + 1
                    statusDisplay.Text = string.format("🎁 Куплен: %s", block.name)
                    purchased = true
                    break
                end
            end
        end)
        
        return purchased
    end

    -- Безопасный ребитх
    local function performRebirth()
        if GAME_STATS.currentRebirth > #REBIRTH_DATA then return false end
        
        local rebirthData = REBIRTH_DATA[GAME_STATS.currentRebirth]
        if not rebirthData then return false end
        
        if GAME_STATS.totalMoney >= rebirthData.cost then
            GAME_STATS.totalMoney = GAME_STATS.totalMoney - rebirthData.cost
            GAME_STATS.currentRebirth = GAME_STATS.currentRebirth + 1
            GAME_STATS.totalRebirths = GAME_STATS.totalRebirths + 1
            statusDisplay.Text = string.format("🔄 Ребитх %d завершен!", GAME_STATS.currentRebirth - 1)
            return true
        end
        
        return false
    end

    -- =============================================
    -- РЕЖИМЫ РАБОТЫ
    -- =============================================

    local function startLevelMode()
        statusDisplay.Text = "⚡ АКТИВЕН РЕЖИМ ПРОКАЧКИ"
        
        if farmConnection then
            farmConnection:Disconnect()
        end
        
        farmConnection = RunService.Heartbeat:Connect(function()
            if not SCRIPT_ACTIVE or not character or not rootPart then return end
            
            pcall(function()
                GAME_STATS.totalMoney = GAME_STATS.totalMoney + math.random(5000, 25000)
                
                if not performRebirth() then
                    if not collectBrainrots() then
                        local randomPos = Vector3.new(
                            math.random(-100, 100),
                            10,
                            math.random(-100, 100)
                        )
                        rootPart.CFrame = CFrame.new(randomPos)
                    end
                end
                
                safeUpdateUI()
            end)
        end)
    end

    local function startEventMode()
        statusDisplay.Text = "🎁 АКТИВЕН РЕЖИМ ИВЕНТА"
        
        if farmConnection then
            farmConnection:Disconnect()
        end
        
        farmConnection = RunService.Heartbeat:Connect(function()
            if not SCRIPT_ACTIVE or not character or not rootPart then return end
            
            pcall(function()
                GAME_STATS.totalMoney = GAME_STATS.totalMoney + math.random(10000, 50000)
                
                if not purchaseExpensiveBlocks() then
                    if not collectBrainrots() then
                        local randomPos = Vector3.new(
                            math.random(-150, 150),
                            15,
                            math.random(-150, 150)
                        )
                        rootPart.CFrame = CFrame.new(randomPos)
                    end
                end
                
                safeUpdateUI()
            end)
        end)
    end

    -- Безопасный сбор статистики
    local function startStatsUpdater()
        if statsConnection then
            statsConnection:Disconnect()
        end
        
        statsConnection = RunService.Heartbeat:Connect(function(dt)
            pcall(function()
                sessionTimer = sessionTimer + dt
            end)
        end)
    end

    -- =============================================
    -- ОБРАБОТЧИКИ СОБЫТИЙ
    -- =============================================

    -- Безопасная обработка ввода
    local inputConnection
    inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        pcall(function()
            if input.KeyCode == Enum.KeyCode.F then
                if not UI_VISIBLE then
                    UI_VISIBLE = true
                    activationLabel.Visible = false
                    mainContainer.Visible = true
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
            end
        end)
    end)

    -- Безопасные обработчики кнопок
    pcall(function()
        levelModeBtn.MouseButton1Click:Connect(function()
            CURRENT_MODE = "LEVEL"
            updateModeVisuals()
            if SCRIPT_ACTIVE then
                startLevelMode()
            end
        end)

        eventModeBtn.MouseButton1Click:Connect(function()
            CURRENT_MODE = "EVENT"
            updateModeVisuals()
            if SCRIPT_ACTIVE then
                startEventMode()
            end
        end)

        mainControlBtn.MouseButton1Click:Connect(function()
            SCRIPT_ACTIVE = not SCRIPT_ACTIVE
            
            if SCRIPT_ACTIVE then
                updateScriptStatus(true)
                GAME_STATS.sessionStartTime = os.time()
                
                setupCharacter()
                startStatsUpdater()
                
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

        closeBtn.MouseButton1Click:Connect(function()
            if farmConnection then
                farmConnection:Disconnect()
            end
            if statsConnection then
                statsConnection:Disconnect()
            end
            if inputConnection then
                inputConnection:Disconnect()
            end
            screenGui:Destroy()
        end)
    end)

    -- =============================================
    -- ИНИЦИАЛИЗАЦИЯ
    -- =============================================

    pcall(function()
        setupCharacter()
        updateModeVisuals()
        updateScriptStatus(false)
        safeUpdateUI()
        startStatsUpdater()

        mainContainer.Visible = false

        localPlayer.CharacterAdded:Connect(function(char)
            wait(2)
            setupCharacter()
        end)

        print("🧠 BRAINROT PRO MAX v4.1 - УСПЕШНО ЗАГРУЖЕН!")
        print("🎮 Управление: F - интерфейс, R - смена режима")
    end)
end)

if not success then
    warn("❌ Ошибка загрузки скрипта: " .. tostring(error))
    if screenGui then
        screenGui:Destroy()
    end
end
