local addon, ns = ...

local core = Dark.core
local eventStore = core.events.new()
local slash = core.slash

local interrupt = {
    
	new = function()

		local config = {
			enabled = true,
			channel = "say",
			suffix = "",
			notify = "",
		}

		local playerName = UnitName("player")

		local shouldAnnounce = {
			say = function() 
				return true 
			end,

			party = function() 
				return UnitInParty("player") and GetNumPartyMembers() > 0 
			end,

			raid = function() 
				return UnitInRaid("player") 
			end,
		}

		local messages = {
			
			SPELL_INTERRUPT = function(targetSpellID, sourceSpellID)
				return "Interrupted " .. GetSpellLink(targetSpellID) .. "."
			end,

			SPELL_STOLEN = function(targetSpellID, sourceSpellID)
				return "Spellstole " .. GetSpellLink(targetSpellID) .. "."
			end
		}

		local onCombatLogUnfiltered = function(self, event, ...)

			local timestamp, eventType, hideCaster, sourceGuid, sourceName, sourceFlags, sourceRaidFlags, destGuid, destName, destFlags, destRaidFlags, spellID, arg1, arg2, extraskillID = ...

			if sourceName ~= playerName then
				return
			end

			if messages[eventType] == nil then
				return
			end

			if shouldAnnounce[config.channel] == nil then
				return 
			end

			local message = messages[eventType](extraskillID, spellID) .. " " .. config.suffix

			SendChatMessage(message, config.channel)

			if config.notify ~= nil and config.notify ~= "" then
				SendChatMessage(message, "WHISPER", nil, config.notify)				
			end


		end


		local this = {}


		this.enable = function()
			eventStore.register("COMBAT_LOG_EVENT_UNFILTERED", onCombatLogUnfiltered)
		end

		this.disable = function()
			eventStore.unregister("COMBAT_LOG_EVENT_UNFILTERED")
		end

		this.setChannel = function(value)
			config.channel = string.lower(value)
		end

		this.setSuffix = function(value)
			config.suffix = value 
		end

		this.setNotify = function(value)
			config.notify = value
		end

		--[[

			/dark interrupt enable
			/dark interrupt disable
			/dark interrupt channel party
			/dark interrupt suffix "wrinkle next"
			/dark interrupt whisper wrinkle

		]]--
		local slashHandler = {

			enable = function()
				this.enable()
				print("Interrupt Announce: Enabled.")
			end,

			disable = function()
				this.disable()
				print("Interrupt Announce: Disabled.")
			end,

			channel = function(value)
				this.setChannel(value)
				print(string.format("Interrupt Announce: Annoncing to %s.", value))
			end,

			suffix = function(value)
				this.setSuffix(value)
				print(string.format("Interrupt Announce: Appending messages with '%s'.", value))
			end,

			whisper = function(value)
				this.setNotify(value)
				print(string.format("Interrupt Announce: Whispering %s on interrupt.", value))
			end,
		}


		slash.register("interrupt", slashHandler)

		if config.enabled then
			this.enable()
		end

		return this

	end

}

interrupt.new()