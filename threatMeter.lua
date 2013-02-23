local addon, ns = ...
local events = Dark.core.events

local threatMeter = {
	
	new = function()

		local frame = CreateFrame("Frame", "DarkRaidsThreatMeter", UIParent)
		frame:SetPoint("TOPLEFT", MinimapFrame, "BOTTOMLEFT", 0, 2)
		frame:SetPoint("TOPRIGHT", MinimapFrame, "BOTTOMRIGHT", 0, 2)
		frame:SetHeight(120)

		local onThreadListUpdated = function()

		
		end

		events.register("UNIT_THREAT_LIST_UPDATE", nil, onThreadListUpdated)
	end,

}

ns.threatMeter = threatMeter