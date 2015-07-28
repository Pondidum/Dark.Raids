local addon, ns = ...
local config = ns.config.interrupt
local options = ns.lib.options

local UnitInParty = UnitInParty
local UnitInRaid = UnitInRaid
local GetNumPartyMembers = GetNumPartyMembers
local SendChatMessage = SendChatMessage

local class = ns.lib.class
local events = ns.lib.events

local interrupt = class:extend({

	ctor = function(self)
		self:include(events)
		self:register("COMBAT_LOG_EVENT_UNFILTERED")

		self.playerName = UnitName("player")
		self:registerOptions()
	end,

	registerOptions = function(self)

		options:addPanel("Interrupt", function(control)

			return {
				control:input(config, "enabled", "boolean"),
				control:input(config, "channel", "text"),
				control:input(config, "suffix", "text"),
				control:input(config, "notify", "text")
		    }

		end)

	end,

	shouldAnnounce = {
		SAY = function()
			return true
		end,

		PARTY = function()
			return UnitInParty("player") and GetNumPartyMembers() > 0
		end,

		RAID = function()
			return UnitInRaid("player")
		end,
	},

	messages = {

		SPELL_INTERRUPT = function(targetSpellID, sourceSpellID)
			return "Interrupted " .. GetSpellLink(targetSpellID) .. "."
		end,

		SPELL_STOLEN = function(targetSpellID, sourceSpellID)
			return "Spellstole " .. GetSpellLink(targetSpellID) .. "."
		end
	},

	COMBAT_LOG_EVENT_UNFILTERED = function(self, ...)

		local timestamp, eventType, hideCaster, sourceGuid, sourceName, sourceFlags, sourceRaidFlags, destGuid, destName, destFlags, destRaidFlags, spellID, arg1, arg2, extraskillID = ...

		if sourceName ~= self.playerName then
			return
		end

		if self.messages[eventType] == nil then
			return
		end

		if self.shouldAnnounce[config.channel] == nil then
			return
		end

		local message = self.messages[eventType](extraskillID, spellID) .. " " .. config.suffix

		SendChatMessage(message, config.channel)

		if config.notify ~= nil and config.notify ~= "" then
			SendChatMessage(message, "WHISPER", nil, config.notify)
		end

	end,

})

ns.features.runInterrupt = function()
	interrupt:new()
end
