local addon, ns = ...

local class = ns.lib.class
local events = ns.lib.events
local style = ns.lib.style
local sounds = ns.lib.media.sounds

local config = ns.config.selfBuffs

local buffCheck = class:extend({

	events = {
		"PLAYER_LOGIN",
		"LEARNED_SPELL_IN_TAB",
		"UNIT_AURA",
		"PLAYER_REGEN_ENABLED",
		"PLAYER_REGEN_DISABLED",
		"UNIT_ENTERING_VEHICLE",
		"UNIT_ENTERED_VEHICLE",
		"UNIT_EXITING_VEHICLE",
		"UNIT_EXITED_VEHICLE"
	},

	ctor = function(self)
		self:include(events)

		self.buffs = {}
		self.sound = false

		self:createUI()
		self:spellsChanged()

		self.PLAYER_LOGIN = self.spellsChanged
		self.LEARNED_SPELL_IN_TAB = self.spellsChanged


		self.UNIT_AURA = self.checkBuffs
		self.PLAYER_REGEN_ENABLED = self.checkBuffs
		self.PLAYER_REGEN_DISABLED = self.checkBuffs
		self.UNIT_ENTERING_VEHICLE = self.checkBuffs
		self.UNIT_ENTERED_VEHICLE = self.checkBuffs
		self.UNIT_EXITING_VEHICLE = self.checkBuffs
		self.UNIT_EXITED_VEHICLE = self.checkBuffs

	end,

	createUI = function(self)

		local frame = CreateFrame("Frame", "DarkSelfBuff", UIParent)
		frame:SetSize(40, 40)
		frame:SetPoint("CENTER", UIParent, "CENTER", 0, 200)

		style:border(frame)

		local icon = frame:CreateTexture(nil, "OVERLAY")
		icon:SetAllPoints(frame)
		icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

		frame:Hide()

		self.frame = frame
		self.icon = icon

	end,

	spellsChanged = function(self)

		table.wipe(self.buffs)

		local localClass, class = UnitClass("player")

		for i, spellID in ipairs(config.buffs[class] or {}) do
			local name = GetSpellInfo(spellID)
			table.insert(self.buffs, name)
		end

		for i, buffName in ipairs(self.buffs) do

			local usable, noMana = IsUsableSpell(buffName)

			if usable or noMana then
				self.icon:SetTexture(GetSpellTexture(buffName))
				break
			end

		end

		self:checkBuffs()

	end,

	checkBuffs = function(self)

		local buffs = self.buffs

		if #buffs > 0 and UnitAffectingCombat("player") and not UnitInVehicle("player") then

			for i, name in ipairs(buffs) do

				if name and UnitBuff("player", name) then
					self.frame:Hide()
					self.sound = true
					return
				end

			end

			self.frame:Show()

			if self.sound then
				PlaySoundFile(sounds.warning)
				self.sound = false
			end

		else

			self.frame:Hide()
			self.sound = true
		end

	end,

})





--local events = lib.events.new()
local activateBuffs = function()
	return buffCheck:new()
end

ns.features.selfBuffs = activateBuffs
