local addon, ns = ...
local config = ns.config.threat

local class = ns.lib.class
local events = ns.lib.events
local layout = ns.lib.layout
local style = ns.lib.style
local media = ns.lib.media

local round = function(number, decimals)
	if not decimals then decimals = 0 end
    return (("%%.%df"):format(decimals)):format(number)
end

local stickyLayout = layout:extend({

	afterLayout = function(self)

		local container = self.container

		for i, child in ipairs(self.children) do
			child:SetPoint("LEFT", container, "LEFT")
			child:SetPoint("RIGHT", container, "RIGHT")
		end
	end,

})

local threatUi = {

	new = function(model)

		local container = CreateFrame("Frame", "DarkuiRaidsThreat", UIParent)

		local anchor = DarkRaidWorldMarkers or Minimap

		container:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -4)
		container:SetPoint("TOPRIGHT", anchor, "BOTTOMRIGHT", 0, -4)

		local engine = stickyLayout:new(container, {
			layout = "vertical",
			origin = "TOP",
			wrap = false,
			autosize = "y",
			itemSpacing = config.rowSpacing
		})

		style:frame(container)

		if config.toggleOnCombat then

			local toggle = events:new({
				PLAYER_REGEN_DISABLED = function() container:Show() end,
				PLAYER_REGEN_ENABLED = function() container:Hide() end,
			})

			if not InCombatLockdown() then
				toggle:PLAYER_REGEN_ENABLED()
			end

		end

		local bars = {}

		for i = 1, config.rowCount do

			local bar = CreateFrame("StatusBar", "DarkuiRaidsThreat"..i, container)
			bar:SetStatusBarTexture(media.textures.normal)
			bar:SetHeight(config.rowHeight)
			bar:SetMinMaxValues(0, 100)

			local value = media.fonts:create(bar)
			value:SetPoint("TOPRIGHT", bar, "TOPRIGHT")
			value:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT")
			value:SetWidth(40)
			bar.value = value

			local name = media.fonts:create(bar)
			name:SetPoint("TOPLEFT", bar, "TOPLEFT")
			name:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT")
			name:SetPoint("RIGHT", value, "LEFT")
			bar.name = name

			bars[i] = bar
			engine:addChild(bar)

		end

		engine:performLayout()

		local onUpdate = function(result)


			for i, bar in ipairs(bars) do

				local set = result[i]

				if set then

					local class, classConst = UnitClass(set.name)
					local color = media.colors.class[classConst] or {0.5, 0.5, 0.5}

					if not color then
						print(set.name, classConst)
					end

					bar:SetValue(set.value)
					bar.value:SetText(round(set.value, 2))
					bar.name:SetText(set.name)
					bar:SetStatusBarColor(unpack(color))
					bar:Show()

				else

					bar:Hide()

				end

			end

		end

		model.onThreatUpdate = onUpdate

		return container

	end,

}

ns.features.threat.ui = threatUi
