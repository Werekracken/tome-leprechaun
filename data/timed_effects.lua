newEffect{
	name = "WK_LEPRECHAUN_LUCK", image = "talents/wk_leprechaun_luck.png",
	desc = _t"Leprechaun's Luck",
	long_desc = function(self, eff) return ("The target's luck and cunning combine to grant it %d%% higher critical chance and %d defense and defense against projectiles."):tformat(eff.crit, eff.def) end,
	type = "mental",
	subtype = { focus=true },
	status = "beneficial",
	parameters = { crit=10, save=10 },
	on_gain = function(self, err) return _t"#Target# seems more aware." end,
	on_lose = function(self, err) return _t"#Target#'s awareness returns to normal." end,
	getRangedDefence = function(self, t) return self:combatTalentScale(t, 5, 20) end,
	activate = function(self, eff)
		self:effectTemporaryValue(eff, "combat_generic_crit", eff.crit)
		--self:effectTemporaryValue(eff, "combat_physresist", eff.save)
		--self:effectTemporaryValue(eff, "combat_spellresist", eff.save)
		--self:effectTemporaryValue(eff, "combat_mentalresist", eff.save)
		self:talentTemporaryValue(eff, "combat_def", eff.def)
		self:talentTemporaryValue(eff, "combat_def_ranged", eff.def)
	end,
}

