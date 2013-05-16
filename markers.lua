local addon, ns = ...
local config = ns.config

local core = Dark.core
local events = core.events.new()
local ui = core.ui
local style = core.style

-- local api
local NUM_WORLD_RAID_MARKERS = NUM_WORLD_RAID_MARKERS
local IsRaidMarkerActive = IsRaidMarkerActive

local NUM_SPACERS = NUM_WORLD_RAID_MARKERS - 1
local SPACING = 2
local PADDING = 0

local rgbFromHex = function(hex)
	local rhex, ghex, bhex = string.sub(hex, 1, 2), string.sub(hex, 3, 4), string.sub(hex, 5, 6)
	return tonumber(rhex, 16) / 255, tonumber(ghex, 16) / 255, tonumber(bhex, 16) / 255
end

local createButton = function(parent, index)

	local button = CreateFrame("Button", "DarkRaidWorldMarkers"..index, parent, "ActionButtonTemplate, SecureActionButtonTemplate")

	button:RegisterForClicks("AnyUp")
	button:SetAttribute("type", "macro")
	button:SetAttribute("macrotext1", "/wm " .. index)
	button:SetAttribute("macrotext2", "/cwm " .. index)

	button.text = ui.createFont(button, core.fonts.normal, 12)
	button.text:SetAllPoints(button)
	button.text:SetJustifyH("CENTER")

	style.actionButton(button)
	style.addBackground(button)
	style.addShadow(button)

	local text = _G["WORLD_MARKER" .. index]
		local i = text:find(" |cff")

	button.color = {rgbFromHex(text:sub(i+5, i+10))}
	button.text:SetText(text:sub(1, i-1))

	return button

end


local markers = {
	
	new = function() 

		local markers = {}
		local container = CreateFrame("Frame", "DarkRaidWorldMarkers", UIParent)

		container:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, -10)
		container:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, -10)

		local buttonSize = (Minimap:GetWidth() - (NUM_SPACERS * SPACING)) / NUM_WORLD_RAID_MARKERS
		container:SetHeight(buttonSize)

		core.layout.init(container, {
			marginLeft = SPACING,
			marginRight = SPACING,
			marginTop = SPACING,
			marginBottom = SPACING,
			paddingLeft = PADDING,
			paddingRight = PADDING,
			paddingTop = PADDING,
			paddingBottom = PADDING,
			defaultChildWidth = buttonSize,
			defaultChildHeight = buttonSize,
			forceChildSize = true,
		})

		for i = 1, NUM_WORLD_RAID_MARKERS do
			markers[i] = container.add(createButton(container, i))
		end

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

			if IsInGroup() and (not IsInRaid() or (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player"))) then
				container:Show()
			else
				container:Hide()
			end

		end

		events.register("GROUP_ROSTER_UPDATE", setVisibility)
		events.register("PLAYER_ENTERING_WORLD", setVisibility)
		events.registerOnUpdate(onUpdate)

	end,

}

ns.markers = markers