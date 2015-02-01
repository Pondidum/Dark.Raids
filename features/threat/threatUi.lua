local addon, ns = ...
local config = ns.config.threat

local class = ns.lib.class
local events = ns.lib.events

local lib = Dark.core
local layout = lib.layout
local style = lib.style
local ui = lib.ui
local colors = lib.colors
local textures = lib.textures

local round = function(number, decimals)
	if not decimals then decimals = 0 end
    return (("%%.%df"):format(decimals)):format(number)
end

local threatUi = {

	new = function(model)

		local container = CreateFrame("Frame", "DarkuiRaidsThreat", UIParent)

		local anchor = DarkRaidWorldMarkers or Minimap

		container:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -4)
		container:SetPoint("TOPRIGHT", anchor, "BOTTOMRIGHT", 0, -4)

		layout.init(container, {
			type = "STACK",
			origin = "TOP",
			autosize = true,
			marginTop = config.rowSpacing / 2,
			marginBottom = config.rowSpacing / 2,
		})

		style.addBackground(container)
		style.addShadow(container)

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
			bar:SetStatusBarTexture(textures.normal)
			bar:SetHeight(config.rowHeight)
			bar:SetMinMaxValues(0, 100)

			local value = ui.createFont(bar)
			value:SetPoint("TOPRIGHT", bar, "TOPRIGHT")
			value:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT")
			value:SetWidth(40)
			bar.value = value

			local name = ui.createFont(bar)
			name:SetPoint("TOPLEFT", bar, "TOPLEFT")
			name:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT")
			name:SetPoint("RIGHT", value, "LEFT")
			bar.name = name

			bars[i] = container.add(bar)

		end

		local onUpdate = function(result)

			for i, bar in ipairs(bars) do

				local set = result[i]

				if set then

					local class, classConst = UnitClass(set.name)
					local color = colors.class[classConst] or {0.5, 0.5, 0.5}

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

			for i, set in ipairs(result) do

				local bar = bars[i]

			end

		end

		model.onThreatUpdate = onUpdate

		return container

	end,

}

ns.features.threat.ui = threatUi
