local _, FR = ...

local GTN = FR.GTN or {}
FR.GTN = GTN

local secret = nil

function GTN:Load()
    -- Guess the Number Game Frame
    local GuessFrame = CreateFrame("Frame", "GuessFrame", UIParent, "BackdropTemplate")
    GuessFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    GuessFrame:SetSize(280, 160)
    GuessFrame:SetPoint("CENTER")
    GuessFrame:SetMovable(true)
    GuessFrame:EnableMouse(true)
    GuessFrame:RegisterForDrag("LeftButton")
    GuessFrame:SetScript("OnDragStart", GuessFrame.StartMoving)
    GuessFrame:SetScript("OnDragStop", GuessFrame.StopMovingOrSizing)
    GuessFrame:SetBackdropColor(0.14, 0.12, 0.2, 0.95)
    GuessFrame:SetBackdropBorderColor(0.35, 0.3, 0.6, 1)

    -- Title background for Guess Frame
    local guessTitleBg = CreateFrame("Frame", nil, GuessFrame)
    guessTitleBg:SetSize(1, 24)
    guessTitleBg:SetPoint("TOPLEFT", GuessFrame, "TOPLEFT", 4, -4)
    guessTitleBg:SetPoint("TOPRIGHT", GuessFrame, "TOPRIGHT", -24, -4)

    -- Title text
    local guessTitle = guessTitleBg:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    guessTitle:SetPoint("TOP", 0, -10)
    guessTitle:SetText("Games by Plunger | Guess the Number")

    -- Close button
    local guessClose = CreateFrame("Button", nil, GuessFrame, "UIPanelCloseButton")
    guessClose:SetPoint("TOPRIGHT", GuessFrame, "TOPRIGHT", -5, -5)
    guessClose:SetScript("OnClick", function()
        GuessFrame:Hide()
    end)


    local resultText = GuessFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    resultText:SetPoint("TOP", 0, -40)
    resultText:SetText("Guess a number from 1 to 10!")

    local input = CreateFrame("EditBox", nil, GuessFrame, "InputBoxTemplate")
    input:SetSize(100, 30)
    input:SetPoint("TOP", resultText, "BOTTOM", 0, -10)
    input:SetAutoFocus(false)
    input:SetNumeric(true)

    secret = math.random(1, 10)

    local submitBtn = CreateFrame("Button", nil, GuessFrame, "BackdropTemplate")
    submitBtn:SetBackdrop({
        bgFile = "Interface/Buttons/WHITE8x8",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 10,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    submitBtn:SetSize(100, 24)
    submitBtn:SetPoint("TOP", input, "BOTTOM", 0, -10)
    submitBtn:SetText("Guess")
    submitBtn:SetNormalFontObject("GameFontNormal")
    submitBtn:SetHighlightFontObject("GameFontHighlight")
    submitBtn:SetBackdropColor(0.22, 0.18, 0.35, 0.9)
    submitBtn:SetBackdropBorderColor(0.35, 0.3, 0.5, 1)
    submitBtn:SetScript("OnEnter", function(self)
        self:SetBackdropColor(0.35, 0.3, 0.5, 1)
    end)
    submitBtn:SetScript("OnLeave", function(self)
        self:SetBackdropColor(0.22, 0.18, 0.35, 0.9)
    end)
    submitBtn:SetScript("OnClick", function()
        local guess = tonumber(input:GetText())
        if not guess then
            resultText:SetText("Enter a valid number.")
        elseif guess == secret then
            resultText:SetText("Correct!")
            submitBtn:Disable()
            C_Timer.After(5, function()
                resultText:SetText("Enter a valid number.")
                secret = math.random(1, 10)
                submitBtn:Enable()
            end)
            
        elseif guess < secret then
            resultText:SetText("Too low!")
        else
            resultText:SetText("Too high!")
        end
        input:SetText("")
    end)
end

