local addon, ns = ...

local class = ns.lib.class
local events = ns.lib.events

local threatMeter = class:extend({

	events = {
		"GROUP_ROSTER_UPDATE",
		"UNIT_THREAT_LIST_UPDATE",
		"PLAYER_REGEN_ENABLED",
		"PLAYER_REGEN_DISABLED",
	},

	ctor = function(self, unitCache)
		self:include(events)

		self.units = unitCache
		self.inParty = false
		self.inRaid = false

		self.threatUnitIDFindList = {"target", "targettarget"}
		self.threatTable = {}
		self.threatSort = function(a, b)
			return threatTable[a] > threatTable[b]
		end
	end,

	GROUP_ROSTER_UPDATE = function(self)
		self.inParty = IsInGroup()
		self.inRaid = IsInRaid()
	end,

	PLAYER_REGEN_DISABLED = function(self)
		self.onThreatUpdate({})
	end,

	PLAYER_REGEN_ENABLED = function(self)
		self.onThreatUpdate({})
	end,

	UNIT_THREAT_LIST_UPDATE = function(self)

		local mob = findThreatMob()

		if mob == nil then
			return
		end

		local mobGuid = UnitGUID(mob)

		self.threatTable = {}
		self.threatTable[mobGuid] = -1

		self:gatherThreatData(mob)

		local sortTable = getSortTable()

		local result = {}

		for i, guid in ipairs(sortTable) do
			result[i] = {rank = i, name = self.units.names[guid], value = self.threatTable[guid]}
		end

		this.onThreatUpdate(result)

	end,

	findThreatMob = function(self)

		for i, mob in ipairs(self.threatUnitIDFindList) do

			if UnitExists(mob) and not UnitIsPlayer(mob) and UnitCanAttack("player", mob) and UnitHealth(mob) > 0 then
				return mob
			end

		end

	end,

	gatherThreatData = function(self, mob)

		if self.inParty or self.inRaid then
			if self.inRaid then
				for i = 1, GetNumGroupMembers() do
					self:updateThreat(units.raid[i], mob)
					self:updateThreat(units.raidPets[i], mob)
				end
			else
				for i = 1, GetNumSubgroupMembers() do
					self:updateThreat(units.party[i], mob)
					self:updateThreat(units.partyPets[i], mob)
				end
			end

		end

		if not self.inRaid then
			self:updateThreat("player", mob)
			self:updateThreat("pet", mob)
			self:updateThreat("target", mob)
			self:updateThreat("pettarget", mob)
		end

		self:updateThreat("target", mob)
		self:updateThreat("targettarget", mob)
		self:updateThreat("focus", mob)
		self:updateThreat("focustarget", mob)
		self:updateThreat(mob.."target", mob)
		self:updateThreat("mouseover", mob)
		self:updateThreat("mouseovertarget", mob)

	end,

	updateThreat = function(self, unitID, mobUnitID)

		local unitGuid = UnitGUID(unitID)

		if unitGuid == nil or self.threatTable[unitGuid] then
			return
		end

		units.names[unitGuid] = UnitName(unitID)

		local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation(unitID, mobUnitID)
		local useValue = scaledPercent

		--print(UnitName(unitID), useValue, threatValue)
		if useValue then
			self.threatTable[unitGuid] = useValue
		else
			self.threatTable[unitGuid] = -1
		end

	end,

	getSortTable = function(self)

		local sortTable = {}
		local i = 1

		for guid, value in pairs(self.threatTable) do

			if value ~= -1 then
				sortTable[i] = guid
				i = i + 1
			end

		end

		table.sort(sortTable, self.threatSort)

		return sortTable

	end

})

ns.features.threat.model = threatMeter
