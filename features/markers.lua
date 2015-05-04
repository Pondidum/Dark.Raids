local addon, ns = ...
local config = ns.config

local style = ns.lib.style
local media = ns.lib.media
local layout = ns.lib.layout

-- local api
local NUM_WORLD_RAID_MARKERS = NUM_WORLD_RAID_MARKERS
local IsRaidMarkerActive = IsRaidMarkerActive

local SPACING = 4

local scalingLayout = layout:extend({

	afterLayout = function(self)

		for i, child in ipairs(self.children) do
			child:SetSize(self.childSize, self.childSize)
		end

	end,

	setChildSize = function(self, value)
		self.childSize = value
	end,
})

local markers = ns.lib.class:extend({

	ctor = function(self)
		self:include(ns.lib.events)
		self:include(ns.lib.mixins.updates)

		self:createUI()

		self:register("PARTY_LEADER_CHANGED")
		self:register("PLAYER_ENTERING_WORLD")
	end,

	PARTY_LEADER_CHANGED = function(self)
		self:setVisibility()
	end,

	PLAYER_ENTERING_WORLD = function(self)
		self:setVisibility()
	end,

	onUpdate = function(self)

		for i, mark in ipairs(self.markers) do

			local isActive = IsRaidMarkerActive(i)

			if mark.active ~= isActive then

				if isActive then
					mark.bg:SetBackdropColor(unpack(mark.color))
				else
					mark.bg:SetBackdropColor(unpack(media.colors.background))
				end

				mark.active = isActive
			end
		end

	end,

	createUI = function(self)

		local container = CreateFrame("Frame", "DarkRaidWorldMarkers", UIParent)
		local markers = {}

		self.container = container
		self.markers = markers

		container:SetPoint("TOPLEFT", MinimapCluster, "BOTTOMLEFT", 0, -5)
		container:SetPoint("TOPRIGHT", MinimapCluster, "BOTTOMRIGHT", 0, -5)

		local startingButtonSize = 24
		container:SetHeight(startingButtonSize)

		local engine = scalingLayout:new(container, {
			layout = "horizontal",
			origin = "LEFT",
			wrap = false,
			autosize = "none",
			itemSpacing = SPACING
		})

		engine:setChildSize(startingButtonSize)

		for i = 1, NUM_WORLD_RAID_MARKERS do
			local button = self:createButton(i)
			markers[i] = button
			engine:addChild(button)
		end

		engine:performLayout()

		MinimapCluster:SetScript("OnSizeChanged", function(self, width, h)

			local numSpacers = NUM_WORLD_RAID_MARKERS - 1

			local newSize = (width - (numSpacers * SPACING)) / NUM_WORLD_RAID_MARKERS

			container:SetHeight(newSize)
			engine:setChildSize(newSize)

			engine:performLayout()

		end)


	end,

 	createButton = function(self, index)

		local button = CreateFrame("CheckButton", "DarkRaidWorldMarkers"..index, self.container, "ActionButtonTemplate, SecureActionButtonTemplate")

		button:SetAttribute("type", "macro")
		button:SetAttribute("macrotext1", "/wm " .. index)
		button:SetAttribute("macrotext2", "/cwm " .. index)

		button.text = media.fonts:create(button, nil, 10)
		button.text:SetAllPoints(button)
		button.text:SetJustifyH("CENTER")

		style:actionButton(button)

		local text = _G["WORLD_MARKER" .. index]
		local i = text:find(" |cff")

		button.color = {self:rgbFromHex(text:sub(i + 5, i + 10))}
		button.text:SetText(text:sub(1, i-1))

		button:RegisterForClicks("AnyUp")

		return button

	end,

	rgbFromHex = function(self, hex)
		local rhex, ghex, bhex = string.sub(hex, 1, 2), string.sub(hex, 3, 4), string.sub(hex, 5, 6)
		return tonumber(rhex, 16) / 255, tonumber(ghex, 16) / 255, tonumber(bhex, 16) / 255
	end,

	setVisibility = function(self)

		if IsInGroup() or IsInRaid() then
			self.container:Show()
		else
			self.container:Hide()
		end
	end,

})

ns.features.markers = function()
	return markers:new()
end
