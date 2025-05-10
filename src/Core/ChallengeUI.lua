local _, FR = ...

local Challenge = FR.Challenge or {}
FR.Challenge = Challenge

local secret = nil

local Utils = FR.Utils or {}
FR.Utils = Utils

Challenge.ChallengeWindow = function()
	local GameLauncher = CreateFrame("Frame", "GameLauncherFrame", UIParent, "BackdropTemplate")
	GameLauncher:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	})
	GameLauncher:SetSize(300, 280)
	GameLauncher:SetPoint("CENTER")
	GameLauncher:SetMovable(true)
	GameLauncher:EnableMouse(true)
	GameLauncher:RegisterForDrag("LeftButton")
	GameLauncher:SetScript("OnDragStart", GameLauncher.StartMoving)
	GameLauncher:SetScript("OnDragStop", GameLauncher.StopMovingOrSizing)
	GameLauncher:SetBackdropColor(0.2, 0.1, 0.3, 0.9)
	GameLauncher:SetBackdropBorderColor(0.5, 0.3, 0.8, 1)

	-- Add X button
	local closeButton = CreateFrame("Button", nil, GameLauncher, "UIPanelCloseButton")
	closeButton:SetPoint("TOPRIGHT", GameLauncher, "TOPRIGHT", -5, -5)
	closeButton:SetScript("OnClick", function()
		GameLauncher:Hide()
	end)
	
	-- Title background frame
	local titleBg = CreateFrame("Frame", nil, GameLauncher)
	titleBg:SetSize(1, 24)
	titleBg:SetPoint("TOPLEFT", GameLauncher, "TOPLEFT", 4, -4)
	titleBg:SetPoint("TOPRIGHT", GameLauncher, "TOPRIGHT", -24, -4)

	GameLauncher.title = titleBg:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	GameLauncher.title:SetPoint("TOP", 0, -10)
	GameLauncher.title:SetText("Games by Plunger | v" .. FR.version)
		
	local function CreateGameButton(parent, label, yOffset, onClick)
		local btn = CreateFrame("Button", nil, parent, "BackdropTemplate")
		btn:SetBackdrop({
			bgFile = "Interface/Buttons/WHITE8x8",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			edgeSize = 10,
			insets = { left = 2, right = 2, top = 2, bottom = 2 }
		})
		btn:SetSize(200, 32)
		btn:SetPoint("TOP", parent, "TOP", 0, yOffset)
		btn:SetText(label)
		btn:SetScript("OnClick", onClick)
	
		-- Purple styling
		btn:SetNormalFontObject("GameFontNormal")
		btn:SetHighlightFontObject("GameFontHighlight")
		btn:SetBackdropColor(0.22, 0.18, 0.35, 0.9)
		btn:SetBackdropBorderColor(0.35, 0.3, 0.5, 1)
	
		btn:SetScript("OnEnter", function(self)
			self:SetBackdropColor(0.35, 0.3, 0.5, 1)
		end)
		btn:SetScript("OnLeave", function(self)
			self:SetBackdropColor(0.22, 0.18, 0.35, 0.9)
		end)
	
		return btn
	end
	
	local y = -60
	local yOffset = 40

    -- Separator line
    local sep1 = GameLauncher:CreateTexture(nil, "ARTWORK")
    sep1:SetColorTexture(1, 1, 1, 0.2)
    sep1:SetSize(280, 1)
    sep1:SetPoint("TOPLEFT", 10, y)
    y = y - 10

    local label1 = GameLauncher:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label1:SetPoint("TOPLEFT", 10, y)
    label1:SetText("Computer")
    y = y - 25

    -- Difficulty options
    local options = {"Easy"}
    for i, text in ipairs(options) do
        local optionLabel = GameLauncher:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        optionLabel:SetPoint("TOPLEFT", 10, y)
        optionLabel:SetText(text)
        y = y - 30
    end


    -- Separator line
    local sep1 = GameLauncher:CreateTexture(nil, "ARTWORK")
    sep1:SetColorTexture(1, 1, 1, 0.2)
    sep1:SetSize(280, 1)
    sep1:SetPoint("TOPLEFT", 10, y)
    y = y - 10

    local label1 = GameLauncher:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label1:SetPoint("TOPLEFT", 10, y)
    label1:SetText("Guild")
    y = y - 25

    -- Difficulty options
    local options2 = {"Placeholder-Kel-Thuzad", "Placeholder2-Kel-Thuzad", "Placeholder3-Kel-Thuzad"}
    for i, text in ipairs(options2) do
        local optionLabel = GameLauncher:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        optionLabel:SetPoint("TOPLEFT", 10, y)
        optionLabel:SetText(text)
        y = y - 30
    end


    -- Tic Tac Toe Launcher Button
	CreateGameButton(GameLauncher, "Play Tic Tac Toe", y, function()
		GameLauncher:Hide()
		FR.TTT:Load()
	end)
	y = y - yOffset
	
	-- Guess the Number Launcher Button
	CreateGameButton(GameLauncher, "Play Guess the Number", y, function()
		GameLauncher:Hide()
		FR.GTN:Load()
	end)
	y = y - yOffset

	-- Rock Paper Scissors Launcher Button
	CreateGameButton(GameLauncher, "Play Rock Paper Scissors", y, function()
		GameLauncher:Hide()
		FR.RPS:Load()
	end)
	y = y - yOffset

	-- Coming Soon Placeholder Button
	local comingSoon = CreateGameButton(GameLauncher, "Coming Soon...", y, function() end)
	comingSoon:Disable()
	y = y - yOffset

	-- Coming Soon Placeholder Button
	local comingSoon2 = CreateGameButton(GameLauncher, "Coming Soon 2...", y, function() end)
	comingSoon2:Disable()
	y = y - yOffset
	
	GameLauncher:Show()
end

