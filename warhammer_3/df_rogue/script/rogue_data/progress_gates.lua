return {
	[1] = {
		["COMMENT"] = "The system begins new games by incrementing this flag to 1. It should be bound to the starting missions.",
		["ACTIVATION_THRESHOLD"] = "1",
		["PROGRESS_GATE_KEY"] = "NEW_GAME"
	},
	[2] = {
		["COMMENT"] = "Used as a placeholder for events which don't increment anything",
		["ACTIVATION_THRESHOLD"] = "9999",
		["PROGRESS_GATE_KEY"] = "NONE"
	},
	[3] = {
		["COMMENT"] = "Used as a placeholder for irrelevant progress gate fields.",
		["ACTIVATION_THRESHOLD"] = "9999",
		["PROGRESS_GATE_KEY"] = "NEVER"
	},
	[4] = {
		["COMMENT"] = "Introduction act: build your strength before attempting to take Doom Keep!",
		["ACTIVATION_THRESHOLD"] = "1",
		["PROGRESS_GATE_KEY"] = "INTRODUCTION"
	},
	[5] = {
		["COMMENT"] = "",
		["ACTIVATION_THRESHOLD"] = "1",
		["PROGRESS_GATE_KEY"] = "INTRO_WEST"
	},
	[6] = {
		["COMMENT"] = "",
		["ACTIVATION_THRESHOLD"] = "1",
		["PROGRESS_GATE_KEY"] = "INTRO_SOUTH"
	},
	[7] = {
		["COMMENT"] = "",
		["ACTIVATION_THRESHOLD"] = "1",
		["PROGRESS_GATE_KEY"] = "INTRO_SOUTH_MINIBOSS"
	},
	[8] = {
		["COMMENT"] = "",
		["ACTIVATION_THRESHOLD"] = "1",
		["PROGRESS_GATE_KEY"] = "INTRO_NORTH"
	},
	[9] = {
		["COMMENT"] = "",
		["ACTIVATION_THRESHOLD"] = "1",
		["PROGRESS_GATE_KEY"] = "INTRO_EAST"
	},
	[10] = {
		["COMMENT"] = "Limit the number of extra battles people can play in the intro",
		["ACTIVATION_THRESHOLD"] = "7",
		["PROGRESS_GATE_KEY"] = "INTRO_LIMIT"
	},
	[11] = {
		["COMMENT"] = "",
		["ACTIVATION_THRESHOLD"] = "1",
		["PROGRESS_GATE_KEY"] = "ACT_ONE"
	}
}