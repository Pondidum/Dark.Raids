local addon, ns = ...

local core = Dark.core
local layout = core.layout
local style = core.style

local SPACING = 4
local PADDING = 0

local tools = {

	new = function()

		local height = DarkRaidWorldMarkers:GetHeight()

		local container = CreateFrame("Frame", "DarkRaidTools", UIParent)
		container:SetPoint("TOPLEFT", DarkRaidWorldMarkers, "BOTTOMLEFT", 0, -10)
		container:SetPoint("TOPRIGHT", DarkRaidWorldMarkers, "BOTTOMRIGHT", 0, -10)

		container:SetHeight(height)


		layout.init(container, {
			marginLeft = SPACING,
			marginRight = SPACING,
			marginTop = SPACING,
			marginBottom = SPACING,
			paddingLeft = PADDING,
			paddingRight = PADDING,
			paddingTop = PADDING,
			paddingBottom = PADDING,
			defaultChildWidth = height,
			defaultChildHeight = height,
			forceChildSize = true,
		})

		local readyCheck = CreateFrame("Button", nil, container)
		style.actionButton(readyCheck)

		local roleCheck = CreateFrame("Button", nil, container)
		style.actionButton(roleCheck)

		local setVisibility = function()

			if IsInGroup() and (not IsInRaid() or (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player"))) then
				container:Show()
			else
				container:Hide()
			end

		end

		events.register("GROUP_ROSTER_UPDATE", nil, setVisibility)
		events.register("PLAYER_ENTERING_WORLD", nil, setVisibility)

	end,

}

ns.tools = tools