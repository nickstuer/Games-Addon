local addonName, FR = ...;

local Utils = FR.Utils or {}
FR.Utils = Utils

FR.version = C_AddOns.GetAddOnMetadata("Games", "Version") or "Unknown"

-- Initialize the addon
local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED")
initFrame:RegisterEvent("PLAYER_LOGIN")
initFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

initFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
		self:UnregisterEvent("ADDON_LOADED")
	end

	if event == "PLAYER_LOGIN" then
		self:UnregisterEvent("PLAYER_LOGIN")
	end

	if event == "PLAYER_ENTERING_WORLD" then
		Utils.Print("Addon Loaded.")
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end

end)

-- Slash Commands
SLASH_GAMES1 = "/games"
SlashCmdList["GAMES"] = function()
    Utils.Debug("Version: " .. FR.version)
	FR.OpenGameLauncher()
end


FR.OpenGameLauncher = function()
	local GameLauncher = CreateFrame("Frame", "GameLauncherFrame", UIParent, "BackdropTemplate")
	GameLauncher:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	})
	GameLauncher:SetSize(300, 240)
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
	
	-- Tic Tac Toe Launcher Button
	CreateGameButton(GameLauncher, "Play Tic Tac Toe", -60, function()
		GameLauncher:Hide()
		FR.TTT:Load()
	end)
	
	-- Guess the Number Launcher Button
	CreateGameButton(GameLauncher, "Play Guess the Number", -100, function()
		GameLauncher:Hide()
		FR.GTN:Load()
	end)

	-- Coming Soon Placeholder Button
	local comingSoon = CreateGameButton(GameLauncher, "Coming Soon...", -140, function() end)
	comingSoon:Disable()

	-- Coming Soon Placeholder Button
	local comingSoon2 = CreateGameButton(GameLauncher, "Coming Soon 2...", -180, function() end)
	comingSoon2:Disable()
	
	GameLauncher:Show()
end

