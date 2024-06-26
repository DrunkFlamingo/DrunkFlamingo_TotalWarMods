return {
	[1] = {
		["COMMENT"] = "The system begins new games by incrementing this flag to 1. It should be bound to the starting missions.",
		["ACTIVATION_THRESHOLD"] = "1",
		["PROGRESS_GATE_KEY"] = "NEW_GAME_DANIEL"
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
		["COMMENT"] = "Introduction act: Guaranteed to generate after starting battle.",
		["ACTIVATION_THRESHOLD"] = "1",
		["PROGRESS_GATE_KEY"] = "INTRODUCTION"
	},
	[5] = {
		["COMMENT"] = "Intro act random paths",
		["ACTIVATION_THRESHOLD"] = "1",
		["PROGRESS_GATE_KEY"] = "INTRO_WEST"
	},
	[6] = {
		["COMMENT"] = "Intro act random paths",
		["ACTIVATION_THRESHOLD"] = "1",
		["PROGRESS_GATE_KEY"] = "INTRO_SOUTH"
	},
	[7] = {
		["COMMENT"] = "Intro act random paths",
		["ACTIVATION_THRESHOLD"] = "1",
		["PROGRESS_GATE_KEY"] = "INTRO_NORTH"
	},
	[8] = {
		["COMMENT"] = "Intro act random paths",
		["ACTIVATION_THRESHOLD"] = "1",
		["PROGRESS_GATE_KEY"] = "INTRO_EAST"
	},
	[9] = {
		["COMMENT"] = "",
		["ACTIVATION_THRESHOLD"] = "1",
		["PROGRESS_GATE_KEY"] = "INTRO_EAST_S1"
	},
	[10] = {
		["COMMENT"] = "",
		["ACTIVATION_THRESHOLD"] = "1",
		["PROGRESS_GATE_KEY"] = "INTRO_WEST_S1"
	}
}