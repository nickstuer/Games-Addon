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
    Utils.Print("Version: " .. FR.version)
end
