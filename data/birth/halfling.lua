getBirthDescriptor("race", "Halfling").descriptor_choices.subrace["Leprechaun"] = "allow"

newBirthDescriptor {
    type = "subrace",
    name = "Leprechaun",
    desc = {
		_t"Leprechauns are especially lucky and cunning magical halflings.",
		_t"They possess the #GOLD#Luck of the Little Folk#WHITE# which allows them to increase their critical strike chance and saves for a few turns.",
		_t"#GOLD#Stat modifiers:",
		_t"#LIGHT_BLUE# * -3 Strength, +0 Dexterity, +1 Constitution",
		_t"#LIGHT_BLUE# * +3 Magic, +0 Willpower, +3 Cunning",
		_t"#LIGHT_BLUE# * +10 Luck",
		_t"#GOLD#Life per level:#LIGHT_BLUE# 12",
    },
    inc_stats = { str=-3, mag=3, con=1, cun=3, lck=10, },
	talents_types = {
        ["race/leprechaun"]={true, 0}
    },
	talents = {
		['T_WK_LEPRECHAUN_LUCK'] = 1,
	},
	default_cosmetics = { {"hairs", _t"Dark Hair 4"} },
	copy = {
		moddable_tile = "halfling_#sex#",
		random_name_def = "halfling_#sex#",
		life_rating = 12,
	},
}
