local addon, ns = ...

local config = ns.config.errorFilter

local class = ns.lib.class
local events = ns.lib.events

local filter = class:extend({

	ctor = function(self, mode)
		self:include(events)

		self.check = self[string.lower(mode)]
	end,

	enable = function(self)
		UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
		self:register("UI_ERROR_MESSAGE")
	end,

	disable = function(self)
		UIErrorsFrame:RegisterEvent('UI_ERROR_MESSAGE')
		self:unregister("UI_ERROR_MESSAGE")
	end,

	UI_ERROR_MESSAGE = function(self, eventName, message)

		if self:check(message) then
			UIErrorsFrame:AddMessage(message, 1.0, 0.1, 0.1, 1.0)
		end

	end,

	blacklist = function(message)
		return config.blacklist[message]
	end,

	whitelist = function(message)
		return not config.whitelist[message]
	end,


})

local runFilter = function()

	local controller = filter:new(config.mode)
	controller:enable()

end

ns.features.errorFilter = runFilter
