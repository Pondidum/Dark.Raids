local addon, ns = ...

local core = Dark.core
local events = core.events.new()

local onLogin = function()

	local interrupt = ns.interrupt.new()
	ns.interruptOptions.new(interrupt)

end

local run = function()

	events.register("PLAYER_LOGIN", onLogin)

	for name, feature in pairs(ns.features) do

		if type(feature) == "function" then
			feature()
		end

	end

end

run()
