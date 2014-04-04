local addon, ns = ...

local run = function()

	for name, feature in pairs(ns.features) do

		if type(feature) == "function" then
			feature()
		end

	end

end

run()
