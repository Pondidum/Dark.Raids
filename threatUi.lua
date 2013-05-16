local addon, ns = ...
local config = ns.config.threat 

local core = Dark.core
local events = core.events.new()
local layout = core.layout
local style = core.style
local ui = core.ui

local round = function(number, decimals)
	if not decimals then decimals = 0 end
    return (("%%.%df"):format(decimals)):format(number)
end

local threatUi = {

	new = function()

		local container = CreateFrame("Frame", "DarkuiRaidsThreat", UIParent)

		local anchor = DarkRaidWorldMarkers or Minimap

		container:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -10)
		container:SetPoint("TOPRIGHT", anchor, "BOTTOMRIGHT", 0, -10)

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

			local onEnterCombat = function()
				container:Show()
			end

			local onExitCombat = function()
				container:Hide()
			end

			events.register("PLAYER_REGEN_DISABLED", onEnterCombat)
			events.register("PLAYER_REGEN_ENABLED", onExitCombat)

			if not InCombatLockdown() then
				onExitCombat()
			end

		end

		local bars = {}

		for i = 1, config.rowCount do

			local bar = CreateFrame("StatusBar", "DarkuiRaidsThreat"..i, container)
			bar:SetStatusBarTexture(core.textures.normal)
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
					local color = RAID_CLASS_COLORS[classConst] or {r = 0.5, g = 0.5, b = 0.5}
	
					if not color then 
						print(set.name, classConst)
					end

					bar:SetValue(set.value)
					bar.value:SetText(round(set.value, 2))
					bar.name:SetText(set.name)
					bar:SetStatusBarColor(color.r, color.g, color.b)
					bar:Show()

				else

					bar:Hide()

				end

			end

			for i, set in ipairs(result) do 

				local bar = bars[i]
				
			end

		end

		local meter = ns.threatMeter.new(onUpdate)

		return container

	end,

}

ns.threatUi = threatUi