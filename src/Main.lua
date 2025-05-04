local addonName, FR = ...;

local Utils = FR.Utils or {}
FR.Utils = Utils

FR.version = C_AddOns.GetAddOnMetadata("Games", "Version") or "Unknown"
local ADDON_PREFIX = "GamesPing"
FR.detectedUsers = {}

-- Initialize the addon
local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED")
initFrame:RegisterEvent("PLAYER_LOGIN")
initFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
initFrame:RegisterEvent("CHAT_MSG_ADDON")

initFrame:SetScript("OnEvent", function(self, event, ...)
    --if event == "ADDON_LOADED" and arg1 == addonName then
	--	self:UnregisterEvent("ADDON_LOADED")
	--end

	if event == "PLAYER_LOGIN" then
		C_ChatInfo.RegisterAddonMessagePrefix(ADDON_PREFIX)
		C_ChatInfo.SendAddonMessage(ADDON_PREFIX, "ping", "RAID")
		self:UnregisterEvent("PLAYER_LOGIN")
	end

	if event == "PLAYER_ENTERING_WORLD" then
		Utils.Print("Addon Loaded.")
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end

	if event == "CHAT_MSG_ADDON" then
		local prefix, message, channel, sender = ...

		if prefix ~= ADDON_PREFIX then return end
		if sender == Utils.GetFullPlayerName() then return end

		Utils.Print("Received addon message: " .. message .. " from " .. sender)

		if message == "ping" then
			-- Respond to ping
			C_ChatInfo.SendAddonMessage(ADDON_PREFIX, "pong", channel)
		elseif message == "pong" then
			-- Record other addon user
			if not FR.detectedUsers[sender] then
				Utils.Print("Detected addon user: " .. sender)
				FR.detectedUsers[sender] = true
			end
		end
	end

end)

-- Slash Commands
SLASH_GAMES1 = "/games"
SlashCmdList["GAMES"] = function()
    Utils.Debug("Version: " .. FR.version)
	FR.OpenGameLauncher()
end

FR.DetectOtherPlayers = function()
	local playerCount = 0
	for i = 1, GetNumGroupMembers() do
		if UnitIsPlayer("party" .. i) then
			playerCount = playerCount + 1
		end
	end
	return playerCount
end
FR.OpenGameLauncher = function()
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

