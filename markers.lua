local addon, ns = ...
local config = ns.config

local core = Dark.core
local events = core.events
local ui = core.ui
local style = core.style

-- local api
local NUM_WORLD_RAID_MARKERS = NUM_WORLD_RAID_MARKERS
local IsRaidMarkerActive = IsRaidMarkerActive

local NUM_SPACERS = NUM_WORLD_RAID_MARKERS + 1
local CONTAINER_HEIGHT = 32
local SPACING = 3

local createButton = function(parent, index)

	local button = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate")

	button:RegisterForClicks("AnyUp")
	button:SetAttribute("type", "macro")
	button:SetAttribute("macrotext1", "/wm " .. index)
	button:SetAttribute("macrotext2", "/cwm " .. index)

	button.text = ui.createFont(button, core.fonts.normal, 12)
	button.text:SetAllPoints(button)
	button.text:SetJustifyH("CENTER")

	local text = _G["WORLD_MARKER" .. index]
	button.name = text
	button.text:SetText(text:gsub("World Marker", ""))

	style.addBackground(button)
	style.addShadow(button)

	return button

end


local markers = {
	
	new = function() 

		local markers = {}

		local rgbFromHex = function(hex)
			local rhex, ghex, bhex = string.sub(hex, 1, 2), string.sub(hex, 3, 4), string.sub(hex, 5, 6)
			return tonumber(rhex, 16) / 255, tonumber(ghex, 16) / 255, tonumber(bhex, 16) / 255
		end

		local getMarkerColor = function(name)

			local offset = string.find(name, "|cff") + 4
			return rgbFromHex(string.sub(name, offset))

		end

		local onUpdate = function()

			for i, mark in ipairs(markers) do

				if IsRaidMarkerActive(i) then
					mark.bg:SetBackdropColor(getMarkerColor(mark.name))
				else
					mark.bg:SetBackdropColor(unpack(core.colors.background))
				end

			end

		end

		local create = function()

			local container = CreateFrame("Frame", "DarkRaidWorldMarkers", UIParent)
			container:SetPoint("TOPLEFT", MinimapFrame, "BOTTOMLEFT", 0, 0)
			container:SetPoint("TOPRIGHT", MinimapFrame, "BOTTOMRIGHT", 0, 0)
			container:SetHeight(CONTAINER_HEIGHT)

			local buttonWidth = (container:GetWidth() - (NUM_SPACERS * SPACING)) / NUM_WORLD_RAID_MARKERS
			local containerConfig = {
				marginLeft = SPACING,
				marginRight = SPACING,
				marginTop = SPACING,
				marginBottom = SPACING,
				defaultChildWidth = buttonWidth,
				defaultChildHeight = CONTAINER_HEIGHT - SPACING - SPACING,
				forceChildSize = true,
			}

			core.layout.init(container, containerConfig)
			style.addBackground(container)
			style.addShadow(container)

			for i = 1, NUM_WORLD_RAID_MARKERS do
				local mark = createButton(container, i)
				
				markers[i] = mark
				container.add(mark)
			end

			events.registerOnUpdate("DarkRaidWorldMarkers", onUpdate)

		end

		create()

	end,

}

ns.markers = markers