local addon, ns = ...

local options = ns.lib.options

local inputOffset = 5
local groupSpacing = 20

local interruptOptions = {

	new = function(interruptController)

		options.register("Interrupt", {
			description = "An Interrupt announcer.",

			children = {
				{
					type = "label",
					name = "$parentEnabledLabel",
					points = {
						{ "TOPLEFT" , "$parent", "TOPLEFT", 10, -10 },
					},
					text = "Enabled",
				},
				{
					type = "checkbox",
					template = "OptionsCheckButtonTemplate",
					name = "$parentEnabled",
					points = {
						{ "TOP", "$parentEnabledLabel", "BOTTOM", 0, -5 },
						{ "LEFT", "$parentEnabledLabel", "LEFT", inputOffset, 0 },
					},
					actions = {
						save = function(self)
							if self:GetChecked() then
								interruptController.enable()
							else
								interruptController.disable()
							end
						end,
						load = function(self)
							self:SetChecked(interruptController.isEnabled())
						end,
					}
				},
				{
					type = "label",
					name = "$parentChannelLabel",
					points = {
						{ "TOP", "$parentEnabled", "BOTTOM", 0, -groupSpacing},
						{ "LEFT", "$parentEnabledLabel", "LEFT", 0, 0 },
					},
					text = "Announce to Channel:"
				},
				{
					type = "dropdown",
					name = "$parentChannel",
					points = {
						{ "TOP", "$parentChannelLabel", "BOTTOM", 0, -5 },
						{ "LEFT", "$parentEnabledLabel", "LEFT", inputOffset-20, 0 },
					},
					items = {
						PARTY = "Party",
						SAY = "Say",
						RAID = "Raid",
					},
					actions = {
						save = function(self)
							interruptController.setChannel(UIDropDownMenu_GetSelectedValue(self))
						end,
						load = function(self)
							UIDropDownMenu_SetSelectedValue(self, interruptController.getChannel())
							UIDropDownMenu_SetText(self, interruptController.getChannel())
						end,
					}
				},
				{
					type = "label",
					name = "$parentSuffixLabel",
					points = {
						{ "TOP", "$parentChannel", "BOTTOM", 0, -groupSpacing},
						{ "LEFT", "$parentEnabledLabel", "LEFT", 0, 0 },
					},
					text = "Suffix messages with:"
				},
				{
					type = "textbox",
					name = "$parentSuffix",
					points = {
						{ "TOP", "$parentSuffixLabel", "BOTTOM", 0, -5},
						{ "LEFT", "$parentEnabledLabel", "LEFT", inputOffset, 0 },
					},
					size = { 250, 20 },
					actions = {
						save = function(self)
							interruptController.setSuffix(self:GetText())
						end,
						load = function(self)
							self:SetText(interruptController.getSuffix())
						end,
					}
				},
				{
					type = "label",
					name = "$parentWhisperLabel",
					points = {
						{ "TOP", "$parentSuffix", "BOTTOM", 0, -groupSpacing},
						{ "LEFT", "$parentEnabledLabel", "LEFT", 0, 0 },
					},
					text = "Whisper a player on successful interrupt:"
				},
				{
					type = "textbox",
					name = "$parentWhisper",
					points = {
						{ "TOP", "$parentWhisperLabel", "BOTTOM", 0, -5},
						{ "LEFT", "$parentEnabledLabel", "LEFT", inputOffset, 0 },
					},
					size = { 150, 20 },
					actions = {
						save = function(self)
							interruptController.setNotify(self:GetText())
						end,
						load = function(self)
							self:SetText(interruptController.getNotify())
						end,
					}
				},
			},
		})


	end,

}

ns.interruptOptions = interruptOptions
