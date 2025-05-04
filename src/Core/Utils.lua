local addonName, addon = ...
local Utils = addon.Utils or {}
addon.Utils = Utils

function Utils.Debug(...)
    if addon.Config.DEBUG_ENABLED then
        print("|cff33ff99" .. addonName .. "|r|cffFFF468[DEBUG]|r: ", ...);
    end
end

function Utils.Print(...)
	print("|cff33ff99" .. addonName .. "|r: ", ...);
end

function Utils.GetFullPlayerName()
    local name, realm = UnitName("player")
    realm = realm or GetRealmName()
    return name .. "-" .. realm:gsub("%s+", "")
end

return Utils