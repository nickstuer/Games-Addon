local _, FR = ...

local RPS = FR.RPS or {}
FR.RPS = RPS

local rpsResult = nil
local btns = {}
local btnsAI = {}
local inGame = false

function RPS.Load()
    local RPSFrame = CreateFrame("Frame", "RPSFrame", UIParent, "BackdropTemplate")
    RPSFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    RPSFrame:SetSize(400, 300)
    RPSFrame:SetPoint("CENTER")
    RPSFrame:SetMovable(true)
    RPSFrame:EnableMouse(true)
    RPSFrame:RegisterForDrag("LeftButton")
    RPSFrame:SetScript("OnDragStart", RPSFrame.StartMoving)
    RPSFrame:SetScript("OnDragStop", RPSFrame.StopMovingOrSizing)
    RPSFrame:SetBackdropColor(0.14, 0.12, 0.2, 0.95)
    RPSFrame:SetBackdropBorderColor(0.35, 0.3, 0.6, 1)

    -- Title background for RPS Frame
    local rpsTitleBg = CreateFrame("Frame", nil, RPSFrame)
    rpsTitleBg:SetSize(1, 24)
    rpsTitleBg:SetPoint("TOPLEFT", RPSFrame, "TOPLEFT", 4, -4)
    rpsTitleBg:SetPoint("TOPRIGHT", RPSFrame, "TOPRIGHT", -24, -4)

    -- Title text
    local rpsTitle = rpsTitleBg:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    rpsTitle:SetPoint("TOP", 0, -5)
    rpsTitle:SetText("Rock Paper Scissors | Games by Plunger")

    -- Close button
    local rpsClose = CreateFrame("Button", nil, RPSFrame, "UIPanelCloseButton")
    rpsClose:SetPoint("TOPRIGHT", RPSFrame, "TOPRIGHT", -5, -5)
    rpsClose:SetScript("OnClick", function()
        RPSFrame:Hide()
    end)

    -- Play Again Button
    local playAgainBtn = CreateFrame("Button", nil, RPSFrame, "BackdropTemplate")
    playAgainBtn:SetBackdrop({
        bgFile = "Interface/Buttons/WHITE8x8",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 10,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    playAgainBtn:SetSize(140, 28)
    playAgainBtn:SetPoint("BOTTOM", 0, 10)
    playAgainBtn:SetText("Play Again")
    playAgainBtn:SetNormalFontObject("GameFontNormal")
    playAgainBtn:SetHighlightFontObject("GameFontHighlight")
    playAgainBtn:SetBackdropColor(0.22, 0.18, 0.35, 0.9)
    playAgainBtn:SetBackdropBorderColor(0.35, 0.3, 0.5, 1)
    playAgainBtn:Disable()
    playAgainBtn:SetScript("OnEnter", function(self)
        self:SetBackdropColor(0.35, 0.3, 0.5, 1)
    end)
    playAgainBtn:SetScript("OnLeave", function(self)
        self:SetBackdropColor(0.22, 0.18, 0.35, 0.9)
    end)
    playAgainBtn:SetScript("OnClick", function()
        playAgainBtn:Disable()
        rpsResult:SetText("Choose your move!")
        inGame = false
        if btns then
            for _, btn in ipairs(btns) do
                btn:Enable()
                btn:SetBackdropColor(0.22, 0.18, 0.35, 0.9)
            end

            for _, btn in ipairs(btnsAI) do
                btn:Enable()
                btn:SetBackdropColor(0.22, 0.18, 0.35, 0.9)
            end
        end
    end)


    -- Container frame for 'You' label and buttons
    local rpsYouBox = CreateFrame("Frame", "RPSYouBox", RPSFrame, "BackdropTemplate")
    rpsYouBox:SetBackdrop({
        bgFile = "Interface/Buttons/WHITE8x8",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    rpsYouBox:SetBackdropColor(0.1, 0.08, 0.15, 0.8)
    rpsYouBox:SetBackdropBorderColor(0.35, 0.3, 0.6, 1)
    rpsYouBox:SetSize(120, 180)
    rpsYouBox:SetPoint("TOP", RPSFrame, "TOP", -100, -75)
    local rpsLabel = rpsYouBox:CreateFontString("RPSYouLabel", "OVERLAY", "GameFontNormal")
    rpsLabel:SetPoint("TOP", 0, -10)
    rpsLabel:SetText("You")

    -- Container frame for 'Computer' label and buttons
    local rpsOpponentBox = CreateFrame("Frame", "RPSYouBox", RPSFrame, "BackdropTemplate")
    rpsOpponentBox:SetBackdrop({
        bgFile = "Interface/Buttons/WHITE8x8",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    rpsOpponentBox:SetBackdropColor(0.1, 0.08, 0.15, 0.8)
    rpsOpponentBox:SetBackdropBorderColor(0.35, 0.3, 0.6, 1)
    rpsOpponentBox:SetSize(120, 180)
    rpsOpponentBox:SetPoint("TOP", RPSFrame, "TOP", 100, -75)
    local rpsLabel2 = rpsOpponentBox:CreateFontString("RPSYouLabel2", "OVERLAY", "GameFontNormal")
    rpsLabel2:SetPoint("TOP", 0, -10)
    rpsLabel2:SetText("Opponent")

    -- Scoreboard
    local rpsScore = { wins = 0, losses = 0, draws = 0 }
    local rpsScoreText = RPSFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    rpsScoreText:SetPoint("TOP", 0, -30)
    rpsScoreText:SetText("Wins: 0  Losses: 0  Draws: 0")

    rpsResult = RPSFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    rpsResult:SetPoint("TOP", 0, -55)
    rpsResult:SetText("Choose your move!")

    local choices = { "Rock", "Paper", "Scissors" }

    -- User Buttons
    for i, choice in ipairs(choices) do
        -- Create button for each choice
        btns[i] = CreateFrame("Button", nil, rpsYouBox, "BackdropTemplate")
        local btn = btns[i]
        btn:SetBackdrop({
            bgFile = "Interface/Buttons/WHITE8x8",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            edgeSize = 10,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })
        btn:SetSize(100, 40)
        btn:SetPoint("TOP", rpsResult, "BOTTOM", -100, -35 - ((i - 1) * 50))

        -- Add icon
        local icon = btn:CreateTexture(nil, "ARTWORK")
        icon:SetSize(32, 32)
        icon:SetPoint("LEFT", btn, "LEFT", 5, 0)
        if choice == "Rock" then
            icon:SetTexture("Interface/AddOns/Games/Icons/rock.tga")
        elseif choice == "Paper" then
            icon:SetTexture("Interface/AddOns/Games/Icons/paper.tga")
        elseif choice == "Scissors" then
            icon:SetTexture("Interface/AddOns/Games/Icons/scissors.tga")
        end

        btn:SetText("         " .. choice)
        btn:SetNormalFontObject("GameFontNormal")
        btn:SetHighlightFontObject("GameFontHighlight")
        btn:SetBackdropColor(0.22, 0.18, 0.35, 0.9)
        btn:SetBackdropBorderColor(0.35, 0.3, 0.5, 1)

        btn:SetScript("OnEnter", function(self)
            if inGame then return end
            self:SetBackdropColor(0.35, 0.3, 0.5, 1)
        end)
        btn:SetScript("OnLeave", function(self)
            if inGame then return end
            self:SetBackdropColor(0.22, 0.18, 0.35, 0.9)
        end)
        btn:SetScript("OnClick", function(self)
            if inGame then return end
            inGame = true
            playAgainBtn:Enable()

            self:SetBackdropColor(0.6, 0.6, 0.5, 1)

            local player = choice
            local ai = choices[math.random(1, #choices)]

            if ai == "Rock" then
                btnsAI[1]:SetBackdropColor(0.6, 0.6, 0.5, 1)
            elseif ai == "Paper" then
                btnsAI[2]:SetBackdropColor(0.6, 0.6, 0.5, 1)
            elseif ai == "Scissors" then
                btnsAI[3]:SetBackdropColor(0.6, 0.6, 0.5, 1)
            end
            

            if player == ai then
                rpsScore.draws = rpsScore.draws + 1
                rpsResult:SetText("Draw! You both picked " .. player)
                --PlaySoundFile("Interface/AddOns/Games/Sounds/defeat.ogg", "SFX")
            elseif (player == "Rock" and ai == "Scissors") or
                (player == "Scissors" and ai == "Paper") or
                (player == "Paper" and ai == "Rock") then
                rpsScore.wins = rpsScore.wins + 1
                rpsResult:SetText("You win! " .. player .. " beats " .. ai)
                PlaySoundFile("Interface/AddOns/Games/Sounds/wind_chime.ogg", "SFX")

                -- Win animation effect
                local animTex = RPSFrame:CreateTexture(nil, "OVERLAY")
                animTex:SetAllPoints()
                animTex:SetColorTexture(0, 1, 0, 0.15)
                animTex:SetAlpha(0)

                local anim = animTex:CreateAnimationGroup()
                local fadeIn = anim:CreateAnimation("Alpha")
                fadeIn:SetFromAlpha(0)
                fadeIn:SetToAlpha(0.5)
                fadeIn:SetDuration(0.2)
                fadeIn:SetOrder(1)

                local scale = animTex:CreateAnimationGroup()
                local scaleAnim = scale:CreateAnimation("Scale")
                scaleAnim:SetScale(1.1, 1.1)
                scaleAnim:SetDuration(0.1)
                scaleAnim:SetOrder(1)
                scaleAnim:SetSmoothing("OUT")

                anim:SetLooping("BOUNCE")
                scale:SetLooping("BOUNCE")
                anim:Play()
                scale:Play()

                C_Timer.After(1.5, function()
                    anim:Stop()
                    scale:Stop()
                    animTex:SetAlpha(0)
                end)
            else
                rpsScore.losses = rpsScore.losses + 1
                rpsResult:SetText("You lose! " .. ai .. " beats " .. player)
                --PlaySoundFile("Interface/AddOns/Games/Sounds/defeat.ogg", "SFX")
            end
            rpsScoreText:SetText("Wins: " .. rpsScore.wins .. "  Losses: " .. rpsScore.losses .. "  Draws: " .. rpsScore.draws)
        end)
    end

    -- AI Buttons
    for i, choice in ipairs(choices) do
        -- Create button for each choice
        btnsAI[i] = CreateFrame("Button", nil, RPSFrame, "BackdropTemplate")
        local btn = btnsAI[i]
        btn:SetBackdrop({
            bgFile = "Interface/Buttons/WHITE8x8",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            edgeSize = 10,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })
        btn:SetSize(100, 40)
        btn:SetPoint("TOP", rpsResult, "BOTTOM", 100, -35 - ((i - 1) * 50))

        -- Add icon
        local icon = btn:CreateTexture(nil, "ARTWORK")
        icon:SetSize(32, 32)
        icon:SetPoint("LEFT", btn, "LEFT", 5, 0)
        if choice == "Rock" then
            icon:SetTexture("Interface/AddOns/Games/Icons/rock.tga")
        elseif choice == "Paper" then
            icon:SetTexture("Interface/AddOns/Games/Icons/paper.tga")
        elseif choice == "Scissors" then
            icon:SetTexture("Interface/AddOns/Games/Icons/scissors.tga")
        end

        btn:SetText("         " .. choice)
        btn:SetNormalFontObject("GameFontNormal")
        btn:SetHighlightFontObject("GameFontHighlight")
        btn:SetBackdropColor(0.22, 0.18, 0.35, 0.9)
        btn:SetBackdropBorderColor(0.35, 0.3, 0.5, 1)
    end

end