local addon, ns = ...
local events = ns.lib.events.new()

local run = function()

	local threat = ns.features.threat

	events.register("PLAYER_LOGIN",  function()

		local cache = ns.unitCache.new()
		local model = threat.model.new(cache)
		local ui = threat.ui.new(model)

	end)

end

ns.features.runThreat = run
