local addon, ns = ...
local config = ns.config.threat 

local core = Dark.core
local layout = core.layout
local style = core.style

local round = function(number, decimals)
	if not decimals then decimals = 0 end
    return (("%%.%df"):format(decimals)):format(number)
end

local threatUi = {

	new = function()

		local container = CreateFrame("Frame", "DarkuiRaidsThreat", UIParent)

		container:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, 0)
		container:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, 0)

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

			local bar = CreateFrame("StatusBar", nil, container)
			bar:SetHeight(config.rowHeight)
			bar:SetMinMaxValues(0, 100)

			local value = ui.createFont(bar)
			value:SetPoint("TOPRIGHT", bar, "TOPRIGHT")
			value:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT")
			value:SetWidth(30)
			bar.value = value

			local name = ui.createFont(bar)
			name:SetPoint("TOPLEFT", bar, "TOPLEFT")
			name:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT")
			name:SetPoint("RIGHT", value, "LEFT")
			bar.name = name

			bars[i] = container.add(bar)

		end

		local onUpdate = function(list)

			for i, guid, value in list() do 
				bar:SetValue(value)
				bar.value:SetText(string.format("%f%%", round(value)))
				bar.name:SetText(UnitName(guid))
			end

		end

		local meter = ns.threatMeter.new(onUpdate)

	end,

}

ns.threatUi = threatUi