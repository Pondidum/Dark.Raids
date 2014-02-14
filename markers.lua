local addon, ns = ...
local config = ns.config

local core = Dark.core
local events = core.events.new()
local ui = core.ui
local style = core.style

-- local api
local NUM_WORLD_RAID_MARKERS = NUM_WORLD_RAID_MARKERS
local IsRaidMarkerActive = IsRaidMarkerActive


local rgbFromHex = function(hex)
	local rhex, ghex, bhex = string.sub(hex, 1, 2), string.sub(hex, 3, 4), string.sub(hex, 5, 6)
	return tonumber(rhex, 16) / 255, tonumber(ghex, 16) / 255, tonumber(bhex, 16) / 255
end

local createButton = function(parent, index)

	local button = CreateFrame("Button", "DarkRaidWorldMarkers"..index, parent, "ActionButtonTemplate, SecureActionButtonTemplate")

	button:SetAttribute("type", "macro")
	button:SetAttribute("macrotext1", "/wm " .. index)
	button:SetAttribute("macrotext2", "/cwm " .. index)

	button.text = ui.createFont(button, core.fonts.normal, 12)
	button.text:SetAllPoints(button)
	button.text:SetJustifyH("CENTER")

	style.actionButton(button)

	local text = _G["WORLD_MARKER" .. index]
	local i = text:find(" |cff")

	button.color = {rgbFromHex(text:sub(i+5, i+10))}
	button.text:SetText(text:sub(1, i-1))

	return button

end


local SPACING = 4

local markers = {

	new = function()

		local markers = {}
		local container = CreateFrame("Frame", "DarkRaidWorldMarkers", UIParent)

		container:SetPoint("TOPLEFT", MinimapCluster, "BOTTOMLEFT", 0, -5)
		container:SetPoint("TOPRIGHT", MinimapCluster, "BOTTOMRIGHT", 0, -5)

		local startingButtonSize = 24
		container:SetHeight(startingButtonSize)

		core.layout.init(container, {
			marginLeft = 0,
			marginRight = SPACING,
			marginTop = 0,
			marginBottom = 0,
			paddingLeft = 0,
			paddingRight = 0,
			paddingTop = 0,
			paddingBottom = 0,
			defaultChildWidth = startingButtonSize,
			defaultChildHeight = startingButtonSize,
			forceChildSize = true,
		})

		for i = 1, NUM_WORLD_RAID_MARKERS do
			markers[i] = container.add(createButton(container, i))
		end

		MinimapCluster:SetScript("OnSizeChanged", function(self, width, h)

			local numSpacers = NUM_WORLD_RAID_MARKERS - 1

			local newSize = (width - (numSpacers * SPACING)) / NUM_WORLD_RAID_MARKERS

			container:SetHeight(newSize)
			container.layout.defaultChildHeight = newSize
			container.layout.defaultChildWidth = newSize

			container.performLayout()

		end)

		local onUpdate = function()

			for i, mark in ipairs(markers) do

				local isActive = IsRaidMarkerActive(i)

				if mark.active ~= isActive then

					if isActive then
						mark.bg:SetBackdropColor(unpack(mark.color))
					else
						mark.bg:SetBackdropColor(unpack(core.colors.background))
					end

					mark.active = isActive
				end
			end

		end


		local setVisibility = function()

			if IsInGroup() or IsInRaid() then

				container:Show()

				local clicks = nil

				if not IsInRaid() or (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
					clicks = "AnyUp"
				end

				for i, button in ipairs(markers) do
					button:RegisterForClicks(clicks)
				end

			else
				container:Hide()
			end

		end

		events.register("PARTY_LEADER_CHANGED", setVisibility)
		events.register("PLAYER_ENTERING_WORLD", setVisibility)
		events.registerOnUpdate(onUpdate)

	end,

}

ns.markers = markers