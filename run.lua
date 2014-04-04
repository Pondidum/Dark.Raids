local addon, ns = ...

local core = Dark.core
local events = core.events.new()

local onLogin = function()

	ns.threatUi.new()

	local interrupt = ns.interrupt.new()
	ns.interruptOptions.new(interrupt)

end


local run = function()

	events.register("PLAYER_LOGIN", onLogin)

	for name, feature in pairs(ns.features) do
		feature()
	end

end

run()
