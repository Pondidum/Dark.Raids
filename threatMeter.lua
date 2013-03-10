local addon, ns = ...
local events = Dark.core.events

local threatMeter = {
	
	new = function(onThreatUpdate)

		local units = ns.unitCache.new()
		local inParty, inRaid = false, false

		local onGroupRosterUpdate = function()
			inParty = IsInGroup()
			inRaid = IsInRaid()
		end
		events.register("GROUP_ROSTER_UPDATE", nil, onGroupRosterUpdate)


		local newTable = function()
			return {}	--maybe use weak table?
		end

		local threatSort = function(a, b) return threatTable[a] > threatTable[b] end

		local threatUnitIDFindList = {"target", "targettarget"}
		local findThreatMob = function()
			
			for i, mob in ipairs(threatUnitIDFindList) do

				if UnitExists(mob) and not UnitIsPlayer(mob) and UnitCanAttack("player", mob) and UnitHealth(mob) > 0 then
					return mob
				end

			end

		end

		local threatTable, sortTable
		local topThreat =0
		local tankGuid

		local updateThreat = function(unitID, mobUnitID)

			local unitGuid = UnitGUID(unitID)

			if unitGuid == nil or threatTable[unitGuid] then
				return
			end

			local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation(unitID, mobUnitID)

			if threatValue then
				
				if threatValue > topThreat then
					topThreat = threatValue
				end

				if isTanking then
					tankGuid = unitGuid
				end

				threatTable[unitGuid] = threatValue
			else
				threatTable[unitGuid] = -1
			end

		end

		local gatherThreatData = function(mob)

			if inParty or inRaid then
				if inRaid then
					for i = 1, GetNumGroupMembers() do
						updateThreat(units.raid[i], mob)
						updateThreat(units.raidPets[i], mob)
						--updateThreat(rtID[i], mob)
						--updateThreat(rptID[i], mob)
					end
				else
					for i = 1, GetNumSubgroupMembers() do
						updateThreat(units.party, mob)
						updateThreat(units.partyPets, mob)
						--updateThreat(ptID[i], mob)
						--updateThreat(pptID[i], mob)
					end
				end

			end

			if not inRaid then
				updateThreat("player", mob)
				updateThreat("pet", mob)
				updateThreat("target", mob)
				updateThreat("pettarget", mob)
			end

			updateThreat("target", mob)
			updateThreat("targettarget", mob)
			updateThreat("focus", mob)
			updateThreat("focustarget", mob)
			updateThreat(mob.."target", mob)
			updateThreat("mouseover", mob)
			updateThreat("mouseovertarget", mob)

		end

		local getSortTable = function()

			local sortTable = {}
			local i = 1

			for guid, value in pairs(threatTable) do

				if value ~= -1 then
					sortTable[i] = guid
				end

			end

			table.sort(sortTable, threatSort)

			return sortTable

		end

		local onThreatListUpdated = function()

			local mob = findThreatMob()

			if mob == nil then
				return
			end

			local mobGuid = UnitGUID(mob)

			threatTable = newTable()
			threatTable[mobGuid] = -1

			gatherThreatData(mob)
			
			local sortTable = getSortTable()
			local iterator = function()
				
				local t = threatTable
				
				local j = 0
				return function()
					j = j + 1
					local name = sortTable[j]
					if name then
						return j, name, t[name]
					end
				end

			end

			onThreatUpdate(iterator)

		end

		events.register("UNIT_THREAT_LIST_UPDATE", nil, onThreatListUpdated)
	end,

}

ns.threatMeter = threatMeter