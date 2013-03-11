local addon, ns = ...
local config = ns.config.threat 

local core = Dark.core
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
			marginTop = config.rowHeight / 2,
			marginBottom = config.rowHeight / 2,
		})

		style.addBackground(container)
		style.addShadow(container)

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

			print("----------------")
			for i, set in ipairs(result) do 

				local bar = bars[i]

				print(set.index, set.name, set.value)
				
				bar:SetValue(set.value)
				bar.value:SetText(round(set.value, 2))
				bar.name:SetText(set.name)
			end

		end

		local meter = ns.threatMeter.new(onUpdate)

		return container

	end,

}

ns.threatUi = threatUi