local addon, ns = ...

local lib = Dark.core

local events = lib.events.new()
local style = lib.style
local sounds = lib.sounds

local config = ns.config.selfBuffs

local buffChecker = {

	new = function()

		local frame = CreateFrame("Frame", "DarkSelfBuff", UIParent)
		frame:SetSize(40, 40)
		frame:SetPoint("CENTER", UIParent, "CENTER", 0, 200)

		style.addShadow(frame)

		local icon = frame:CreateTexture(nil, "OVERLAY")
		icon:SetAllPoints(frame)
		icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

		frame:Hide()

		local buffs = {}
		local sound = false

		local checkBuffs = function()

			if #buffs > 0 and UnitAffectingCombat("player") and not UnitInVehicle("player") then

				for i, name in ipairs(buffs) do

					if name and UnitBuff("player", name) then
						frame:Hide()
						sound = true
						return
					end

				end

				frame:Show()

				if sound then
					PlaySoundFile(sounds.warning)
					sound = false
				end

			else

				frame:Hide()
				sound = true
			end

		end

		local spellsChanged = function()

			local localClass, class = UnitClass("player")
			buffs = {}

			for i, spellID in ipairs(config.buffs[class] or {}) do
				local name = GetSpellInfo(spellID)
				table.insert(buffs, name)
			end

			for i, buffName in ipairs(buffs) do

				local usable, noMana = IsUsableSpell(buffName)

				if usable or noMana then
					icon:SetTexture(GetSpellTexture(buffName))
					break
				end

			end

			checkBuffs()

		end

		spellsChanged()

		events.register("PLAYER_LOGIN", spellsChanged)
		events.register("LEARNED_SPELL_IN_TAB", spellsChanged)

		events.register("UNIT_AURA", checkBuffs)
		events.register("PLAYER_REGEN_ENABLED", checkBuffs)
		events.register("PLAYER_REGEN_DISABLED", checkBuffs)
		events.register("UNIT_ENTERING_VEHICLE", checkBuffs)
		events.register("UNIT_ENTERED_VEHICLE", checkBuffs)
		events.register("UNIT_EXITING_VEHICLE", checkBuffs)
		events.register("UNIT_EXITED_VEHICLE", checkBuffs)

	end,
}

local activateBuffs = function()

	events.register("PLAYER_LOGIN", function()

 		buffChecker.new()
		events.unregister("PLAYER_LOGIN")

	end)

end

ns.features.selfBuffs = activateBuffs
