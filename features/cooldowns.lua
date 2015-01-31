local addon, ns = ...
local config = ns.config.cooldowns

local class = ns.lib.class
local events = ns.lib.events

local cooldowns = class:extend({

	ctor = function(self)
		self:include(events)

		if config.enabled then
			self:enable()
		end

	end,

	enable = function()

		self:ACTIVE_TALENT_GROUP_CHANGED()

		slef:register("ACTIVE_TALENT_GROUP_CHANGED")
		slef:register("COMBAT_LOG_EVENT_UNFILTERED")

	end,

	disable = function()

		self:unregister("ACTIVE_TALENT_GROUP_CHANGED")
		self:unregister("COMBAT_LOG_EVENT_UNFILTERED")

	end,

	ACTIVE_TALENT_GROUP_CHANGED = function(self)

		local _, class = UnitClass("player")
		local specID = GetSpecialization()

		if specID == nil then
			return
		end

		local playerSpecID, spec = GetSpecializationInfo(specID)

		if config[class] == nil or config[class][spec] == nil then
			return
		end

		self.specConfig = config[class][spec]

	end,

	COMBAT_LOG_EVENT_UNFILTERED = function(self, event, ...)

		if self.specConfig == nil then
			return
		end

		local timestamp, eventType, hideCaster, sourceGuid, sourceName, sourceFlags, sourceRaidFlags, destGuid, destName, destFlags, destRaidFlags, spellID, arg1, arg2, extraskillID = ...

		if sourceName ~= playerName then
			return
		end

		if eventType ~= "SPELL_CAST_SUCCESS" then
			return
		end

		local message = self.specConfig[spellID]

		if message == nil then
			return
		end


		SendChatMessage(string.format(message, arg1), config.channel)

	end

})

ns.features.cooldowns = function()
	cooldowns:new()
end
