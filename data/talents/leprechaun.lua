newTalentType{ type="race/leprechaun", name = _t("leprechaun", "talent type"), generic = true, description = _t"The various racial bonuses a character can have." }

racial_req1 = {
	level = function(level) return 0 + (level-1)  end,
}
racial_req2 = {
	level = function(level) return 8 + (level-1)  end,
}
racial_req3 = {
	level = function(level) return 16 + (level-1)  end,
}
racial_req4 = {
	level = function(level) return 24 + (level-1)  end,
}

newTalent{
	name = "Luck of the Leprechaun", short_name = "WK_LEPRECHAUN_LUCK",
	type = {"race/leprechaun", 1},
    image = "talents/wk_leprechaun_luck.png",
	require = racial_req1,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 5, 45, 25, false, 1.0)) end, -- Limit >5
	getParams = function(self, t)
		return {
			def = self:combatStatScale("cun", 15, 60, 0.75),
			--save = self:combatStatScale("cun", 15, 60, 0.75),
			crit = self:combatTalentScale(t, 5, 20),
			}
	end,
	tactical = { ATTACK = 2 },
	action = function(self, t)
		self:setEffect(self.EFF_WK_LEPRECHAUN_LUCK, 5, t.getParams(self, t))
		return true
	end,
	info = function(self, t)
		local params = t.getParams(self, t)
		return ([[Call upon the luck and cunning of leprechauns to increase your critical strike chance by %d%%, and your defense and defense against projectiles by %d for 5 turns.
		The defense bonus will increase with your Cunning.]]):
		tformat(params.crit, params.def)
	end,
}

newTalent{
	name = "Pot o' Gold", short_name = "WK_LEPRECHAUN_GOLD",
	type = {"race/leprechaun", 2},
    image = "talents/wk_leprechaun_gold.png",
	require = racial_req2,
	points = 5,
	mode = "passive",
	getMaxSaves = function(self, t) return self:combatTalentScale(t, 8, 50) end,
	getGold = function(self, t) return self:combatTalentLimit(t, 40, 85, 60, false, 1.0) end, -- Limit > 40
	-- called by _M:combatPhysicalResist, _M:combatSpellResist, _M:combatMentalResist in mod.class.interface.Combat.lua
	getSaves = function(self, t)
		return util.bound(self.money / t.getGold(self, t), 0, t.getMaxSaves(self, t))
	end,
	info = function(self, t)
		return ([[Leprechauns are famous for their hoarding of gold.
		Increases Physical, Mental and Spell Saves based on the amount of gold you possess.
		+1 save every %d gold, up to +%d. (currently +%d)]]):
		tformat(t.getGold(self, t), t.getMaxSaves(self, t), t.getSaves(self, t))
	end,
}

newTalent{
	name = "Lucky by Design", short_name = "WK_LEPRECHAUN_DESIGN",
	type = {"race/leprechaun", 3},
    image = "talents/wk_leprechaun_design.png",
	require = racial_req3,
	points = 5,
	mode = "passive",
	no_unlearn_last = true,
	getMult = function(self, t) return self:combatTalentScale(t, 15, 30) / 100 end,
	getImmune = function(self, t) return self:combatTalentLimit(t, 1, 0.2, 0.55, false, 1.0) end, -- Limit < 100%
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "confusion_immune", t.getImmune(self, t))
		self:talentTemporaryValue(p, "inscriptions_stat_multiplier", t.getMult(self, t))
	end,
    on_learn = function(self, t)
		if self:getTalentLevelRaw(t) == 5 then self.max_inscriptions = self.max_inscriptions + 1 end
	end,
	on_unlearn = function(self, t)
		if self:getTalentLevelRaw(t) == 4 then self.max_inscriptions = self.max_inscriptions - 1 end
	end,
	info = function(self, t)
		return ([[A leprechaun is sharp and cunning.
		Increases confusion resistance by %d%% and improves the contribution of primary stats on infusions and runes by %d%%.
		At level 5 you are instantly granted a new inscription slot without needing to spend a category point.]]):
		tformat(100*t.getImmune(self, t), t.getMult(self, t) * 100)
	end,
}

newTalent{
	name = "Too Clever by Half", short_name = "WK_LEPRECHAUN_CLEVER",
	type = {"race/leprechaun", 4},
    image = "talents/wk_leprechaun_clever.png",
	require = racial_req4,
	points = 5,
	no_energy = true,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 10, 45, 25, false, 1.0)) end, -- Limit to >10
	remcount  = function(self,t) return math.ceil(self:combatTalentScale(t, 0.5, 3, "log", 0, 3)) end,
	heal = function(self, t) return 50+self:combatTalentStatDamage(t, "cun", 50, 250) end,
	tactical = { HEAL = 1, CURE = function(self, t, target)
		local nb = 0
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.status == "detrimental" and (e.type == "physical" or e.type == "magical" or e.type == "mental") then
				nb = nb + 1
			end
		end
		return nb^0.5
	end },
	action = function(self, t)
		local target = self
		local effs = {}

		-- Go through all temporary effects
		for eff_id, p in pairs(target.tmp) do
			local e = target.tempeffect_def[eff_id]
			if e.status == "detrimental" and (e.type == "physical" or e.type == "magical" or e.type == "mental") then
				effs[#effs+1] = {"effect", eff_id}
			end
		end

		for i = 1, t.remcount(self,t) do
			if #effs == 0 then break end
			local eff = rng.tableRemove(effs)

			if eff[1] == "effect" then
				target:removeEffect(eff[2])
			end
		end

		if not self:attr("no_healing") and ((self.healing_factor or 1) > 0) then
			self:attr("allow_on_heal", 1)
			self:heal(t.heal(self, t), t)
			if core.shader.active(4) then
				self:addParticles(Particles.new("shader_shield_temp", 1, {toback=true , size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0}))
				self:addParticles(Particles.new("shader_shield_temp", 1, {toback=false, size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0}))
			end
			self:attr("allow_on_heal", -1)
		end
		return true
	end,
	info = function(self, t)
		return ([[Leprechauns are very clever and are known to surprise those who think they've caught one.
		You remove up to %d detrimental effect(s) then heal for %d life.
		The healing will increase with talent level and your Cunning.]]):
		tformat(t.remcount(self,t), t.heal(self, t))
	end,
}