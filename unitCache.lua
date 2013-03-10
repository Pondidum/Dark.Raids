local addon, ns = ...

local unitCache = {
	
	new = function()

		local raidUnits = {}
		local raidPets = {}

		local partyUnits = {}
		local partyPets = {}

		for i = 1, 40 do
			raidUnits[i] = string.format("raid%d", i)
			raidPets[i] = string.format("raidpet%d", i)
		end

		for i = 1, 5 do
			partyUnits[i] = string.format("raid%d", i)
			partyPets[i] = string.format("raidpet%d", i)
		end

		local this = {}

		this.raid = raidUnits
		this.raidPets = raidPets
		this.party = partyUnits
		this.partyPets = partyPets

		return this

	end,

}

ns.unitCache = unitCache