local addon, ns = ...
local config = ns.config.cooldowns

local core = Dark.core
local events = core.events.new()

local cooldowns = {
	
	new = function() 

		local playerName = UnitName("player")
		local specConfig 

		local onSpecChanged = function()

			local _, class = UnitClass("player")
			local specID = GetSpecialization()

			if specID == nil then
				return
			end

			local playerSpecID, spec = GetSpecializationInfo(specID)

			if config[class] == nil or config[class][spec] == nil then
				return
			end

			specConfig = config[class][spec]

		end

		local onCombatLogUnfiltered = function(self, event, ...)
			
			if specConfig == nil then
				return
			end

			local timestamp, eventType, hideCaster, sourceGuid, sourceName, sourceFlags, sourceRaidFlags, destGuid, destName, destFlags, destRaidFlags, spellID, arg1, arg2, extraskillID = ...

			if sourceName ~= playerName then
				return
			end

			if eventType ~= "SPELL_CAST_SUCCESS" then
				return
			end

			local message = specConfig[spellID] 

			if message == nil then
				return
			end


			SendChatMessage(string.format(message, arg1), config.channel)	

		end

		local this = {}

		this.enable = function()
 
			onSpecChanged()
			
			events.register("ACTIVE_TALENT_GROUP_CHANGED", onSpecChanged)
			events.register("COMBAT_LOG_EVENT_UNFILTERED", onCombatLogUnfiltered)

		end

		this.disable = function()

			events.unregister("PLAYER_LOGIN")
			events.unregister("ACTIVE_TALENT_GROUP_CHANGED")

			events.unregister("COMBAT_LOG_EVENT_UNFILTERED")

		end
		
		if config.enabled then
			this.enable()
		end

		return this

	end,
}

ns.cooldowns = cooldowns
