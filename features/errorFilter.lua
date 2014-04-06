local addon, ns = ...

local config = ns.config.errorFilter
local events = ns.lib.events.new()

local filter = {

	new =  function()

		local checkBlacklist = function(message)
			return config.blacklist[message]
		end

		local checkWhitelist = function(message)
			return not config.whitelist[message]
		end

		local check

		local onUIErrorMessage = function(self, event, message)

			if check(message) then
				UIErrorsFrame:AddMessage(message, 1.0, 0.1, 0.1, 1.0)
			end

		end

		local this = {

			setMode = function(mode)

				if mode == "blacklist" then
					check = checkBlacklist
				else
					check = checkWhitelist
				end

			end,

			enable = function()
				UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
				events.register("UI_ERROR_MESSAGE", onUIErrorMessage)
			end,

			disable = function()
				UIErrorsFrame:RegisterEvent('UI_ERROR_MESSAGE')
				events.unregister("UI_ERROR_MESSAGE")
			end,

		}

		return this

	end

}

local runFilter = function()

	local controller = filter.new()
	controller.setMode(config.mode)
	controller.enable()

end

ns.features.errorFilter = runFilter
