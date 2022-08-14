return {
		["progress_gates"] = {
			["NONE"] = {
				["activation_threshold"] = 9999,
				["generates_encounters"] = {

				},
				["displaces_encounters"] = {

				},
				["forces_encounters"] = {

				}
			},
			["INTRO_NORTH"] = {
				["activation_threshold"] = 1,
				["generates_encounters"] = {

				},
				["displaces_encounters"] = {

				},
				["forces_encounters"] = {

				}
			},
			["INTRODUCTION"] = {
				["activation_threshold"] = 1,
				["generates_encounters"] = {

				},
				["displaces_encounters"] = {

				},
				["forces_encounters"] = {

				}
			},
			["INTRO_WEST"] = {
				["activation_threshold"] = 1,
				["generates_encounters"] = {

				},
				["displaces_encounters"] = {

				},
				["forces_encounters"] = {

				}
			},
			["INTRO_WEST_S1"] = {
				["activation_threshold"] = 1,
				["generates_encounters"] = {

				},
				["displaces_encounters"] = {

				},
				["forces_encounters"] = {

				}
			},
			["INTRO_EAST_S1"] = {
				["activation_threshold"] = 1,
				["generates_encounters"] = {

				},
				["displaces_encounters"] = {

				},
				["forces_encounters"] = {

				}
			},
			["NEW_GAME_DANIEL"] = {
				["activation_threshold"] = 1,
				["generates_encounters"] = {
					[1] = {
						["progress_payload"] = "START_BATTLE_COMPLETE",
						["region"] = "settlement:wh3_main_chaos_region_doomkeep",
						["duration"] = 0,
						["boss_overlay"] = false,
						["reward_set"] = "daniel_intro_battle_rewards",
						["key"] = "starting_battle",
						["inciting_incident_key"] = "",
						["battle_type"] = "LAND_ATTACK",
						["post_battle_dilemma_override"] = "",
						["force_set"] = {
							[1] = "starting_battle_kho",
							[2] = "starting_battle_nur",
							[3] = "starting_battle_sla",
							[4] = "starting_battle_tze"
						}
					}
				},
				["displaces_encounters"] = {

				},
				["forces_encounters"] = {

				}
			},
			["INTRO_EAST"] = {
				["activation_threshold"] = 1,
				["generates_encounters"] = {

				},
				["displaces_encounters"] = {

				},
				["forces_encounters"] = {

				}
			},
			["NEVER"] = {
				["activation_threshold"] = 9999,
				["generates_encounters"] = {

				},
				["displaces_encounters"] = {

				},
				["forces_encounters"] = {

				}
			},
			["INTRO_SOUTH"] = {
				["activation_threshold"] = 1,
				["generates_encounters"] = {

				},
				["displaces_encounters"] = {

				},
				["forces_encounters"] = {

				}
			}
		},
		["force_fragments"] = {
			["kho_bloodcrusher_1"] = {
				["difficulty_delta"] = 6,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_bloodcrusher_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_kho_cav_bloodcrushers_0"
					}
				}
			},
			["nurglings_4"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nurglings_4",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_nur_inf_nurglings_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_nur_inf_nurglings_0"
					},
					[3] = {
						["unit_key"] = "wh3_main_nur_inf_nurglings_0"
					},
					[4] = {
						["unit_key"] = "wh3_main_nur_inf_nurglings_0"
					}
				}
			},
			["kho_cultist_easy"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_cultist_easy",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_kho_cha_cultist_0"
					}
				}
			},
			["sla_forsaken_3"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_forsaken_3",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_dlc20_chs_inf_forsaken_msla"
					},
					[2] = {
						["unit_key"] = "wh3_dlc20_chs_inf_forsaken_msla"
					},
					[3] = {
						["unit_key"] = "wh3_dlc20_chs_inf_forsaken_msla"
					}
				}
			},
			["tze_spawn_1"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "tze_spawn_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_tze_mon_spawn_of_tzeentch_0"
					}
				}
			},
			["chs_chariot_2"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "chs_chariot_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh_main_chs_cav_chaos_chariot"
					},
					[2] = {
						["unit_key"] = "wh_main_chs_cav_chaos_chariot"
					}
				}
			},
			["sla_furies_2"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_furies_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_sla_inf_chaos_furies_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_sla_inf_chaos_furies_0"
					}
				}
			},
			["sla_ex_daemonette_2"] = {
				["difficulty_delta"] = 8,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_ex_daemonette_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_sla_inf_daemonette_1"
					},
					[2] = {
						["unit_key"] = "wh3_main_sla_inf_daemonette_1"
					}
				}
			},
			["sla_hellstriders_3"] = {
				["difficulty_delta"] = 6,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_main_sla_cav_hellstriders_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_sla_cav_hellstriders_1"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_main_sla_cav_hellstriders_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_sla_cav_hellstriders_1"
						}
					},
					[3] = {
						[1] = {
							["unit_key"] = "wh3_main_sla_cav_hellstriders_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_sla_cav_hellstriders_1"
						}
					}
				},
				["force_fragment_key"] = "sla_hellstriders_3",
				["mandatory_units"] = {

				}
			},
			["tze_spawn_3"] = {
				["difficulty_delta"] = 6,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "tze_spawn_3",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_tze_mon_spawn_of_tzeentch_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_tze_mon_spawn_of_tzeentch_0"
					},
					[3] = {
						["unit_key"] = "wh3_main_tze_mon_spawn_of_tzeentch_0"
					}
				}
			},
			["kho_spawn_1"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_spawn_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_kho_mon_spawn_of_khorne_0"
					}
				}
			},
			["chs_spawn_1"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "chs_spawn_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh_main_chs_mon_chaos_spawn"
					}
				}
			},
			["tze_marauder_horse_2"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "tze_marauder_horse_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_dlc20_chs_cav_marauder_horsemen_mtze_javelins"
					},
					[2] = {
						["unit_key"] = "wh3_dlc20_chs_cav_marauder_horsemen_mtze_javelins"
					}
				}
			},
			["nur_marauders_4"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mnur"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mnur_greatweapons"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mnur"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mnur_greatweapons"
						}
					},
					[3] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mnur"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mnur_greatweapons"
						}
					},
					[4] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mnur"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mnur_greatweapons"
						}
					}
				},
				["force_fragment_key"] = "nur_marauders_4",
				["mandatory_units"] = {

				}
			},
			["chs_forsaken_2"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "chs_forsaken_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh_dlc01_chs_inf_forsaken_0"
					},
					[2] = {
						["unit_key"] = "wh_dlc01_chs_inf_forsaken_0"
					}
				}
			},
			["nur_chosen_1"] = {
				["difficulty_delta"] = 5,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mnur"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mnur_greatweapons"
						}
					}
				},
				["force_fragment_key"] = "nur_chosen_1",
				["mandatory_units"] = {

				}
			},
			["tze_warriors_4"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mtze"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mtze_halberds"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mtze"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mtze_halberds"
						}
					},
					[3] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mtze"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mtze_halberds"
						}
					},
					[4] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mtze"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mtze_halberds"
						}
					}
				},
				["force_fragment_key"] = "tze_warriors_4",
				["mandatory_units"] = {

				}
			},
			["tze_cultist_easy"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "tze_cultist_easy",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_tze_cha_cultist_0"
					}
				}
			},
			["chs_knights_1"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh_main_chs_cav_chaos_knights_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_cav_chaos_knights_1"
						}
					}
				},
				["force_fragment_key"] = "chs_knights_1",
				["mandatory_units"] = {

				}
			},
			["sla_warriors_4"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_msla"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_msla"
						},
						[3] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_msla"
						},
						[4] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_msla"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_msla_hellscourges"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_msla_hellscourges"
						},
						[3] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_msla_hellscourges"
						},
						[4] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_msla_hellscourges"
						}
					}
				},
				["force_fragment_key"] = "sla_warriors_4",
				["mandatory_units"] = {

				}
			},
			["sla_seekers_2"] = {
				["difficulty_delta"] = 12,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_seekers_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_sla_cav_seekers_of_slaanesh_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_sla_cav_seekers_of_slaanesh_0"
					}
				}
			},
			["chs_exalted_hero_easy"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "chs_exalted_hero_easy",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh_main_chs_cha_exalted_hero_0"
					}
				}
			},
			["nur_knights_2"] = {
				["difficulty_delta"] = 8,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_cav_chaos_knights_mnur"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_cav_chaos_knights_mnur_lances"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_cav_chaos_knights_mnur"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_cav_chaos_knights_mnur_lances"
						}
					}
				},
				["force_fragment_key"] = "nur_knights_2",
				["mandatory_units"] = {

				}
			},
			["nur_drones_2"] = {
				["difficulty_delta"] = 12,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_main_nur_cav_plague_drones_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_nur_cav_plague_drones_1"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_main_nur_cav_plague_drones_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_nur_cav_plague_drones_1"
						}
					}
				},
				["force_fragment_key"] = "nur_drones_2",
				["mandatory_units"] = {

				}
			},
			["kho_forsaken_3"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_forsaken_3",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_dlc20_chs_inf_forsaken_mkho"
					},
					[2] = {
						["unit_key"] = "wh3_dlc20_chs_inf_forsaken_mkho"
					},
					[3] = {
						["unit_key"] = "wh3_dlc20_chs_inf_forsaken_mkho"
					}
				}
			},
			["chs_warshrine"] = {
				["difficulty_delta"] = 6,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "chs_warshrine",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_dlc20_chs_mon_warshrine"
					}
				}
			},
			["chs_spawn_3"] = {
				["difficulty_delta"] = 6,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "chs_spawn_3",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh_main_chs_mon_chaos_spawn"
					},
					[2] = {
						["unit_key"] = "wh_main_chs_mon_chaos_spawn"
					},
					[3] = {
						["unit_key"] = "wh_main_chs_mon_chaos_spawn"
					}
				}
			},
			["tze_cultist_hard"] = {
				["difficulty_delta"] = 7,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "tze_cultist_hard",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_tze_cha_cultist_1"
					}
				}
			},
			["nur_cultist_easy"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nur_cultist_easy",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_nur_cha_cultist_0"
					}
				}
			},
			["sla_warshrine"] = {
				["difficulty_delta"] = 6,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_warshrine",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_dlc20_chs_mon_warshrine_msla"
					}
				}
			},
			["nur_chariot_1"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nur_chariot_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_dlc20_chs_cav_chaos_chariot_mnur"
					}
				}
			},
			["kho_cultist_hard"] = {
				["difficulty_delta"] = 7,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_cultist_hard",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_kho_cha_cultist_1"
					}
				}
			},
			["kho_ex_letters_1"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_ex_letters_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_kho_inf_bloodletters_1"
					}
				}
			},
			["kho_spawn_3"] = {
				["difficulty_delta"] = 6,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_spawn_3",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_kho_mon_spawn_of_khorne_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_kho_mon_spawn_of_khorne_0"
					},
					[3] = {
						["unit_key"] = "wh3_main_kho_mon_spawn_of_khorne_0"
					}
				}
			},
			["kho_chariot_2"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_chariot_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_dlc20_chs_cav_chaos_chariot_mkho"
					},
					[2] = {
						["unit_key"] = "wh3_dlc20_chs_cav_chaos_chariot_mkho"
					}
				}
			},
			["nur_ex_plaguebearer_2"] = {
				["difficulty_delta"] = 8,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nur_ex_plaguebearer_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_nur_inf_plaguebearers_1"
					},
					[2] = {
						["unit_key"] = "wh3_main_nur_inf_plaguebearers_1"
					}
				}
			},
			["kho_bloodthirster"] = {
				["difficulty_delta"] = 12,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_bloodthirster",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_kho_mon_bloodthirster_0"
					}
				}
			},
			["nur_warriors_3"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mnur"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mnur"
						},
						[3] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mnur"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mnur_greatweapons"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mnur_greatweapons"
						},
						[3] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mnur_greatweapons"
						}
					}
				},
				["force_fragment_key"] = "nur_warriors_3",
				["mandatory_units"] = {

				}
			},
			["sla_forsaken_2"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_forsaken_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_dlc20_chs_inf_forsaken_msla"
					},
					[2] = {
						["unit_key"] = "wh3_dlc20_chs_inf_forsaken_msla"
					}
				}
			},
			["tze_warriors_3"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mtze"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mtze_halberds"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mtze"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mtze_halberds"
						}
					},
					[3] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mtze"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mtze_halberds"
						}
					}
				},
				["force_fragment_key"] = "tze_warriors_3",
				["mandatory_units"] = {

				}
			},
			["kho_knights_2"] = {
				["difficulty_delta"] = 8,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_cav_chaos_knights_mkho"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_cav_chaos_knights_mkho_lances"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_cav_chaos_knights_mkho"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_cav_chaos_knights_mkho_lances"
						}
					}
				},
				["force_fragment_key"] = "kho_knights_2",
				["mandatory_units"] = {

				}
			},
			["kho_ex_letters_2"] = {
				["difficulty_delta"] = 8,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_ex_letters_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_kho_inf_bloodletters_1"
					},
					[2] = {
						["unit_key"] = "wh3_main_kho_inf_bloodletters_1"
					}
				}
			},
			["nur_cultist_hard"] = {
				["difficulty_delta"] = 7,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nur_cultist_hard",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_nur_cha_cultist_1"
					}
				}
			},
			["nur_marauder_horse_2"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nur_marauder_horse_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_dlc20_chs_cav_marauder_horsemen_mnur_throwing_axes"
					},
					[2] = {
						["unit_key"] = "wh3_dlc20_chs_cav_marauder_horsemen_mnur_throwing_axes"
					}
				}
			},
			["kho_minos_1"] = {
				["difficulty_delta"] = 6,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_main_kho_mon_khornataurs_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_kho_mon_khornataurs_1"
						}
					}
				},
				["force_fragment_key"] = "kho_minos_1",
				["mandatory_units"] = {

				}
			},
			["nor_warhounds_2"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh_main_nor_mon_chaos_warhounds_0"
						},
						[2] = {
							["unit_key"] = "wh_main_nor_mon_chaos_warhounds_1"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh_main_nor_mon_chaos_warhounds_0"
						},
						[2] = {
							["unit_key"] = "wh_main_nor_mon_chaos_warhounds_1"
						}
					}
				},
				["force_fragment_key"] = "nor_warhounds_2",
				["mandatory_units"] = {

				}
			},
			["tze_chosen_1"] = {
				["difficulty_delta"] = 5,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mtze"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mtze_halberds"
						}
					}
				},
				["force_fragment_key"] = "tze_chosen_1",
				["mandatory_units"] = {

				}
			},
			["sla_spawn_3"] = {
				["difficulty_delta"] = 6,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_spawn_3",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_sla_mon_spawn_of_slaanesh_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_sla_mon_spawn_of_slaanesh_0"
					},
					[3] = {
						["unit_key"] = "wh3_main_sla_mon_spawn_of_slaanesh_0"
					}
				}
			},
			["tze_chariot_1"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "tze_chariot_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_dlc20_chs_cav_chaos_chariot_mtze"
					}
				}
			},
			["tze_furies_2"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "tze_furies_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_tze_inf_chaos_furies_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_tze_inf_chaos_furies_0"
					}
				}
			},
			["chs_warriors_4"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh_main_chs_inf_chaos_warriors_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_inf_chaos_warriors_1"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh_main_chs_inf_chaos_warriors_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_inf_chaos_warriors_1"
						}
					},
					[3] = {
						[1] = {
							["unit_key"] = "wh_main_chs_inf_chaos_warriors_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_inf_chaos_warriors_1"
						}
					},
					[4] = {
						[1] = {
							["unit_key"] = "wh_main_chs_inf_chaos_warriors_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_inf_chaos_warriors_1"
						}
					}
				},
				["force_fragment_key"] = "chs_warriors_4",
				["mandatory_units"] = {

				}
			},
			["kho_knights_1"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_cav_chaos_knights_mkho"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_cav_chaos_knights_mkho_lances"
						}
					}
				},
				["force_fragment_key"] = "kho_knights_1",
				["mandatory_units"] = {

				}
			},
			["chs_forsaken_3"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "chs_forsaken_3",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh_dlc01_chs_inf_forsaken_0"
					},
					[2] = {
						["unit_key"] = "wh_dlc01_chs_inf_forsaken_0"
					},
					[3] = {
						["unit_key"] = "wh_dlc01_chs_inf_forsaken_0"
					}
				}
			},
			["kho_gorebeast_2"] = {
				["difficulty_delta"] = 8,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_gorebeast_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_kho_cav_gorebeast_chariot"
					},
					[2] = {
						["unit_key"] = "wh3_main_kho_cav_gorebeast_chariot"
					}
				}
			},
			["tze_knights_2"] = {
				["difficulty_delta"] = 8,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_main_tze_cav_chaos_knights_0"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_cav_chaos_knights_mtze_lances"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_main_tze_cav_chaos_knights_0"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_cav_chaos_knights_mtze_lances"
						}
					}
				},
				["force_fragment_key"] = "tze_knights_2",
				["mandatory_units"] = {

				}
			},
			["sla_heartseekers_1"] = {
				["difficulty_delta"] = 9,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_heartseekers_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_sla_cav_heartseekers_of_slaanesh_0"
					}
				}
			},
			["kho_marauders_3"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_marauders_3",
				["mandatory_units"] = {

				}
			},
			["sla_cultist_hard"] = {
				["difficulty_delta"] = 7,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_cultist_hard",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_sla_cha_cultist_1"
					}
				}
			},
			["kho_fleshhounds_2"] = {
				["difficulty_delta"] = 8,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_fleshhounds_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_kho_inf_flesh_hounds_of_khorne_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_kho_inf_flesh_hounds_of_khorne_0"
					}
				}
			},
			["kho_skullcannon"] = {
				["difficulty_delta"] = 9,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_skullcannon",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_kho_veh_skullcannon_0"
					}
				}
			},
			["any_soulgrinder_1"] = {
				["difficulty_delta"] = 9,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_main_kho_mon_soul_grinder_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_nur_mon_soul_grinder_0"
						},
						[3] = {
							["unit_key"] = "wh3_main_sla_mon_soul_grinder_0"
						},
						[4] = {
							["unit_key"] = "wh3_main_tze_mon_soul_grinder_0"
						}
					}
				},
				["force_fragment_key"] = "any_soulgrinder_1",
				["mandatory_units"] = {

				}
			},
			["nur_chariot_2"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nur_chariot_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_dlc20_chs_cav_chaos_chariot_mnur"
					},
					[2] = {
						["unit_key"] = "wh3_dlc20_chs_cav_chaos_chariot_mnur"
					}
				}
			},
			["sla_soulgrinder_1"] = {
				["difficulty_delta"] = 9,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_soulgrinder_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_sla_mon_soul_grinder_0"
					}
				}
			},
			["sla_knights_2"] = {
				["difficulty_delta"] = 8,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_cav_chaos_knights_msla"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_cav_chaos_knights_msla_lances"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_cav_chaos_knights_msla"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_cav_chaos_knights_msla_lances"
						}
					}
				},
				["force_fragment_key"] = "sla_knights_2",
				["mandatory_units"] = {

				}
			},
			["nurglings_2"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nurglings_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_nur_inf_nurglings_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_nur_inf_nurglings_0"
					}
				}
			},
			["nur_warriors_2"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mnur"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mnur_greatweapons"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mnur"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mnur_greatweapons"
						}
					}
				},
				["force_fragment_key"] = "nur_warriors_2",
				["mandatory_units"] = {

				}
			},
			["sla_chosen_4"] = {
				["difficulty_delta"] = 12,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_msla"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_msla_hellscourges"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_msla"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_msla_hellscourges"
						}
					},
					[3] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_msla"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_msla_hellscourges"
						}
					},
					[4] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_msla"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_msla_hellscourges"
						}
					}
				},
				["force_fragment_key"] = "sla_chosen_4",
				["mandatory_units"] = {

				}
			},
			["nur_flies_1"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nur_flies_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_nur_mon_rot_flies_0"
					}
				}
			},
			["chs_marauders_4"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh_main_chs_inf_chaos_marauders_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_inf_chaos_marauders_1"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh_main_chs_inf_chaos_marauders_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_inf_chaos_marauders_1"
						}
					},
					[3] = {
						[1] = {
							["unit_key"] = "wh_main_chs_inf_chaos_marauders_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_inf_chaos_marauders_1"
						}
					},
					[4] = {
						[1] = {
							["unit_key"] = "wh_main_chs_inf_chaos_marauders_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_inf_chaos_marauders_1"
						}
					}
				},
				["force_fragment_key"] = "chs_marauders_4",
				["mandatory_units"] = {

				}
			},
			["nur_furies_2"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nur_furies_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_nur_inf_chaos_furies_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_nur_inf_chaos_furies_0"
					}
				}
			},
			["kho_gorebeast_1"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_gorebeast_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_kho_cav_gorebeast_chariot"
					}
				}
			},
			["kho_forsaken_2"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_forsaken_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_dlc20_chs_inf_forsaken_mkho"
					},
					[2] = {
						["unit_key"] = "wh3_dlc20_chs_inf_forsaken_mkho"
					}
				}
			},
			["chs_chariot_1"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "chs_chariot_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh_main_chs_cav_chaos_chariot"
					}
				}
			},
			["tze_forsaken_3"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "tze_forsaken_3",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_tze_inf_forsaken_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_tze_inf_forsaken_0"
					},
					[3] = {
						["unit_key"] = "wh3_main_tze_inf_forsaken_0"
					}
				}
			},
			["nur_pox_rider_1"] = {
				["difficulty_delta"] = 6,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nur_pox_rider_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_nur_cav_pox_riders_of_nurgle_0"
					}
				}
			},
			["kho_marauder_horse_2"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_marauder_horse_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_dlc20_chs_cav_marauder_horsemen_mkho_throwing_axes"
					},
					[2] = {
						["unit_key"] = "wh3_dlc20_chs_cav_marauder_horsemen_mkho_throwing_axes"
					}
				}
			},
			["nur_toads_1"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nur_toads_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_nur_mon_plague_toads_0"
					}
				}
			},
			["nur_knights_1"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_cav_chaos_knights_mnur"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_cav_chaos_knights_mnur_lances"
						}
					}
				},
				["force_fragment_key"] = "nur_knights_1",
				["mandatory_units"] = {

				}
			},
			["tze_chosen_2"] = {
				["difficulty_delta"] = 10,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mtze"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mtze_halberds"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mtze"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mtze_halberds"
						}
					}
				},
				["force_fragment_key"] = "tze_chosen_2",
				["mandatory_units"] = {

				}
			},
			["tze_cultist_norm"] = {
				["difficulty_delta"] = 5,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_main_tze_cha_cultist_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_tze_cha_cultist_1"
						}
					}
				},
				["force_fragment_key"] = "tze_cultist_norm",
				["mandatory_units"] = {

				}
			},
			["nur_plaguebearer_3"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nur_plaguebearer_3",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_nur_inf_plaguebearers_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_nur_inf_plaguebearers_0"
					},
					[3] = {
						["unit_key"] = "wh3_main_nur_inf_plaguebearers_0"
					}
				}
			},
			["nur_chosen_4"] = {
				["difficulty_delta"] = 12,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mnur"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mnur_greatweapons"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mnur"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mnur_greatweapons"
						}
					},
					[3] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mnur"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mnur_greatweapons"
						}
					},
					[4] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mnur"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mnur_greatweapons"
						}
					}
				},
				["force_fragment_key"] = "nur_chosen_4",
				["mandatory_units"] = {

				}
			},
			["nur_plaguebearer_1"] = {
				["difficulty_delta"] = 1,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nur_plaguebearer_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_nur_inf_plaguebearers_0"
					}
				}
			},
			["sla_hellflayer"] = {
				["difficulty_delta"] = 9,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_hellflayer",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_sla_veh_hellflayer_0"
					}
				}
			},
			["sla_ex_seeker_chariot_2"] = {
				["difficulty_delta"] = 18,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_ex_seeker_chariot_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_sla_veh_exalted_seeker_chariot_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_sla_veh_exalted_seeker_chariot_0"
					}
				}
			},
			["kho_chosen_1"] = {
				["difficulty_delta"] = 5,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mkho"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mkho_dualweapons"
						}
					}
				},
				["force_fragment_key"] = "kho_chosen_1",
				["mandatory_units"] = {

				}
			},
			["tze_marauders_4"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mtze"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mtze_spears"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mtze"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mtze_spears"
						}
					},
					[3] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mtze"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mtze_spears"
						}
					},
					[4] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mtze"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mtze_spears"
						}
					}
				},
				["force_fragment_key"] = "tze_marauders_4",
				["mandatory_units"] = {

				}
			},
			["sla_chariot_1"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_chariot_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_dlc20_chs_cav_chaos_chariot_msla"
					}
				}
			},
			["sla_knights_1"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_cav_chaos_knights_msla"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_cav_chaos_knights_msla_lances"
						}
					}
				},
				["force_fragment_key"] = "sla_knights_1",
				["mandatory_units"] = {

				}
			},
			["nur_beast_2"] = {
				["difficulty_delta"] = 8,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nur_beast_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_nur_mon_beast_of_nurgle_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_nur_mon_beast_of_nurgle_0"
					}
				}
			},
			["nur_unclean_one"] = {
				["difficulty_delta"] = 12,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nur_unclean_one",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_nur_mon_great_unclean_one_0"
					}
				}
			},
			["sla_keeper_of_secrets"] = {
				["difficulty_delta"] = 12,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_keeper_of_secrets",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_sla_mon_keeper_of_secrets_0"
					}
				}
			},
			["kho_chosen_2"] = {
				["difficulty_delta"] = 10,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mkho"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mkho_dualweapons"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mkho"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mkho_dualweapons"
						}
					}
				},
				["force_fragment_key"] = "kho_chosen_2",
				["mandatory_units"] = {

				}
			},
			["kho_warriors_3"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "Chaos Warriors of Khorne",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_1"
						},
						[3] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_2"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_1"
						},
						[3] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_2"
						}
					},
					[3] = {
						[1] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_1"
						},
						[3] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_2"
						}
					}
				},
				["force_fragment_key"] = "kho_warriors_3",
				["mandatory_units"] = {

				}
			},
			["sla_marauders_4"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_main_sla_inf_marauders_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_sla_inf_marauders_1"
						},
						[3] = {
							["unit_key"] = "wh3_main_sla_inf_marauders_2"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_main_sla_inf_marauders_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_sla_inf_marauders_1"
						},
						[3] = {
							["unit_key"] = "wh3_main_sla_inf_marauders_2"
						}
					},
					[3] = {
						[1] = {
							["unit_key"] = "wh3_main_sla_inf_marauders_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_sla_inf_marauders_1"
						},
						[3] = {
							["unit_key"] = "wh3_main_sla_inf_marauders_2"
						}
					},
					[4] = {
						[1] = {
							["unit_key"] = "wh3_main_sla_inf_marauders_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_sla_inf_marauders_1"
						},
						[3] = {
							["unit_key"] = "wh3_main_sla_inf_marauders_2"
						}
					}
				},
				["force_fragment_key"] = "sla_marauders_4",
				["mandatory_units"] = {

				}
			},
			["sla_heartseekers_2"] = {
				["difficulty_delta"] = 18,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_heartseekers_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_sla_cav_heartseekers_of_slaanesh_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_sla_cav_heartseekers_of_slaanesh_0"
					}
				}
			},
			["sla_seeker_chariot_2"] = {
				["difficulty_delta"] = 8,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_seeker_chariot_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_sla_veh_seeker_chariot_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_sla_veh_seeker_chariot_0"
					}
				}
			},
			["tze_chosen_4"] = {
				["difficulty_delta"] = 12,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mtze"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mtze_halberds"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mtze"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mtze_halberds"
						}
					},
					[3] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mtze"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mtze_halberds"
						}
					},
					[4] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mtze"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mtze_halberds"
						}
					}
				},
				["force_fragment_key"] = "tze_chosen_4",
				["mandatory_units"] = {

				}
			},
			["bst_warhounds_2"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh_dlc03_bst_inf_chaos_warhounds_0"
						},
						[2] = {
							["unit_key"] = "wh_dlc03_bst_inf_chaos_warhounds_1"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh_dlc03_bst_inf_chaos_warhounds_0"
						},
						[2] = {
							["unit_key"] = "wh_dlc03_bst_inf_chaos_warhounds_1"
						}
					}
				},
				["force_fragment_key"] = "bst_warhounds_2",
				["mandatory_units"] = {

				}
			},
			["chs_exalted_hero_norm"] = {
				["difficulty_delta"] = 5,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "chs_exalted_hero_norm",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh_main_chs_cha_exalted_hero_13"
					}
				}
			},
			["kho_chosen_4"] = {
				["difficulty_delta"] = 12,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mkho"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mkho_dualweapons"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mkho"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mkho_dualweapons"
						}
					},
					[3] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mkho"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mkho_dualweapons"
						}
					},
					[4] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mkho"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mkho_dualweapons"
						}
					}
				},
				["force_fragment_key"] = "kho_chosen_4",
				["mandatory_units"] = {

				}
			},
			["sla_seekers_1"] = {
				["difficulty_delta"] = 6,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_seekers_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_sla_cav_seekers_of_slaanesh_0"
					}
				}
			},
			["tze_warriors_2"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mtze"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mtze_halberds"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mtze"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mtze_halberds"
						}
					}
				},
				["force_fragment_key"] = "tze_warriors_2",
				["mandatory_units"] = {

				}
			},
			["sla_chosen_1"] = {
				["difficulty_delta"] = 5,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_msla"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_msla_hellscourges"
						}
					}
				},
				["force_fragment_key"] = "sla_chosen_1",
				["mandatory_units"] = {

				}
			},
			["tze_chariot_2"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "tze_chariot_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_dlc20_chs_cav_chaos_chariot_mtze"
					},
					[2] = {
						["unit_key"] = "wh3_dlc20_chs_cav_chaos_chariot_mtze"
					}
				}
			},
			["tze_soulgrinder_1"] = {
				["difficulty_delta"] = 9,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "tze_soulgrinder_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_tze_mon_soul_grinder_0"
					}
				}
			},
			["chs_chosen_2"] = {
				["difficulty_delta"] = 10,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh_main_chs_inf_chosen_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_inf_chosen_1"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh_main_chs_inf_chosen_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_inf_chosen_1"
						}
					}
				},
				["force_fragment_key"] = "chs_chosen_2",
				["mandatory_units"] = {

				}
			},
			["sla_hellstriders_2"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_main_sla_cav_hellstriders_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_sla_cav_hellstriders_1"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_main_sla_cav_hellstriders_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_sla_cav_hellstriders_1"
						}
					}
				},
				["force_fragment_key"] = "sla_hellstriders_2",
				["mandatory_units"] = {

				}
			},
			["nur_pox_rider_2"] = {
				["difficulty_delta"] = 12,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nur_pox_rider_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_nur_cav_pox_riders_of_nurgle_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_nur_cav_pox_riders_of_nurgle_0"
					}
				}
			},
			["nur_ex_plaguebearer_1"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nur_ex_plaguebearer_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_nur_inf_plaguebearers_1"
					}
				}
			},
			["kho_warshrine"] = {
				["difficulty_delta"] = 6,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_warshrine",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_dlc20_chs_mon_warshrine_mkho"
					}
				}
			},
			["nur_warshrine"] = {
				["difficulty_delta"] = 6,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nur_warshrine",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_dlc20_chs_mon_warshrine_mnur"
					}
				}
			},
			["kho_bloodcrusher_2"] = {
				["difficulty_delta"] = 12,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_bloodcrusher_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_kho_cav_bloodcrushers_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_kho_cav_bloodcrushers_0"
					}
				}
			},
			["nur_drones_1"] = {
				["difficulty_delta"] = 6,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_main_nur_cav_plague_drones_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_nur_cav_plague_drones_1"
						}
					}
				},
				["force_fragment_key"] = "nur_drones_1",
				["mandatory_units"] = {

				}
			},
			["tze_forsaken_2"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "tze_forsaken_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_tze_inf_forsaken_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_tze_inf_forsaken_0"
					}
				}
			},
			["nur_chosen_2"] = {
				["difficulty_delta"] = 10,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mnur"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mnur_greatweapons"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mnur"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_mnur_greatweapons"
						}
					}
				},
				["force_fragment_key"] = "nur_chosen_2",
				["mandatory_units"] = {

				}
			},
			["sla_cultist_norm"] = {
				["difficulty_delta"] = 5,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_main_sla_cha_cultist_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_sla_cha_cultist_1"
						}
					}
				},
				["force_fragment_key"] = "sla_cultist_norm",
				["mandatory_units"] = {

				}
			},
			["kho_bloodshrine"] = {
				["difficulty_delta"] = 6,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_bloodshrine",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_kho_veh_blood_shrine_0"
					}
				}
			},
			["tze_knights_1"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_main_tze_cav_chaos_knights_0"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_cav_chaos_knights_mtze_lances"
						}
					}
				},
				["force_fragment_key"] = "tze_knights_1",
				["mandatory_units"] = {

				}
			},
			["sla_cultist_easy"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_cultist_easy",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_sla_cha_cultist_0"
					}
				}
			},
			["nur_plaguebearer_2"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nur_plaguebearer_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_nur_inf_plaguebearers_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_nur_inf_plaguebearers_0"
					}
				}
			},
			["nur_marauders_3"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mnur"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mnur_greatweapons"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mnur"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mnur_greatweapons"
						}
					},
					[3] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mnur"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mnur_greatweapons"
						}
					}
				},
				["force_fragment_key"] = "nur_marauders_3",
				["mandatory_units"] = {

				}
			},
			["sla_marauders_3"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_main_sla_inf_marauders_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_sla_inf_marauders_1"
						},
						[3] = {
							["unit_key"] = "wh3_main_sla_inf_marauders_2"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_main_sla_inf_marauders_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_sla_inf_marauders_1"
						},
						[3] = {
							["unit_key"] = "wh3_main_sla_inf_marauders_2"
						}
					},
					[3] = {
						[1] = {
							["unit_key"] = "wh3_main_sla_inf_marauders_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_sla_inf_marauders_1"
						},
						[3] = {
							["unit_key"] = "wh3_main_sla_inf_marauders_2"
						}
					}
				},
				["force_fragment_key"] = "sla_marauders_3",
				["mandatory_units"] = {

				}
			},
			["sla_warriors_2"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_msla"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_msla_hellscourges"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_msla_hellscourges"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_msla"
						}
					}
				},
				["force_fragment_key"] = "sla_warriors_2",
				["mandatory_units"] = {

				}
			},
			["nur_beast_1"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nur_beast_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_nur_mon_beast_of_nurgle_0"
					}
				}
			},
			["kho_letters_1"] = {
				["difficulty_delta"] = 1,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_letters_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_kho_inf_bloodletters_0"
					}
				}
			},
			["tze_marauders_3"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mtze"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mtze_spears"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mtze"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mtze_spears"
						}
					},
					[3] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mtze"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mtze_spears"
						}
					}
				},
				["force_fragment_key"] = "tze_marauders_3",
				["mandatory_units"] = {

				}
			},
			["kho_warriors_2"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_1"
						},
						[3] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_2"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_1"
						},
						[3] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_2"
						}
					}
				},
				["force_fragment_key"] = "kho_warriors_2",
				["mandatory_units"] = {

				}
			},
			["tze_blue_4"] = {
				["difficulty_delta"] = 5,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "tze_blue_4",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_tze_inf_blue_horrors_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_tze_inf_blue_horrors_0"
					},
					[3] = {
						["unit_key"] = "wh3_main_tze_inf_blue_horrors_0"
					},
					[4] = {
						["unit_key"] = "wh3_main_tze_inf_blue_horrors_0"
					}
				}
			},
			["kho_furies_2"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_furies_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_kho_inf_chaos_furies_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_kho_inf_chaos_furies_0"
					}
				}
			},
			["sla_chosen_2"] = {
				["difficulty_delta"] = 10,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_msla"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_msla_hellscourges"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_msla"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chosen_msla_hellscourges"
						}
					}
				},
				["force_fragment_key"] = "sla_chosen_2",
				["mandatory_units"] = {

				}
			},
			["nur_warriors_4"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mnur"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mnur_greatweapons"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mnur"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mnur_greatweapons"
						}
					},
					[3] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mnur"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mnur_greatweapons"
						}
					},
					[4] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mnur"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_mnur_greatweapons"
						}
					}
				},
				["force_fragment_key"] = "nur_warriors_4",
				["mandatory_units"] = {

				}
			},
			["kho_warhounds_2"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_warhounds_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_kho_inf_chaos_warhounds_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_kho_inf_chaos_warhounds_0"
					}
				}
			},
			["tze_blue_2"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "tze_blue_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_tze_inf_blue_horrors_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_tze_inf_blue_horrors_0"
					}
				}
			},
			["sla_daemonette_2"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_daemonette_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_sla_inf_daemonette_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_sla_inf_daemonette_0"
					}
				}
			},
			["tze_pink_2"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "tze_pink_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_tze_inf_pink_horrors_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_tze_inf_pink_horrors_0"
					}
				}
			},
			["tze_pink_1"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "tze_pink_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_tze_inf_pink_horrors_0"
					}
				}
			},
			["sla_daemonette_3"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_daemonette_3",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_sla_inf_daemonette_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_sla_inf_daemonette_0"
					},
					[3] = {
						["unit_key"] = "wh3_main_sla_inf_daemonette_0"
					}
				}
			},
			["sla_daemonette_1"] = {
				["difficulty_delta"] = 1,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_daemonette_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_sla_inf_daemonette_0"
					}
				}
			},
			["kho_skullcrasher_2"] = {
				["difficulty_delta"] = 18,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_skullcrasher_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_kho_cav_skullcrushers_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_kho_cav_skullcrushers_0"
					}
				}
			},
			["chs_warriors_2"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh_main_chs_inf_chaos_warriors_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_inf_chaos_warriors_1"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh_main_chs_inf_chaos_warriors_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_inf_chaos_warriors_1"
						}
					}
				},
				["force_fragment_key"] = "chs_warriors_2",
				["mandatory_units"] = {

				}
			},
			["sla_fiends_2"] = {
				["difficulty_delta"] = 8,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_fiends_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_sla_mon_fiends_of_slaanesh_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_sla_mon_fiends_of_slaanesh_0"
					}
				}
			},
			["kho_marauders_4"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mkho"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mkho_dualweapons"
						},
						[3] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mkho"
						},
						[4] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mkho_dualweapons"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mkho"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mkho_dualweapons"
						},
						[3] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mkho"
						}
					},
					[3] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mkho"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mkho_dualweapons"
						},
						[3] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mkho"
						},
						[4] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mkho_dualweapons"
						}
					},
					[4] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mkho"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_marauders_mkho_dualweapons"
						}
					}
				},
				["force_fragment_key"] = "kho_marauders_4",
				["mandatory_units"] = {

				}
			},
			["sla_chariot_2"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_chariot_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_dlc20_chs_cav_chaos_chariot_msla"
					},
					[2] = {
						["unit_key"] = "wh3_dlc20_chs_cav_chaos_chariot_msla"
					}
				}
			},
			["sla_ex_daemonette_1"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_ex_daemonette_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_sla_inf_daemonette_1"
					}
				}
			},
			["nur_forsaken_2"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nur_forsaken_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_nur_inf_forsaken_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_nur_inf_forsaken_0"
					}
				}
			},
			["sla_spawn_1"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_spawn_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_sla_mon_spawn_of_slaanesh_0"
					}
				}
			},
			["tze_warshrine"] = {
				["difficulty_delta"] = 6,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "tze_warshrine",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_dlc20_chs_mon_warshrine_mtze"
					}
				}
			},
			["kho_chariot_1"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_chariot_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_dlc20_chs_cav_chaos_chariot_mkho"
					}
				}
			},
			["nur_toads_2"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nur_toads_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_nur_mon_plague_toads_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_nur_mon_plague_toads_0"
					}
				}
			},
			["chs_knights_2"] = {
				["difficulty_delta"] = 8,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh_main_chs_cav_chaos_knights_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_cav_chaos_knights_1"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh_main_chs_cav_chaos_knights_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_cav_chaos_knights_1"
						}
					}
				},
				["force_fragment_key"] = "chs_knights_2",
				["mandatory_units"] = {

				}
			},
			["nur_spawn_3"] = {
				["difficulty_delta"] = 6,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nur_spawn_3",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_nur_mon_spawn_of_nurgle_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_nur_mon_spawn_of_nurgle_0"
					},
					[3] = {
						["unit_key"] = "wh3_main_nur_mon_spawn_of_nurgle_0"
					}
				}
			},
			["nur_flies_2"] = {
				["difficulty_delta"] = 8,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nur_flies_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_nur_mon_rot_flies_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_nur_mon_rot_flies_0"
					}
				}
			},
			["kho_soulgrinder_1"] = {
				["difficulty_delta"] = 9,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_soulgrinder_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_kho_mon_soul_grinder_0"
					}
				}
			},
			["sla_ex_seeker_chariot_1"] = {
				["difficulty_delta"] = 9,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_ex_seeker_chariot_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_sla_veh_exalted_seeker_chariot_0"
					}
				}
			},
			["kho_skullcrusher_1"] = {
				["difficulty_delta"] = 9,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_skullcrusher_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_kho_cav_skullcrushers_0"
					}
				}
			},
			["kho_letters_3"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_letters_3",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_kho_inf_bloodletters_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_kho_inf_bloodletters_0"
					},
					[3] = {
						["unit_key"] = "wh3_main_kho_inf_bloodletters_0"
					}
				}
			},
			["nurglings_3"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nurglings_3",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_nur_inf_nurglings_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_nur_inf_nurglings_0"
					},
					[3] = {
						["unit_key"] = "wh3_main_nur_inf_nurglings_0"
					}
				}
			},
			["sla_fiends_1"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_fiends_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_sla_mon_fiends_of_slaanesh_0"
					}
				}
			},
			["chs_chosen_1"] = {
				["difficulty_delta"] = 5,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh_main_chs_inf_chosen_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_inf_chosen_1"
						}
					}
				},
				["force_fragment_key"] = "chs_chosen_1",
				["mandatory_units"] = {

				}
			},
			["chs_exalted_hero_hard"] = {
				["difficulty_delta"] = 7,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "chs_exalted_hero_hard",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh_main_chs_cha_exalted_hero_7"
					}
				}
			},
			["sla_seeker_chariot_1"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_seeker_chariot_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_sla_veh_seeker_chariot_0"
					}
				}
			},
			["chs_warhounds_2"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh_main_chs_mon_chaos_warhounds_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_mon_chaos_warhounds_1"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh_main_chs_mon_chaos_warhounds_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_mon_chaos_warhounds_1"
						}
					}
				},
				["force_fragment_key"] = "chs_warhounds_2",
				["mandatory_units"] = {

				}
			},
			["nur_soulgrinder_1"] = {
				["difficulty_delta"] = 9,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nur_soulgrinder_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_nur_mon_soul_grinder_0"
					}
				}
			},
			["nur_cultist_norm"] = {
				["difficulty_delta"] = 5,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_main_nur_cha_cultist_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_nur_cha_cultist_1"
						}
					}
				},
				["force_fragment_key"] = "nur_cultist_norm",
				["mandatory_units"] = {

				}
			},
			["kho_minos_2"] = {
				["difficulty_delta"] = 12,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_main_kho_mon_khornataurs_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_kho_mon_khornataurs_1"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_main_kho_mon_khornataurs_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_kho_mon_khornataurs_1"
						}
					}
				},
				["force_fragment_key"] = "kho_minos_2",
				["mandatory_units"] = {

				}
			},
			["kho_warriors_4"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_1"
						},
						[3] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_2"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_1"
						},
						[3] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_2"
						}
					},
					[3] = {
						[1] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_1"
						},
						[3] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_2"
						}
					},
					[4] = {
						[1] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_1"
						},
						[3] = {
							["unit_key"] = "wh3_main_kho_inf_chaos_warriors_2"
						}
					}
				},
				["force_fragment_key"] = "kho_warriors_4",
				["mandatory_units"] = {

				}
			},
			["chs_chosen_4"] = {
				["difficulty_delta"] = 12,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh_main_chs_inf_chosen_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_inf_chosen_1"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh_main_chs_inf_chosen_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_inf_chosen_1"
						}
					},
					[3] = {
						[1] = {
							["unit_key"] = "wh_main_chs_inf_chosen_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_inf_chosen_1"
						}
					},
					[4] = {
						[1] = {
							["unit_key"] = "wh_main_chs_inf_chosen_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_inf_chosen_1"
						}
					}
				},
				["force_fragment_key"] = "chs_chosen_4",
				["mandatory_units"] = {

				}
			},
			["chs_marauder_horse_2"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh_main_chs_cav_marauder_horsemen_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_cav_marauder_horsemen_1"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh_main_chs_cav_marauder_horsemen_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_cav_marauder_horsemen_1"
						}
					}
				},
				["force_fragment_key"] = "chs_marauder_horse_2",
				["mandatory_units"] = {

				}
			},
			["chs_marauders_3"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh_main_chs_inf_chaos_marauders_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_inf_chaos_marauders_1"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh_main_chs_inf_chaos_marauders_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_inf_chaos_marauders_1"
						}
					},
					[3] = {
						[1] = {
							["unit_key"] = "wh_main_chs_inf_chaos_marauders_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_inf_chaos_marauders_1"
						}
					}
				},
				["force_fragment_key"] = "chs_marauders_3",
				["mandatory_units"] = {

				}
			},
			["sla_warriors_3"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_msla"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_msla_hellscourges"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_msla"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_msla_hellscourges"
						}
					},
					[3] = {
						[1] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_msla"
						},
						[2] = {
							["unit_key"] = "wh3_dlc20_chs_inf_chaos_warriors_msla_hellscourges"
						}
					}
				},
				["force_fragment_key"] = "sla_warriors_3",
				["mandatory_units"] = {

				}
			},
			["chs_marauder_horse_4"] = {
				["difficulty_delta"] = 8,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh_main_chs_cav_marauder_horsemen_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_cav_marauder_horsemen_1"
						},
						[3] = {
							["unit_key"] = "wh_dlc06_chs_cav_marauder_horsemasters_0"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh_main_chs_cav_marauder_horsemen_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_cav_marauder_horsemen_1"
						},
						[3] = {
							["unit_key"] = "wh_dlc06_chs_cav_marauder_horsemasters_0"
						}
					},
					[3] = {
						[1] = {
							["unit_key"] = "wh_main_chs_cav_marauder_horsemen_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_cav_marauder_horsemen_1"
						},
						[3] = {
							["unit_key"] = "wh_dlc06_chs_cav_marauder_horsemasters_0"
						}
					},
					[4] = {
						[1] = {
							["unit_key"] = "wh_main_chs_cav_marauder_horsemen_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_cav_marauder_horsemen_1"
						}
					}
				},
				["force_fragment_key"] = "chs_marauder_horse_4",
				["mandatory_units"] = {

				}
			},
			["chs_warriors_3"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh_main_chs_inf_chaos_warriors_0"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_inf_chaos_warriors_0"
						},
						[3] = {
							["unit_key"] = "wh_main_chs_inf_chaos_warriors_0"
						}
					},
					[2] = {
						[1] = {
							["unit_key"] = "wh_main_chs_inf_chaos_warriors_1"
						},
						[2] = {
							["unit_key"] = "wh_main_chs_inf_chaos_warriors_1"
						},
						[3] = {
							["unit_key"] = "wh_main_chs_inf_chaos_warriors_1"
						}
					}
				},
				["force_fragment_key"] = "chs_warriors_3",
				["mandatory_units"] = {

				}
			},
			["kho_fleshhounds_1"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_fleshhounds_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_kho_inf_flesh_hounds_of_khorne_0"
					}
				}
			},
			["kho_letters_2"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "kho_letters_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_kho_inf_bloodletters_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_kho_inf_bloodletters_0"
					}
				}
			},
			["nur_forsaken_3"] = {
				["difficulty_delta"] = 4,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nur_forsaken_3",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_nur_inf_forsaken_0"
					},
					[2] = {
						["unit_key"] = "wh3_main_nur_inf_forsaken_0"
					},
					[3] = {
						["unit_key"] = "wh3_main_nur_inf_forsaken_0"
					}
				}
			},
			["nur_spawn_1"] = {
				["difficulty_delta"] = 2,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "nur_spawn_1",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_main_nur_mon_spawn_of_nurgle_0"
					}
				}
			},
			["sla_marauder_horse_2"] = {
				["difficulty_delta"] = 3,
				["localised_name"] = "",
				["generated_unit_slots"] = {

				},
				["force_fragment_key"] = "sla_marauder_horse_2",
				["mandatory_units"] = {
					[1] = {
						["unit_key"] = "wh3_dlc20_chs_cav_marauder_horsemen_msla_javelins"
					},
					[2] = {
						["unit_key"] = "wh3_dlc20_chs_cav_marauder_horsemen_msla_javelins"
					}
				}
			},
			["kho_cultist_norm"] = {
				["difficulty_delta"] = 5,
				["localised_name"] = "",
				["generated_unit_slots"] = {
					[1] = {
						[1] = {
							["unit_key"] = "wh3_main_kho_cha_cultist_0"
						},
						[2] = {
							["unit_key"] = "wh3_main_kho_cha_cultist_1"
						}
					}
				},
				["force_fragment_key"] = "kho_cultist_norm",
				["mandatory_units"] = {

				}
			}
		},
		["forces"] = {
			["SPECIAL_MIRROR"] = {
				["base_difficulty"] = 0,
				["force_fragment_set"] = {
					["mandatory_fragments"] = {

					},
					["key"] = "SPECIAL_MIRROR",
					["generated_fragment_slots"] = {

					}
				},
				["force_key"] = "SPECIAL_MIRROR",
				["commander_set"] = {
					[1] = {
						["difficulty_delta"] = 7,
						["agent_subtype"] = "wh3_dlc20_chs_daemon_prince_undivided",
						["commander_key"] = "chs_prince"
					}
				},
				["faction_set"] = {
					[1] = "wh3_main_dae_daemons_qb1"
				}
			},
			["starting_battle_kho"] = {
				["base_difficulty"] = 0,
				["force_fragment_set"] = {
					["mandatory_fragments"] = {
						[1] = {
							["force_fragment_key"] = "kho_warriors_2",
							["hidden_fragment"] = false
						}
					},
					["key"] = "starting_battle_kho",
					["generated_fragment_slots"] = {
						[1] = {
							[1] = {
								["force_fragment_key"] = "kho_warriors_2",
								["hidden_fragment"] = false
							},
							[2] = {
								["force_fragment_key"] = "kho_marauders_3",
								["hidden_fragment"] = false
							},
							[3] = {
								["force_fragment_key"] = "kho_forsaken_2",
								["hidden_fragment"] = false
							}
						},
						[2] = {
							[1] = {
								["force_fragment_key"] = "kho_marauder_horse_2",
								["hidden_fragment"] = false
							},
							[2] = {
								["force_fragment_key"] = "kho_chariot_1",
								["hidden_fragment"] = false
							},
							[3] = {
								["force_fragment_key"] = "kho_warhounds_2",
								["hidden_fragment"] = false
							}
						},
						[3] = {
							[1] = {
								["force_fragment_key"] = "kho_fleshhounds_1",
								["hidden_fragment"] = false
							},
							[2] = {
								["force_fragment_key"] = "kho_gorebeast_1",
								["hidden_fragment"] = false
							}
						}
					}
				},
				["force_key"] = "starting_battle_kho",
				["commander_set"] = {
					[1] = {
						["difficulty_delta"] = 1,
						["agent_subtype"] = "wh3_dlc20_chs_lord_mkho",
						["commander_key"] = "kho_starting_enemy"
					}
				},
				["faction_set"] = {
					[1] = "wh3_main_kho_bloody_sword",
					[2] = "wh3_main_kho_karneths_sons",
					[3] = "wh3_main_kho_brazen_throne",
					[4] = "wh3_main_kho_crimson_skull"
				}
			},
			["kho_chaos_warband_easy"] = {
				["base_difficulty"] = 0,
				["force_fragment_set"] = {
					["mandatory_fragments"] = {

					},
					["key"] = "kho_chaos_warband_easy",
					["generated_fragment_slots"] = {

					}
				},
				["force_key"] = "kho_chaos_warband_easy",
				["commander_set"] = {

				},
				["faction_set"] = {
					[1] = "wh3_main_kho_bloody_sword",
					[2] = "wh3_main_kho_karneths_sons",
					[3] = "wh3_main_kho_brazen_throne",
					[4] = "wh3_main_kho_crimson_skull"
				}
			},
			["starting_battle_nur"] = {
				["base_difficulty"] = 0,
				["force_fragment_set"] = {
					["mandatory_fragments"] = {
						[1] = {
							["force_fragment_key"] = "nurglings_4",
							["hidden_fragment"] = false
						}
					},
					["key"] = "starting_battle_nur",
					["generated_fragment_slots"] = {
						[1] = {
							[1] = {
								["force_fragment_key"] = "nur_warriors_2",
								["hidden_fragment"] = false
							},
							[2] = {
								["force_fragment_key"] = "nur_forsaken_2",
								["hidden_fragment"] = false
							},
							[3] = {
								["force_fragment_key"] = "nur_marauders_3",
								["hidden_fragment"] = false
							}
						},
						[2] = {
							[1] = {
								["force_fragment_key"] = "nur_flies_1",
								["hidden_fragment"] = false
							},
							[2] = {
								["force_fragment_key"] = "nur_toads_2",
								["hidden_fragment"] = false
							}
						},
						[3] = {
							[1] = {
								["force_fragment_key"] = "nur_beast_1",
								["hidden_fragment"] = false
							},
							[2] = {
								["force_fragment_key"] = "nur_plaguebearer_1",
								["hidden_fragment"] = false
							}
						}
					}
				},
				["force_key"] = "starting_battle_nur",
				["commander_set"] = {
					[1] = {
						["difficulty_delta"] = 0,
						["agent_subtype"] = "wh3_dlc20_chs_sorcerer_lord_nurgle_mnur",
						["commander_key"] = "nur_starting_enemy"
					}
				},
				["faction_set"] = {
					[1] = "wh3_main_nur_septic_claw",
					[2] = "wh3_main_nur_bubonic_swarm",
					[3] = "wh3_main_nur_maggoth_kin"
				}
			},
			["starting_battle_sla"] = {
				["base_difficulty"] = 0,
				["force_fragment_set"] = {
					["mandatory_fragments"] = {
						[1] = {
							["force_fragment_key"] = "sla_daemonette_1",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "sla_marauders_3",
							["hidden_fragment"] = false
						}
					},
					["key"] = "starting_battle_sla",
					["generated_fragment_slots"] = {
						[1] = {
							[1] = {
								["force_fragment_key"] = "sla_forsaken_2",
								["hidden_fragment"] = false
							},
							[2] = {
								["force_fragment_key"] = "sla_warriors_2",
								["hidden_fragment"] = false
							},
							[3] = {
								["force_fragment_key"] = "sla_marauders_3",
								["hidden_fragment"] = false
							}
						},
						[2] = {
							[1] = {
								["force_fragment_key"] = "sla_hellstriders_2",
								["hidden_fragment"] = false
							},
							[2] = {
								["force_fragment_key"] = "sla_furies_2",
								["hidden_fragment"] = false
							}
						}
					}
				},
				["force_key"] = "starting_battle_sla",
				["commander_set"] = {
					[1] = {
						["difficulty_delta"] = 0,
						["agent_subtype"] = "wh3_dlc20_chs_lord_msla",
						["commander_key"] = "sla_starting_enemy"
					}
				},
				["faction_set"] = {
					[1] = "wh3_main_sla_exquisite_pain",
					[2] = "wh3_main_sla_rapturous_excess",
					[3] = "wh3_main_sla_subtle_torture"
				}
			},
			["starting_battle_tze"] = {
				["base_difficulty"] = 0,
				["force_fragment_set"] = {
					["mandatory_fragments"] = {
						[1] = {
							["force_fragment_key"] = "tze_warriors_2",
							["hidden_fragment"] = false
						}
					},
					["key"] = "starting_battle_tze",
					["generated_fragment_slots"] = {
						[1] = {
							[1] = {
								["force_fragment_key"] = "tze_pink_1",
								["hidden_fragment"] = false
							},
							[2] = {
								["force_fragment_key"] = "tze_blue_2",
								["hidden_fragment"] = false
							}
						},
						[2] = {
							[1] = {
								["force_fragment_key"] = "tze_spawn_1",
								["hidden_fragment"] = false
							},
							[2] = {
								["force_fragment_key"] = "tze_forsaken_2",
								["hidden_fragment"] = false
							}
						},
						[3] = {
							[1] = {
								["force_fragment_key"] = "tze_chariot_1",
								["hidden_fragment"] = false
							},
							[2] = {
								["force_fragment_key"] = "tze_marauder_horse_2",
								["hidden_fragment"] = false
							},
							[3] = {
								["force_fragment_key"] = "tze_furies_2",
								["hidden_fragment"] = false
							}
						}
					}
				},
				["force_key"] = "starting_battle_tze",
				["commander_set"] = {
					[1] = {
						["difficulty_delta"] = 0,
						["agent_subtype"] = "wh3_dlc20_chs_sorcerer_lord_tzeentch_mtze",
						["commander_key"] = "tze_starting_enemy"
					}
				},
				["faction_set"] = {
					[1] = "wh3_main_tze_all_seeing_eye",
					[2] = "wh3_main_tze_sarthoraels_watchers",
					[3] = "wh3_main_tze_broken_wheel",
					[4] = "wh3_main_tze_flaming_scribes",
					[5] = "wh3_dlc20_tze_the_sightless"
				}
			}
		},
		["commanders"] = {
			["azazel_easy"] = {
				["difficulty_delta"] = 0,
				["agent_subtype"] = "wh3_dlc20_sla_azazel",
				["commander_key"] = "azazel_easy"
			},
			["chs_prince"] = {
				["difficulty_delta"] = 7,
				["agent_subtype"] = "wh3_dlc20_chs_daemon_prince_undivided",
				["commander_key"] = "chs_prince"
			},
			["festus_easy"] = {
				["difficulty_delta"] = 0,
				["agent_subtype"] = "wh3_dlc20_nur_festus",
				["commander_key"] = "festus_easy"
			},
			["nur_starting_enemy"] = {
				["difficulty_delta"] = 0,
				["agent_subtype"] = "wh3_dlc20_chs_sorcerer_lord_nurgle_mnur",
				["commander_key"] = "nur_starting_enemy"
			},
			["kho_valkia_easy"] = {
				["difficulty_delta"] = 10,
				["agent_subtype"] = "wh3_dlc20_kho_valkia",
				["commander_key"] = "kho_valkia_easy"
			},
			["kho_prince_easy"] = {
				["difficulty_delta"] = 3,
				["agent_subtype"] = "wh3_dlc20_chs_daemon_prince_khorne",
				["commander_key"] = "kho_prince_easy"
			},
			["nkari_easy"] = {
				["difficulty_delta"] = 0,
				["agent_subtype"] = "wh3_main_sla_nkari",
				["commander_key"] = "nkari_easy"
			},
			["kho_starting_enemy"] = {
				["difficulty_delta"] = 1,
				["agent_subtype"] = "wh3_dlc20_chs_lord_mkho",
				["commander_key"] = "kho_starting_enemy"
			},
			["kugath_easy"] = {
				["difficulty_delta"] = 0,
				["agent_subtype"] = "wh3_main_nur_kugath",
				["commander_key"] = "kugath_easy"
			},
			["vilitch_easy"] = {
				["difficulty_delta"] = 0,
				["agent_subtype"] = "wh3_dlc20_tze_vilitch",
				["commander_key"] = "vilitch_easy"
			},
			["kairos_easy"] = {
				["difficulty_delta"] = 0,
				["agent_subtype"] = "wh3_main_tze_kairos",
				["commander_key"] = "kairos_easy"
			},
			["sla_starting_enemy"] = {
				["difficulty_delta"] = 0,
				["agent_subtype"] = "wh3_dlc20_chs_lord_msla",
				["commander_key"] = "sla_starting_enemy"
			},
			["kho_lord_hard"] = {
				["difficulty_delta"] = 1,
				["agent_subtype"] = "wh3_dlc20_chs_lord_mkho",
				["commander_key"] = "kho_lord_hard"
			},
			["skarbrand_easy"] = {
				["difficulty_delta"] = 10,
				["agent_subtype"] = "wh3_main_kho_skarbrand",
				["commander_key"] = "skarbrand_easy"
			},
			["kho_lord_norm"] = {
				["difficulty_delta"] = 1,
				["agent_subtype"] = "wh3_dlc20_chs_lord_mkho",
				["commander_key"] = "kho_lord_norm"
			},
			["tze_starting_enemy"] = {
				["difficulty_delta"] = 0,
				["agent_subtype"] = "wh3_dlc20_chs_sorcerer_lord_tzeentch_mtze",
				["commander_key"] = "tze_starting_enemy"
			}
		},
		["commander_sets"] = {
			["kho_skarbrand_easy"] = {
				[1] = {
					["difficulty_delta"] = 10,
					["agent_subtype"] = "wh3_main_kho_skarbrand",
					["commander_key"] = "skarbrand_easy"
				}
			},
			["chs_prince"] = {
				[1] = {
					["difficulty_delta"] = 7,
					["agent_subtype"] = "wh3_dlc20_chs_daemon_prince_undivided",
					["commander_key"] = "chs_prince"
				}
			},
			["nur_starting_enemy"] = {
				[1] = {
					["difficulty_delta"] = 0,
					["agent_subtype"] = "wh3_dlc20_chs_sorcerer_lord_nurgle_mnur",
					["commander_key"] = "nur_starting_enemy"
				}
			},
			["sla_starting_enemy"] = {
				[1] = {
					["difficulty_delta"] = 0,
					["agent_subtype"] = "wh3_dlc20_chs_lord_msla",
					["commander_key"] = "sla_starting_enemy"
				}
			},
			["kho_valkia_easy"] = {
				[1] = {
					["difficulty_delta"] = 10,
					["agent_subtype"] = "wh3_dlc20_kho_valkia",
					["commander_key"] = "kho_valkia_easy"
				}
			},
			["kho_lord_easy"] = {

			},
			["tze_starting_enemy"] = {
				[1] = {
					["difficulty_delta"] = 0,
					["agent_subtype"] = "wh3_dlc20_chs_sorcerer_lord_tzeentch_mtze",
					["commander_key"] = "tze_starting_enemy"
				}
			},
			["kho_starting_enemy"] = {
				[1] = {
					["difficulty_delta"] = 1,
					["agent_subtype"] = "wh3_dlc20_chs_lord_mkho",
					["commander_key"] = "kho_starting_enemy"
				}
			},
			["kho_random"] = {

			},
			["kho_herald"] = {

			},
			["kho_lord_all"] = {
				[1] = {
					["difficulty_delta"] = 1,
					["agent_subtype"] = "wh3_dlc20_chs_lord_mkho",
					["commander_key"] = "kho_lord_norm"
				},
				[2] = {
					["difficulty_delta"] = 1,
					["agent_subtype"] = "wh3_dlc20_chs_lord_mkho",
					["commander_key"] = "kho_lord_hard"
				}
			},
			["kho_prince"] = {

			},
			["kho_lord_hard"] = {
				[1] = {
					["difficulty_delta"] = 1,
					["agent_subtype"] = "wh3_dlc20_chs_lord_mkho",
					["commander_key"] = "kho_lord_hard"
				}
			},
			["kho_lord_norm"] = {
				[1] = {
					["difficulty_delta"] = 1,
					["agent_subtype"] = "wh3_dlc20_chs_lord_mkho",
					["commander_key"] = "kho_lord_norm"
				}
			},
			["kho_lord_norm_plus"] = {
				[1] = {
					["difficulty_delta"] = 1,
					["agent_subtype"] = "wh3_dlc20_chs_lord_mkho",
					["commander_key"] = "kho_lord_norm"
				},
				[2] = {
					["difficulty_delta"] = 1,
					["agent_subtype"] = "wh3_dlc20_chs_lord_mkho",
					["commander_key"] = "kho_lord_hard"
				}
			},
			["kho_greater_deamon"] = {

			}
		},
		["effect_bundle_lists"] = {

		},
		["reward_sets"] = {
			["daniel_starting_rewards"] = {
				[1] = {
					["dilemma"] = "rogue_start_all_dae",
					["resource_threshold"] = 0,
					["requires_resource"] = ""
				},
				[2] = {
					["dilemma"] = "rogue_start_kho_vs_sla",
					["resource_threshold"] = 0,
					["requires_resource"] = ""
				},
				[3] = {
					["dilemma"] = "rogue_start_tze_vs_kho",
					["resource_threshold"] = 0,
					["requires_resource"] = ""
				},
				[4] = {
					["dilemma"] = "rogue_start_sla_vs_nur",
					["resource_threshold"] = 0,
					["requires_resource"] = ""
				},
				[5] = {
					["dilemma"] = "rogue_start_nur_vs_tze",
					["resource_threshold"] = 0,
					["requires_resource"] = ""
				},
				[6] = {
					["dilemma"] = "rogue_start_chs_quality_vs_dae_quantity",
					["resource_threshold"] = 0,
					["requires_resource"] = ""
				},
				[7] = {
					["dilemma"] = "rogue_start_dae_quality_vs_chs_quantity",
					["resource_threshold"] = 0,
					["requires_resource"] = ""
				}
			},
			["daniel_intro_battle_rewards"] = {
				[1] = {
					["dilemma"] = "rogue_start_all_dae",
					["resource_threshold"] = 0,
					["requires_resource"] = ""
				},
				[2] = {
					["dilemma"] = "rogue_start_kho_vs_sla",
					["resource_threshold"] = 0,
					["requires_resource"] = ""
				},
				[3] = {
					["dilemma"] = "rogue_start_tze_vs_kho",
					["resource_threshold"] = 0,
					["requires_resource"] = ""
				},
				[4] = {
					["dilemma"] = "rogue_start_sla_vs_nur",
					["resource_threshold"] = 0,
					["requires_resource"] = ""
				},
				[5] = {
					["dilemma"] = "rogue_start_nur_vs_tze",
					["resource_threshold"] = 0,
					["requires_resource"] = ""
				},
				[6] = {
					["dilemma"] = "rogue_start_chs_quality_vs_dae_quantity",
					["resource_threshold"] = 0,
					["requires_resource"] = ""
				},
				[7] = {
					["dilemma"] = "rogue_start_dae_quality_vs_chs_quantity",
					["resource_threshold"] = 0,
					["requires_resource"] = ""
				}
			},
			["placeholder_reward_set"] = {
				[1] = {
					["dilemma"] = "rogue_blank_dilemma",
					["resource_threshold"] = 0,
					["requires_resource"] = ""
				}
			}
		},
		["progress_payloads"] = {
			["INTRO_COMPLETED_WEST"] = {
				["mandatory_gate_increments"] = {
					["INTRO_WEST_S1"] = 1
				},
				["generated_gate_increments"] = {

				},
				["key"] = "INTRO_COMPLETED_WEST"
			},
			["INTRODUCTION_ACT_COMPLETED"] = {
				["mandatory_gate_increments"] = {

				},
				["generated_gate_increments"] = {

				},
				["key"] = "INTRODUCTION_ACT_COMPLETED"
			},
			["START_BATTLE_COMPLETE"] = {
				["mandatory_gate_increments"] = {
					["INTRODUCTION"] = 1
				},
				["generated_gate_increments"] = {
					[1] = {
						["INTRO_WEST"] = 1,
						["INTRO_EAST"] = 1
					},
					[2] = {
						["INTRO_NORTH"] = 1,
						["INTRO_SOUTH"] = 1
					}
				},
				["key"] = "START_BATTLE_COMPLETE"
			},
			["INTRO_COMPLETED_EAST"] = {
				["mandatory_gate_increments"] = {
					["INTRO_EAST_S1"] = 1
				},
				["generated_gate_increments"] = {

				},
				["key"] = "INTRO_COMPLETED_EAST"
			},
			["EMPTY_PROGRESS_PAYLOAD"] = {
				["mandatory_gate_increments"] = {

				},
				["generated_gate_increments"] = {

				},
				["key"] = "EMPTY_PROGRESS_PAYLOAD"
			}
		},
		["player_characters"] = {
			["wh3_main_dae_daemon_prince"] = {
				["start_gate"] = "NEW_GAME_DANIEL",
				["start_reward_set"] = "daniel_starting_rewards"
			}
		},
		["armory_part_sets"] = {
			["tzeentch_2"] = {
				["mandatory_parts"] = {

				},
				["generated_part_slots"] = {
					[1] = {
						[1] = "wh3_main_dae_cha_daemon_prince_weapon_chosen_halberd_2",
						[2] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_sorcerer_staff_1",
						[3] = "wh3_main_dae_cha_daemon_prince_tail_snapping_6",
						[4] = "wh3_main_dae_cha_daemon_prince_arm_r_base_5",
						[5] = "wh3_main_dae_cha_daemon_prince_tail_snapping_1",
						[6] = "wh3_main_dae_cha_daemon_prince_legs_bird_8",
						[7] = "wh3_main_dae_cha_daemon_prince_torso_bird_3",
						[8] = "wh3_main_dae_cha_daemon_prince_tail_snapping_2",
						[9] = "wh3_main_dae_cha_daemon_prince_torso_bird_5",
						[10] = "wh3_main_dae_cha_daemon_prince_wings_bird_7",
						[11] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_knight_sword_3",
						[12] = "wh3_main_dae_cha_daemon_prince_tail_base_2"
					}
				},
				["key"] = "tzeentch_2",
				["upgrade_when_exhausted"] = "tzeentch_3"
			},
			["undivided_3"] = {
				["mandatory_parts"] = {

				},
				["generated_part_slots"] = {
					[1] = {
						[1] = "wh3_main_dae_cha_daemon_prince_arm_l_base_4",
						[2] = "wh3_main_dae_cha_daemon_prince_arm_r_base_4",
						[3] = "wh3_main_dae_cha_daemon_prince_wings_base_5",
						[4] = "wh3_main_dae_cha_daemon_prince_legs_base_3",
						[5] = "wh3_main_dae_cha_daemon_prince_tail_base_6",
						[6] = "wh3_main_dae_cha_daemon_prince_tail_base_3",
						[7] = "wh3_main_dae_cha_daemon_prince_wings_base_3",
						[8] = "wh3_main_dae_cha_daemon_prince_legs_base_6",
						[9] = "wh3_main_dae_cha_daemon_prince_weapon_soulgrinder_sword_1",
						[10] = "wh3_main_dae_cha_daemon_prince_wings_base_1",
						[11] = "wh3_main_dae_cha_daemon_prince_torso_base_8",
						[12] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_sword_3",
						[13] = "wh3_main_dae_cha_daemon_prince_head_base_6",
						[14] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_sword_2",
						[15] = "wh3_main_dae_cha_daemon_prince_legs_base_5",
						[16] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_sword_1",
						[17] = "wh3_main_dae_cha_daemon_prince_arm_l_base_2",
						[18] = "wh3_main_dae_cha_daemon_prince_arm_r_base_2"
					}
				},
				["key"] = "undivided_3",
				["upgrade_when_exhausted"] = "nurgle_2"
			},
			["tzeentch_3"] = {
				["mandatory_parts"] = {

				},
				["generated_part_slots"] = {
					[1] = {
						[1] = "wh3_main_dae_cha_daemon_prince_arm_l_bird_3",
						[2] = "wh3_main_dae_cha_daemon_prince_arm_r_bird_3",
						[3] = "wh3_main_dae_cha_daemon_prince_weapon_pink_horror_dagger_1",
						[4] = "wh3_main_dae_cha_daemon_prince_head_bird_3",
						[5] = "wh3_main_dae_cha_daemon_prince_legs_bird_3",
						[6] = "wh3_main_dae_cha_daemon_prince_wings_bird_2",
						[7] = "wh3_main_dae_cha_daemon_prince_arm_l_bird_2",
						[8] = "wh3_main_dae_cha_daemon_prince_arm_r_bird_2",
						[9] = "wh3_main_dae_cha_daemon_prince_weapon_doom_knight_shield_1",
						[10] = "wh3_main_dae_cha_daemon_prince_head_bird_2",
						[11] = "wh3_main_dae_cha_daemon_prince_legs_bird_2",
						[12] = "wh3_main_dae_cha_daemon_prince_weapon_exalted_lord_of_change_staff_2",
						[13] = "wh3_main_dae_cha_daemon_prince_legs_bird_1",
						[14] = "wh3_main_dae_cha_daemon_prince_tail_snapping_3",
						[15] = "wh3_main_dae_cha_daemon_prince_weapon_doom_knight_lance_1",
						[16] = "wh3_main_dae_cha_daemon_prince_arm_l_bird_1",
						[17] = "wh3_main_dae_cha_daemon_prince_arm_r_bird_1",
						[18] = "wh3_main_dae_cha_daemon_prince_head_bird_1",
						[19] = "wh3_main_dae_cha_daemon_prince_torso_base_5",
						[20] = "wh3_main_dae_cha_daemon_prince_weapon_exalted_lord_of_change_staff_1",
						[21] = "wh3_main_dae_cha_daemon_prince_wings_bird",
						[22] = "wh3_main_dae_cha_daemon_prince_head_bird_6",
						[23] = "wh3_main_dae_cha_daemon_prince_legs_bird_6",
						[24] = "wh3_main_dae_cha_daemon_prince_torso_bird_6",
						[25] = "wh3_main_dae_cha_daemon_prince_weapon_doom_knight_lance_3",
						[26] = "wh3_main_dae_cha_daemon_prince_legs_bird_5",
						[27] = "wh3_main_dae_cha_daemon_prince_weapon_doom_knight_shield_3",
						[28] = "wh3_main_dae_cha_daemon_prince_weapon_pink_horror_dagger_3",
						[29] = "wh3_main_dae_cha_daemon_prince_wings_bird_6",
						[30] = "wh3_main_dae_cha_daemon_prince_arm_l_bird_6",
						[31] = "wh3_main_dae_cha_daemon_prince_arm_r_bird_6",
						[32] = "wh3_main_dae_cha_daemon_prince_head_bird_5",
						[33] = "wh3_main_dae_cha_daemon_prince_torso_bird_4",
						[34] = "wh3_main_dae_cha_daemon_prince_legs_bird_4",
						[35] = "wh3_main_dae_cha_daemon_prince_weapon_doom_knight_shield_2",
						[36] = "wh3_main_dae_cha_daemon_prince_weapon_pink_horror_dagger_2",
						[37] = "wh3_main_dae_cha_daemon_prince_wings_bird_4",
						[38] = "wh3_main_dae_cha_daemon_prince_head_bird_4",
						[39] = "wh3_main_dae_cha_daemon_prince_torso_bird_2",
						[40] = "wh3_main_dae_cha_daemon_prince_weapon_doom_knight_lance_2",
						[41] = "wh3_main_dae_cha_daemon_prince_wings_bird_3"
					}
				},
				["key"] = "tzeentch_3",
				["upgrade_when_exhausted"] = ""
			},
			["khorne_3"] = {
				["mandatory_parts"] = {

				},
				["generated_part_slots"] = {
					[1] = {
						[1] = "wh3_main_dae_cha_daemon_prince_head_beast_4",
						[2] = "wh3_main_dae_cha_daemon_prince_legs_beast_3",
						[3] = "wh3_main_dae_cha_daemon_prince_torso_brasscollar_3",
						[4] = "wh3_main_dae_cha_daemon_prince_arm_l_armoured_1",
						[5] = "wh3_main_dae_cha_daemon_prince_arm_r_armoured_1",
						[6] = "wh3_main_dae_cha_daemon_prince_weapon_bloodthirster_axe_2",
						[7] = "wh3_main_dae_cha_daemon_prince_legs_beast_1",
						[8] = "wh3_main_dae_cha_daemon_prince_weapon_skullcrusher_halberd_2",
						[9] = "wh3_main_dae_cha_daemon_prince_wings_beast_3",
						[10] = "wh3_main_dae_cha_daemon_prince_legs_beast_4",
						[11] = "wh3_main_dae_cha_daemon_prince_weapon_skullcrusher_shield_1",
						[12] = "wh3_main_dae_cha_daemon_prince_wings_beast_5",
						[13] = "wh3_main_dae_cha_daemon_prince_legs_beast_2",
						[14] = "wh3_main_dae_cha_daemon_prince_torso_magical_heavy_2",
						[15] = "wh3_main_dae_cha_daemon_prince_weapon_bloodthirster_axe_1",
						[16] = "wh3_main_dae_cha_daemon_prince_tail_living_1",
						[17] = "wh3_main_dae_cha_daemon_prince_weapon_bloodthirster_great_axe_1",
						[18] = "wh3_main_dae_cha_daemon_prince_weapon_skullcrusher_halberd_1",
						[19] = "wh3_main_dae_cha_daemon_prince_torso_base_2",
						[20] = "wh3_main_dae_cha_daemon_prince_weapon_bloodletter_sword_1",
						[21] = "wh3_main_dae_cha_daemon_prince_weapon_bloodthirster_axe_3",
						[22] = "wh3_main_dae_cha_daemon_prince_weapon_bloodthirster_great_axe_2",
						[23] = "wh3_main_dae_cha_daemon_prince_weapon_skullcrusher_shield_3",
						[24] = "wh3_main_dae_cha_daemon_prince_legs_beast_5",
						[25] = "wh3_main_dae_cha_daemon_prince_tail_living_6",
						[26] = "wh3_main_dae_cha_daemon_prince_weapon_skullcrusher_halberd_3",
						[27] = "wh3_main_dae_cha_daemon_prince_head_beast_6",
						[28] = "wh3_main_dae_cha_daemon_prince_torso_brasscollar_6",
						[29] = "wh3_main_dae_cha_daemon_prince_weapon_bloodthirster_great_axe_3",
						[30] = "wh3_main_dae_cha_daemon_prince_arm_l_armoured_6",
						[31] = "wh3_main_dae_cha_daemon_prince_arm_r_armoured_6",
						[32] = "wh3_main_dae_cha_daemon_prince_legs_beast_6",
						[33] = "wh3_main_dae_cha_daemon_prince_weapon_bloodletter_sword_2",
						[34] = "wh3_main_dae_cha_daemon_prince_weapon_bloodletter_sword_3",
						[35] = "wh3_main_dae_cha_daemon_prince_weapon_skullcrusher_shield_2"
					}
				},
				["key"] = "khorne_3",
				["upgrade_when_exhausted"] = ""
			},
			["nurgle_2"] = {
				["mandatory_parts"] = {

				},
				["generated_part_slots"] = {
					[1] = {
						[1] = "wh3_main_dae_cha_daemon_prince_head_base_9",
						[2] = "wh3_main_dae_cha_daemon_prince_weapon_dragon_ogre_hammer_1",
						[3] = "wh3_main_dae_cha_daemon_prince_tail_corpulent_6",
						[4] = "wh3_main_dae_cha_daemon_prince_wings_corpulent_2",
						[5] = "wh3_main_dae_cha_daemon_prince_torso_magical_heavy_4",
						[6] = "wh3_main_dae_cha_daemon_prince_legs_corpulent_7",
						[7] = "wh3_main_dae_cha_daemon_prince_weapon_dragon_ogre_shaggoth_axe_1",
						[8] = "wh3_main_dae_cha_daemon_prince_torso_magical_heavy_6",
						[9] = "wh3_main_dae_cha_daemon_prince_weapon_chosen_halberd_3",
						[10] = "wh3_main_dae_cha_daemon_prince_torso_magical_medium_4",
						[11] = "wh3_main_dae_cha_daemon_prince_weapon_dragon_ogre_hammer_4",
						[12] = "wh3_main_dae_cha_daemon_prince_wings_corpulent_6"
					}
				},
				["key"] = "nurgle_2",
				["upgrade_when_exhausted"] = ""
			},
			["nurgle_1"] = {
				["mandatory_parts"] = {

				},
				["generated_part_slots"] = {
					[1] = {
						[1] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_warrior_sword_5",
						[2] = "wh3_main_dae_cha_daemon_prince_arm_r_corpulent_6",
						[3] = "wh3_main_dae_cha_daemon_prince_weapon_dragon_ogre_hammer_3",
						[4] = "wh3_main_dae_cha_daemon_prince_arm_l_corpulent_5",
						[5] = "wh3_main_dae_cha_daemon_prince_head_base_8",
						[6] = "wh3_main_dae_cha_daemon_prince_tail_corpulent_3",
						[7] = "wh3_main_dae_cha_daemon_prince_wings_corpulent",
						[8] = "wh3_main_dae_cha_daemon_prince_head_base_7",
						[9] = "wh3_main_dae_cha_daemon_prince_wings_corpulent_3",
						[10] = "wh3_main_dae_cha_daemon_prince_arm_r_corpulent_5",
						[11] = "wh3_main_dae_cha_daemon_prince_arm_l_corpulent_6",
						[12] = "wh3_main_dae_cha_daemon_prince_torso_magical_medium_6",
						[13] = "wh3_main_dae_cha_daemon_prince_legs_corpulent_6",
						[14] = "wh3_main_dae_cha_daemon_prince_head_base_11"
					}
				},
				["key"] = "nurgle_1",
				["upgrade_when_exhausted"] = "nurgle_3"
			},
			["slaanesh_3"] = {
				["mandatory_parts"] = {

				},
				["generated_part_slots"] = {
					[1] = {
						[1] = "wh3_main_dae_cha_daemon_prince_arm_l_scythe_6",
						[2] = "wh3_main_dae_cha_daemon_prince_arm_r_base_3",
						[3] = "wh3_main_dae_cha_daemon_prince_torso_adornedarmour_3",
						[4] = "wh3_main_dae_cha_daemon_prince_head_adornedhelmet_3",
						[5] = "wh3_main_dae_cha_daemon_prince_legs_daemonette_3",
						[6] = "wh3_main_dae_cha_daemon_prince_tail_fiend_5",
						[7] = "wh3_main_dae_cha_daemon_prince_arm_l_scythe_4",
						[8] = "wh3_main_dae_cha_daemon_prince_arm_r_scythe_4",
						[9] = "wh3_main_dae_cha_daemon_prince_torso_adornedarmour_2",
						[10] = "wh3_main_dae_cha_daemon_prince_head_adornedhelmet_2",
						[11] = "wh3_main_dae_cha_daemon_prince_legs_daemonette_2",
						[12] = "wh3_main_dae_cha_daemon_prince_torso_adornedarmour_1",
						[13] = "wh3_main_dae_cha_daemon_prince_arm_l_scythe_5",
						[14] = "wh3_main_dae_cha_daemon_prince_arm_r_scythe_5",
						[15] = "wh3_main_dae_cha_daemon_prince_legs_daemonette_1",
						[16] = "wh3_main_dae_cha_daemon_prince_arm_l_scythe_2",
						[17] = "wh3_main_dae_cha_daemon_prince_arm_r_scythe_2",
						[18] = "wh3_main_dae_cha_daemon_prince_head_adornedhelmet_1",
						[19] = "wh3_main_dae_cha_daemon_prince_arm_l_base_3",
						[20] = "wh3_main_dae_cha_daemon_prince_arm_r_scythe_6",
						[21] = "wh3_main_dae_cha_daemon_prince_torso_base_4",
						[22] = "wh3_main_dae_cha_daemon_prince_head_adornedhelmet_6",
						[23] = "wh3_main_dae_cha_daemon_prince_tail_fiend_3",
						[24] = "wh3_main_dae_cha_daemon_prince_torso_adornedarmour_6",
						[25] = "wh3_main_dae_cha_daemon_prince_weapon_exalted_keeper_of_secrets_spear_1",
						[26] = "wh3_main_dae_cha_daemon_prince_legs_daemonette_6",
						[27] = "wh3_main_dae_cha_daemon_prince_torso_adornedarmour_5",
						[28] = "wh3_main_dae_cha_daemon_prince_weapon_exalted_keeper_of_secrets_shield_1",
						[29] = "wh3_main_dae_cha_daemon_prince_weapon_keeper_of_secrets_sword_2",
						[30] = "wh3_main_dae_cha_daemon_prince_head_adornedhelmet_5",
						[31] = "wh3_main_dae_cha_daemon_prince_tail_fiend_2",
						[32] = "wh3_main_dae_cha_daemon_prince_weapon_exalted_keeper_of_secrets_shield_3",
						[33] = "wh3_main_dae_cha_daemon_prince_weapon_keeper_of_secrets_sword_3",
						[34] = "wh3_main_dae_cha_daemon_prince_legs_daemonette_5",
						[35] = "wh3_main_dae_cha_daemon_prince_torso_adornedarmour_4",
						[36] = "wh3_main_dae_cha_daemon_prince_weapon_exalted_keeper_of_secrets_shield_2",
						[37] = "wh3_main_dae_cha_daemon_prince_weapon_keeper_of_secrets_sword_1",
						[38] = "wh3_main_dae_cha_daemon_prince_head_adornedhelmet_4",
						[39] = "wh3_main_dae_cha_daemon_prince_legs_daemonette_4",
						[40] = "wh3_main_dae_cha_daemon_prince_tail_fiend_6"
					}
				},
				["key"] = "slaanesh_3",
				["upgrade_when_exhausted"] = ""
			},
			["khorne_1"] = {
				["mandatory_parts"] = {

				},
				["generated_part_slots"] = {
					[1] = {
						[1] = "wh3_main_dae_cha_daemon_prince_arm_r_armoured_2",
						[2] = "wh3_main_dae_cha_daemon_prince_legs_beast_7",
						[3] = "wh3_main_dae_cha_daemon_prince_wings_beast",
						[4] = "wh3_main_dae_cha_daemon_prince_arm_l_armoured_4",
						[5] = "wh3_main_dae_cha_daemon_prince_head_beast_2",
						[6] = "wh3_main_dae_cha_daemon_prince_tail_living_2",
						[7] = "wh3_main_dae_cha_daemon_prince_torso_brasscollar_1",
						[8] = "wh3_main_dae_cha_daemon_prince_tail_living_4",
						[9] = "wh3_main_dae_cha_daemon_prince_wings_beast_4",
						[10] = "wh3_main_dae_cha_daemon_prince_legs_beast_8",
						[11] = "wh3_main_dae_cha_daemon_prince_head_beast_1",
						[12] = "wh3_main_dae_cha_daemon_prince_arm_l_armoured_2",
						[13] = "wh3_main_dae_cha_daemon_prince_torso_brasscollar_4",
						[14] = "wh3_main_dae_cha_daemon_prince_tail_living_5"
					}
				},
				["key"] = "khorne_1",
				["upgrade_when_exhausted"] = "khorne_2"
			},
			["slaanesh_2"] = {
				["mandatory_parts"] = {

				},
				["generated_part_slots"] = {
					[1] = {
						[1] = "wh3_main_dae_cha_daemon_prince_wings_sensuous_4",
						[2] = "wh3_main_dae_cha_daemon_prince_torso_magical_medium_3",
						[3] = "wh3_main_dae_cha_daemon_prince_arm_r_scythe_3",
						[4] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_shield_3",
						[5] = "wh3_main_dae_cha_daemon_prince_head_adornedhelmet_7",
						[6] = "wh3_main_dae_cha_daemon_prince_tail_fiend_1",
						[7] = "wh3_main_dae_cha_daemon_prince_wings_sensuous_5",
						[8] = "wh3_main_dae_cha_daemon_prince_wings_sensuous_6",
						[9] = "wh3_main_dae_cha_daemon_prince_weapon_chosen_halberd_1",
						[10] = "wh3_main_dae_cha_daemon_prince_wings_sensuous",
						[11] = "wh3_main_dae_cha_daemon_prince_torso_magical_heavy_3",
						[12] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_warrior_sword_3"
					}
				},
				["key"] = "slaanesh_2",
				["upgrade_when_exhausted"] = "slaanesh_3"
			},
			["tzeentch_1"] = {
				["mandatory_parts"] = {

				},
				["generated_part_slots"] = {
					[1] = {
						[1] = "wh3_main_dae_cha_daemon_prince_legs_bird_7",
						[2] = "wh3_main_dae_cha_daemon_prince_wings_bird_5",
						[3] = "wh3_main_dae_cha_daemon_prince_torso_bird_1",
						[4] = "wh3_main_dae_cha_daemon_prince_arm_l_bird_4",
						[5] = "wh3_main_dae_cha_daemon_prince_head_bird_7",
						[6] = "wh3_main_dae_cha_daemon_prince_arm_r_bird_4",
						[7] = "wh3_main_dae_cha_daemon_prince_tail_snapping_4",
						[8] = "wh3_main_dae_cha_daemon_prince_arm_l_base_5",
						[9] = "wh3_main_dae_cha_daemon_prince_arm_r_bird_5",
						[10] = "wh3_main_dae_cha_daemon_prince_torso_magical_medium_5",
						[11] = "wh3_main_dae_cha_daemon_prince_tail_snapping_5",
						[12] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_sorcerer_staff_2",
						[13] = "wh3_main_dae_cha_daemon_prince_arm_l_bird_5",
						[14] = "wh3_main_dae_cha_daemon_prince_head_bird_8"
					}
				},
				["key"] = "tzeentch_1",
				["upgrade_when_exhausted"] = "tzeentch_2"
			},
			["undivided_1"] = {
				["mandatory_parts"] = {

				},
				["generated_part_slots"] = {
					[1] = {
						[1] = "wh3_main_dae_cha_daemon_prince_arm_l_base_6",
						[2] = "wh3_main_dae_cha_daemon_prince_wings_base_6",
						[3] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_shield_2",
						[4] = "wh3_main_dae_cha_daemon_prince_legs_base_2",
						[5] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_warrior_sword_2",
						[6] = "wh3_main_dae_cha_daemon_prince_head_base_2",
						[7] = "wh3_main_dae_cha_daemon_prince_torso_magical_medium_2",
						[8] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_knight_sword_1",
						[9] = "wh3_main_dae_cha_daemon_prince_torso_base_6",
						[10] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_shield_1",
						[11] = "wh3_main_dae_cha_daemon_prince_torso_base_10",
						[12] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_sorcerer_staff_3",
						[13] = "wh3_main_dae_cha_daemon_prince_arm_r_base_6",
						[14] = "wh3_main_dae_cha_daemon_prince_tail_base_5"
					}
				},
				["key"] = "undivided_1",
				["upgrade_when_exhausted"] = "undivided_2"
			},
			["khorne_2"] = {
				["mandatory_parts"] = {

				},
				["generated_part_slots"] = {
					[1] = {
						[1] = "wh3_main_dae_cha_daemon_prince_head_beast_5",
						[2] = "wh3_main_dae_cha_daemon_prince_arm_r_armoured_4",
						[3] = "wh3_main_dae_cha_daemon_prince_tail_living_3",
						[4] = "wh3_main_dae_cha_daemon_prince_torso_brasscollar_2",
						[5] = "wh3_main_dae_cha_daemon_prince_arm_r_armoured_5",
						[6] = "wh3_main_dae_cha_daemon_prince_wings_beast_6",
						[7] = "wh3_main_dae_cha_daemon_prince_arm_l_armoured_5",
						[8] = "wh3_main_dae_cha_daemon_prince_torso_brasscollar_5",
						[9] = "wh3_main_dae_cha_daemon_prince_arm_r_armoured_3",
						[10] = "wh3_main_dae_cha_daemon_prince_head_beast_3",
						[11] = "wh3_main_dae_cha_daemon_prince_arm_l_armoured_3",
						[12] = "wh3_main_dae_cha_daemon_prince_wings_beast_2"
					}
				},
				["key"] = "khorne_2",
				["upgrade_when_exhausted"] = "khorne_3"
			},
			["undivided_2"] = {
				["mandatory_parts"] = {

				},
				["generated_part_slots"] = {
					[1] = {
						[1] = "wh3_main_dae_cha_daemon_prince_torso_base_9",
						[2] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_warrior_sword_1",
						[3] = "wh3_main_dae_cha_daemon_prince_tail_base_4",
						[4] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_knight_lance_1",
						[5] = "wh3_main_dae_cha_daemon_prince_head_base_4",
						[6] = "wh3_main_dae_cha_daemon_prince_torso_base_7",
						[7] = "wh3_main_dae_cha_daemon_prince_legs_base_4",
						[8] = "wh3_main_dae_cha_daemon_prince_torso_magical_heavy_5",
						[9] = "wh3_main_dae_cha_daemon_prince_head_base_5",
						[10] = "wh3_main_dae_cha_daemon_prince_wings_base_4",
						[11] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_knight_lance_2",
						[12] = "wh3_main_dae_cha_daemon_prince_head_base_3"
					}
				},
				["key"] = "undivided_2",
				["upgrade_when_exhausted"] = "undivided_3"
			},
			["any_2"] = {
				["mandatory_parts"] = {

				},
				["generated_part_slots"] = {

				},
				["key"] = "any_2",
				["upgrade_when_exhausted"] = "any_3"
			},
			["any_3"] = {
				["mandatory_parts"] = {

				},
				["generated_part_slots"] = {

				},
				["key"] = "any_3",
				["upgrade_when_exhausted"] = ""
			},
			["any_1"] = {
				["mandatory_parts"] = {

				},
				["generated_part_slots"] = {
					[1] = {
						[1] = "wh3_main_dae_cha_daemon_prince_arm_r_armoured_2",
						[2] = "wh3_main_dae_cha_daemon_prince_legs_beast_7",
						[3] = "wh3_main_dae_cha_daemon_prince_wings_beast",
						[4] = "wh3_main_dae_cha_daemon_prince_arm_l_armoured_4",
						[5] = "wh3_main_dae_cha_daemon_prince_head_beast_2",
						[6] = "wh3_main_dae_cha_daemon_prince_tail_living_2",
						[7] = "wh3_main_dae_cha_daemon_prince_torso_brasscollar_1",
						[8] = "wh3_main_dae_cha_daemon_prince_tail_living_4",
						[9] = "wh3_main_dae_cha_daemon_prince_wings_beast_4",
						[10] = "wh3_main_dae_cha_daemon_prince_legs_beast_8",
						[11] = "wh3_main_dae_cha_daemon_prince_head_beast_1",
						[12] = "wh3_main_dae_cha_daemon_prince_arm_l_armoured_2",
						[13] = "wh3_main_dae_cha_daemon_prince_torso_brasscollar_4",
						[14] = "wh3_main_dae_cha_daemon_prince_tail_living_5",
						[15] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_warrior_sword_5",
						[16] = "wh3_main_dae_cha_daemon_prince_arm_r_corpulent_6",
						[17] = "wh3_main_dae_cha_daemon_prince_weapon_dragon_ogre_hammer_3",
						[18] = "wh3_main_dae_cha_daemon_prince_arm_l_corpulent_5",
						[19] = "wh3_main_dae_cha_daemon_prince_head_base_8",
						[20] = "wh3_main_dae_cha_daemon_prince_tail_corpulent_3",
						[21] = "wh3_main_dae_cha_daemon_prince_wings_corpulent",
						[22] = "wh3_main_dae_cha_daemon_prince_head_base_7",
						[23] = "wh3_main_dae_cha_daemon_prince_wings_corpulent_3",
						[24] = "wh3_main_dae_cha_daemon_prince_arm_r_corpulent_5",
						[25] = "wh3_main_dae_cha_daemon_prince_arm_l_corpulent_6",
						[26] = "wh3_main_dae_cha_daemon_prince_torso_magical_medium_6",
						[27] = "wh3_main_dae_cha_daemon_prince_legs_corpulent_6",
						[28] = "wh3_main_dae_cha_daemon_prince_head_base_11",
						[29] = "wh3_main_dae_cha_daemon_prince_tail_fiend_4",
						[30] = "wh3_main_dae_cha_daemon_prince_torso_magical_medium_1",
						[31] = "wh3_main_dae_cha_daemon_prince_weapon_dragon_ogre_hammer_2",
						[32] = "wh3_main_dae_cha_daemon_prince_head_adornedhelmet_8",
						[33] = "wh3_main_dae_cha_daemon_prince_wings_sensuous_3",
						[34] = "wh3_main_dae_cha_daemon_prince_arm_r_scythe_1",
						[35] = "wh3_main_dae_cha_daemon_prince_legs_daemonette_7",
						[36] = "wh3_main_dae_cha_daemon_prince_torso_magical_heavy_1",
						[37] = "wh3_main_dae_cha_daemon_prince_arm_l_scythe_3",
						[38] = "wh3_main_dae_cha_daemon_prince_legs_daemonette_8",
						[39] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_knight_lance_3",
						[40] = "wh3_main_dae_cha_daemon_prince_wings_sensuous_2",
						[41] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_knight_sword_2",
						[42] = "wh3_main_dae_cha_daemon_prince_arm_l_scythe_1",
						[43] = "wh3_main_dae_cha_daemon_prince_legs_bird_7",
						[44] = "wh3_main_dae_cha_daemon_prince_wings_bird_5",
						[45] = "wh3_main_dae_cha_daemon_prince_torso_bird_1",
						[46] = "wh3_main_dae_cha_daemon_prince_arm_l_bird_4",
						[47] = "wh3_main_dae_cha_daemon_prince_head_bird_7",
						[48] = "wh3_main_dae_cha_daemon_prince_arm_r_bird_4",
						[49] = "wh3_main_dae_cha_daemon_prince_tail_snapping_4",
						[50] = "wh3_main_dae_cha_daemon_prince_arm_l_base_5",
						[51] = "wh3_main_dae_cha_daemon_prince_arm_r_bird_5",
						[52] = "wh3_main_dae_cha_daemon_prince_torso_magical_medium_5",
						[53] = "wh3_main_dae_cha_daemon_prince_tail_snapping_5",
						[54] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_sorcerer_staff_2",
						[55] = "wh3_main_dae_cha_daemon_prince_arm_l_bird_5",
						[56] = "wh3_main_dae_cha_daemon_prince_head_bird_8",
						[57] = "wh3_main_dae_cha_daemon_prince_arm_l_base_6",
						[58] = "wh3_main_dae_cha_daemon_prince_wings_base_6",
						[59] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_shield_2",
						[60] = "wh3_main_dae_cha_daemon_prince_legs_base_2",
						[61] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_warrior_sword_2",
						[62] = "wh3_main_dae_cha_daemon_prince_head_base_2",
						[63] = "wh3_main_dae_cha_daemon_prince_torso_magical_medium_2",
						[64] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_knight_sword_1",
						[65] = "wh3_main_dae_cha_daemon_prince_torso_base_6",
						[66] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_shield_1",
						[67] = "wh3_main_dae_cha_daemon_prince_torso_base_10",
						[68] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_sorcerer_staff_3",
						[69] = "wh3_main_dae_cha_daemon_prince_arm_r_base_6",
						[70] = "wh3_main_dae_cha_daemon_prince_tail_base_5"
					}
				},
				["key"] = "any_1",
				["upgrade_when_exhausted"] = "any_2"
			},
			["slaanesh_1"] = {
				["mandatory_parts"] = {

				},
				["generated_part_slots"] = {
					[1] = {
						[1] = "wh3_main_dae_cha_daemon_prince_tail_fiend_4",
						[2] = "wh3_main_dae_cha_daemon_prince_torso_magical_medium_1",
						[3] = "wh3_main_dae_cha_daemon_prince_weapon_dragon_ogre_hammer_2",
						[4] = "wh3_main_dae_cha_daemon_prince_head_adornedhelmet_8",
						[5] = "wh3_main_dae_cha_daemon_prince_wings_sensuous_3",
						[6] = "wh3_main_dae_cha_daemon_prince_arm_r_scythe_1",
						[7] = "wh3_main_dae_cha_daemon_prince_legs_daemonette_7",
						[8] = "wh3_main_dae_cha_daemon_prince_torso_magical_heavy_1",
						[9] = "wh3_main_dae_cha_daemon_prince_arm_l_scythe_3",
						[10] = "wh3_main_dae_cha_daemon_prince_legs_daemonette_8",
						[11] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_knight_lance_3",
						[12] = "wh3_main_dae_cha_daemon_prince_wings_sensuous_2",
						[13] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_knight_sword_2",
						[14] = "wh3_main_dae_cha_daemon_prince_arm_l_scythe_1"
					}
				},
				["key"] = "slaanesh_1",
				["upgrade_when_exhausted"] = "slaanesh_2"
			},
			["nurgle_3"] = {
				["mandatory_parts"] = {

				},
				["generated_part_slots"] = {
					[1] = {
						[1] = "wh3_main_dae_cha_daemon_prince_arm_l_corpulent_3",
						[2] = "wh3_main_dae_cha_daemon_prince_arm_r_corpulent_3",
						[3] = "wh3_main_dae_cha_daemon_prince_tail_corpulent_4",
						[4] = "wh3_main_dae_cha_daemon_prince_head_corpulent_3",
						[5] = "wh3_main_dae_cha_daemon_prince_torso_corpulent_3",
						[6] = "wh3_main_dae_cha_daemon_prince_weapon_great_unclean_one_sword_1",
						[7] = "wh3_main_dae_cha_daemon_prince_arm_l_corpulent_2",
						[8] = "wh3_main_dae_cha_daemon_prince_arm_r_corpulent_2",
						[9] = "wh3_main_dae_cha_daemon_prince_torso_corpulent_2",
						[10] = "wh3_main_dae_cha_daemon_prince_head_corpulent_2",
						[11] = "wh3_main_dae_cha_daemon_prince_legs_corpulent_2",
						[12] = "wh3_main_dae_cha_daemon_prince_tail_corpulent_2",
						[13] = "wh3_main_dae_cha_daemon_prince_arm_l_corpulent_1",
						[14] = "wh3_main_dae_cha_daemon_prince_head_corpulent_1",
						[15] = "wh3_main_dae_cha_daemon_prince_weapon_cultist_club_1",
						[16] = "wh3_main_dae_cha_daemon_prince_legs_corpulent_1",
						[17] = "wh3_main_dae_cha_daemon_prince_tail_corpulent_1",
						[18] = "wh3_main_dae_cha_daemon_prince_torso_corpulent_1",
						[19] = "wh3_main_dae_cha_daemon_prince_arm_r_corpulent_1",
						[20] = "wh3_main_dae_cha_daemon_prince_head_base_10",
						[21] = "wh3_main_dae_cha_daemon_prince_torso_base_3",
						[22] = "wh3_main_dae_cha_daemon_prince_head_corpulent_6",
						[23] = "wh3_main_dae_cha_daemon_prince_torso_corpulent_6",
						[24] = "wh3_main_dae_cha_daemon_prince_weapon_exalted_great_unclean_one_bell_1",
						[25] = "wh3_main_dae_cha_daemon_prince_weapon_great_unclean_one_sword_3",
						[26] = "wh3_main_dae_cha_daemon_prince_legs_corpulent_5",
						[27] = "wh3_main_dae_cha_daemon_prince_tail_corpulent_5",
						[28] = "wh3_main_dae_cha_daemon_prince_torso_corpulent_5",
						[29] = "wh3_main_dae_cha_daemon_prince_wings_corpulent_5",
						[30] = "wh3_main_dae_cha_daemon_prince_head_corpulent_5",
						[31] = "wh3_main_dae_cha_daemon_prince_legs_corpulent_4",
						[32] = "wh3_main_dae_cha_daemon_prince_torso_corpulent_4",
						[33] = "wh3_main_dae_cha_daemon_prince_weapon_cultist_club_2",
						[34] = "wh3_main_dae_cha_daemon_prince_arm_l_corpulent_4",
						[35] = "wh3_main_dae_cha_daemon_prince_arm_r_corpulent_4",
						[36] = "wh3_main_dae_cha_daemon_prince_wings_corpulent_4",
						[37] = "wh3_main_dae_cha_daemon_prince_head_corpulent_4",
						[38] = "wh3_main_dae_cha_daemon_prince_legs_corpulent_3",
						[39] = "wh3_main_dae_cha_daemon_prince_weapon_great_unclean_one_sword_2"
					}
				},
				["key"] = "nurgle_3",
				["upgrade_when_exhausted"] = ""
			}
		},
		["force_fragment_sets"] = {
			["SPECIAL_MIRROR"] = {
				["mandatory_fragments"] = {

				},
				["key"] = "SPECIAL_MIRROR",
				["generated_fragment_slots"] = {

				}
			},
			["start_army_dae_tzeentch"] = {
				["mandatory_fragments"] = {

				},
				["key"] = "start_army_dae_tzeentch",
				["generated_fragment_slots"] = {

				}
			},
			["starting_battle_kho"] = {
				["mandatory_fragments"] = {
					[1] = {
						["force_fragment_key"] = "kho_warriors_2",
						["hidden_fragment"] = false
					}
				},
				["key"] = "starting_battle_kho",
				["generated_fragment_slots"] = {
					[1] = {
						[1] = {
							["force_fragment_key"] = "kho_warriors_2",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "kho_marauders_3",
							["hidden_fragment"] = false
						},
						[3] = {
							["force_fragment_key"] = "kho_forsaken_2",
							["hidden_fragment"] = false
						}
					},
					[2] = {
						[1] = {
							["force_fragment_key"] = "kho_marauder_horse_2",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "kho_chariot_1",
							["hidden_fragment"] = false
						},
						[3] = {
							["force_fragment_key"] = "kho_warhounds_2",
							["hidden_fragment"] = false
						}
					},
					[3] = {
						[1] = {
							["force_fragment_key"] = "kho_fleshhounds_1",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "kho_gorebeast_1",
							["hidden_fragment"] = false
						}
					}
				}
			},
			["start_army_chs_tzeentch"] = {
				["mandatory_fragments"] = {
					[1] = {
						["force_fragment_key"] = "tze_marauders_3",
						["hidden_fragment"] = false
					}
				},
				["key"] = "start_army_chs_tzeentch",
				["generated_fragment_slots"] = {
					[1] = {
						[1] = {
							["force_fragment_key"] = "tze_forsaken_2",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "tze_warriors_2",
							["hidden_fragment"] = false
						}
					},
					[2] = {
						[1] = {
							["force_fragment_key"] = "tze_spawn_1",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "tze_chariot_1",
							["hidden_fragment"] = false
						}
					},
					[3] = {
						[1] = {
							["force_fragment_key"] = "tze_spawn_1",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "tze_cultist_easy",
							["hidden_fragment"] = false
						}
					}
				}
			},
			["start_army_chs_khorne"] = {
				["mandatory_fragments"] = {
					[1] = {
						["force_fragment_key"] = "kho_marauders_3",
						["hidden_fragment"] = false
					}
				},
				["key"] = "start_army_chs_khorne",
				["generated_fragment_slots"] = {
					[1] = {
						[1] = {
							["force_fragment_key"] = "kho_forsaken_2",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "kho_warriors_2",
							["hidden_fragment"] = false
						}
					},
					[2] = {
						[1] = {
							["force_fragment_key"] = "kho_fleshhounds_1",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "kho_warhounds_2",
							["hidden_fragment"] = false
						}
					},
					[3] = {
						[1] = {
							["force_fragment_key"] = "kho_gorebeast_1",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "kho_cultist_easy",
							["hidden_fragment"] = false
						}
					}
				}
			},
			["start_army_chs_undivided_quantity"] = {
				["mandatory_fragments"] = {

				},
				["key"] = "start_army_chs_undivided_quantity",
				["generated_fragment_slots"] = {

				}
			},
			["start_army_chs_slaanesh"] = {
				["mandatory_fragments"] = {
					[1] = {
						["force_fragment_key"] = "sla_marauders_3",
						["hidden_fragment"] = false
					}
				},
				["key"] = "start_army_chs_slaanesh",
				["generated_fragment_slots"] = {
					[1] = {
						[1] = {
							["force_fragment_key"] = "sla_forsaken_2",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "sla_warriors_2",
							["hidden_fragment"] = false
						}
					},
					[2] = {
						[1] = {
							["force_fragment_key"] = "sla_hellstriders_2",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "sla_chariot_1",
							["hidden_fragment"] = false
						},
						[3] = {
							["force_fragment_key"] = "sla_marauder_horse_2",
							["hidden_fragment"] = false
						}
					},
					[3] = {
						[1] = {
							["force_fragment_key"] = "sla_chariot_2",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "sla_cultist_easy",
							["hidden_fragment"] = false
						}
					}
				}
			},
			["start_army_dae_slaanesh"] = {
				["mandatory_fragments"] = {
					[1] = {
						["force_fragment_key"] = "sla_daemonette_2",
						["hidden_fragment"] = false
					}
				},
				["key"] = "start_army_dae_slaanesh",
				["generated_fragment_slots"] = {
					[1] = {
						[1] = {
							["force_fragment_key"] = "sla_seekers_1",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "sla_seeker_chariot_1",
							["hidden_fragment"] = false
						}
					},
					[2] = {
						[1] = {
							["force_fragment_key"] = "sla_fiends_1",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "sla_seekers_1",
							["hidden_fragment"] = false
						},
						[3] = {
							["force_fragment_key"] = "sla_seeker_chariot_1",
							["hidden_fragment"] = false
						},
						[4] = {
							["force_fragment_key"] = "sla_furies_2",
							["hidden_fragment"] = false
						}
					},
					[3] = {
						[1] = {
							["force_fragment_key"] = "sla_ex_daemonette_1",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "sla_daemonette_2",
							["hidden_fragment"] = false
						}
					}
				}
			},
			["kho_chaos_warband_easy"] = {
				["mandatory_fragments"] = {

				},
				["key"] = "kho_chaos_warband_easy",
				["generated_fragment_slots"] = {

				}
			},
			["start_army_dae_undivided_quantity"] = {
				["mandatory_fragments"] = {

				},
				["key"] = "start_army_dae_undivided_quantity",
				["generated_fragment_slots"] = {

				}
			},
			["start_army_chs_nurgle"] = {
				["mandatory_fragments"] = {
					[1] = {
						["force_fragment_key"] = "nur_marauders_3",
						["hidden_fragment"] = false
					}
				},
				["key"] = "start_army_chs_nurgle",
				["generated_fragment_slots"] = {
					[1] = {
						[1] = {
							["force_fragment_key"] = "nur_forsaken_2",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "nur_warriors_2",
							["hidden_fragment"] = false
						}
					},
					[2] = {
						[1] = {
							["force_fragment_key"] = "nur_toads_2",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "nurglings_2",
							["hidden_fragment"] = false
						}
					},
					[3] = {
						[1] = {
							["force_fragment_key"] = "nur_chariot_1",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "nur_cultist_easy",
							["hidden_fragment"] = false
						}
					}
				}
			},
			["starting_battle_sla"] = {
				["mandatory_fragments"] = {
					[1] = {
						["force_fragment_key"] = "sla_daemonette_1",
						["hidden_fragment"] = false
					},
					[2] = {
						["force_fragment_key"] = "sla_marauders_3",
						["hidden_fragment"] = false
					}
				},
				["key"] = "starting_battle_sla",
				["generated_fragment_slots"] = {
					[1] = {
						[1] = {
							["force_fragment_key"] = "sla_forsaken_2",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "sla_warriors_2",
							["hidden_fragment"] = false
						},
						[3] = {
							["force_fragment_key"] = "sla_marauders_3",
							["hidden_fragment"] = false
						}
					},
					[2] = {
						[1] = {
							["force_fragment_key"] = "sla_hellstriders_2",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "sla_furies_2",
							["hidden_fragment"] = false
						}
					}
				}
			},
			["start_army_dae_undivided_quality"] = {
				["mandatory_fragments"] = {

				},
				["key"] = "start_army_dae_undivided_quality",
				["generated_fragment_slots"] = {

				}
			},
			["starting_battle_tze"] = {
				["mandatory_fragments"] = {
					[1] = {
						["force_fragment_key"] = "tze_warriors_2",
						["hidden_fragment"] = false
					}
				},
				["key"] = "starting_battle_tze",
				["generated_fragment_slots"] = {
					[1] = {
						[1] = {
							["force_fragment_key"] = "tze_pink_1",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "tze_blue_2",
							["hidden_fragment"] = false
						}
					},
					[2] = {
						[1] = {
							["force_fragment_key"] = "tze_spawn_1",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "tze_forsaken_2",
							["hidden_fragment"] = false
						}
					},
					[3] = {
						[1] = {
							["force_fragment_key"] = "tze_chariot_1",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "tze_marauder_horse_2",
							["hidden_fragment"] = false
						},
						[3] = {
							["force_fragment_key"] = "tze_furies_2",
							["hidden_fragment"] = false
						}
					}
				}
			},
			["start_army_dae_nurgle"] = {
				["mandatory_fragments"] = {
					[1] = {
						["force_fragment_key"] = "nurglings_3",
						["hidden_fragment"] = false
					}
				},
				["key"] = "start_army_dae_nurgle",
				["generated_fragment_slots"] = {
					[1] = {
						[1] = {
							["force_fragment_key"] = "nur_toads_2",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "nur_furies_2",
							["hidden_fragment"] = false
						},
						[3] = {
							["force_fragment_key"] = "nur_flies_2",
							["hidden_fragment"] = false
						}
					},
					[2] = {
						[1] = {
							["force_fragment_key"] = "nur_plaguebearer_2",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "nurglings_3",
							["hidden_fragment"] = false
						}
					},
					[3] = {
						[1] = {
							["force_fragment_key"] = "nur_spawn_1",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "nur_drones_1",
							["hidden_fragment"] = false
						},
						[3] = {
							["force_fragment_key"] = "nur_ex_plaguebearer_1",
							["hidden_fragment"] = false
						},
						[4] = {
							["force_fragment_key"] = "nur_beast_2",
							["hidden_fragment"] = false
						}
					}
				}
			},
			["starting_battle_nur"] = {
				["mandatory_fragments"] = {
					[1] = {
						["force_fragment_key"] = "nurglings_4",
						["hidden_fragment"] = false
					}
				},
				["key"] = "starting_battle_nur",
				["generated_fragment_slots"] = {
					[1] = {
						[1] = {
							["force_fragment_key"] = "nur_warriors_2",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "nur_forsaken_2",
							["hidden_fragment"] = false
						},
						[3] = {
							["force_fragment_key"] = "nur_marauders_3",
							["hidden_fragment"] = false
						}
					},
					[2] = {
						[1] = {
							["force_fragment_key"] = "nur_flies_1",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "nur_toads_2",
							["hidden_fragment"] = false
						}
					},
					[3] = {
						[1] = {
							["force_fragment_key"] = "nur_beast_1",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "nur_plaguebearer_1",
							["hidden_fragment"] = false
						}
					}
				}
			},
			["start_army_chs_undivided_quality"] = {
				["mandatory_fragments"] = {

				},
				["key"] = "start_army_chs_undivided_quality",
				["generated_fragment_slots"] = {

				}
			},
			["start_army_dae_khorne"] = {
				["mandatory_fragments"] = {
					[1] = {
						["force_fragment_key"] = "kho_letters_2",
						["hidden_fragment"] = false
					}
				},
				["key"] = "start_army_dae_khorne",
				["generated_fragment_slots"] = {
					[1] = {
						[1] = {
							["force_fragment_key"] = "kho_fleshhounds_2",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "kho_letters_2",
							["hidden_fragment"] = false
						}
					},
					[2] = {
						[1] = {
							["force_fragment_key"] = "kho_fleshhounds_1",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "kho_furies_2",
							["hidden_fragment"] = false
						}
					},
					[3] = {
						[1] = {
							["force_fragment_key"] = "kho_ex_letters_1",
							["hidden_fragment"] = false
						},
						[2] = {
							["force_fragment_key"] = "kho_bloodcrusher_1",
							["hidden_fragment"] = false
						},
						[3] = {
							["force_fragment_key"] = "kho_bloodshrine",
							["hidden_fragment"] = false
						}
					}
				}
			}
		},
		["upe_sets"] = {

		},
		["encounters"] = {
			["starting_battle"] = {
				["progress_payload"] = "START_BATTLE_COMPLETE",
				["region"] = "settlement:wh3_main_chaos_region_doomkeep",
				["duration"] = 0,
				["boss_overlay"] = false,
				["reward_set"] = "daniel_intro_battle_rewards",
				["key"] = "starting_battle",
				["inciting_incident_key"] = "",
				["battle_type"] = "LAND_ATTACK",
				["post_battle_dilemma_override"] = "",
				["force_set"] = {
					[1] = "starting_battle_kho",
					[2] = "starting_battle_nur",
					[3] = "starting_battle_sla",
					[4] = "starting_battle_tze"
				}
			}
		},
		["reward_dilemma_choice_details"] = {
			["rogue_start_nur_vs_tze"] = {
				["FIRST"] = {
					["generated_reward_components"] = {

					},
					["mandatory_reward_components"] = {
						[1] = {
							["costs_resource"] = "rogue_nur_favour",
							["force_fragment_set"] = "start_army_chs_nurgle",
							["armory_part_set"] = {
								["mandatory_parts"] = {

								},
								["generated_part_slots"] = {
									[1] = {
										[1] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_warrior_sword_5",
										[2] = "wh3_main_dae_cha_daemon_prince_arm_r_corpulent_6",
										[3] = "wh3_main_dae_cha_daemon_prince_weapon_dragon_ogre_hammer_3",
										[4] = "wh3_main_dae_cha_daemon_prince_arm_l_corpulent_5",
										[5] = "wh3_main_dae_cha_daemon_prince_head_base_8",
										[6] = "wh3_main_dae_cha_daemon_prince_tail_corpulent_3",
										[7] = "wh3_main_dae_cha_daemon_prince_wings_corpulent",
										[8] = "wh3_main_dae_cha_daemon_prince_head_base_7",
										[9] = "wh3_main_dae_cha_daemon_prince_wings_corpulent_3",
										[10] = "wh3_main_dae_cha_daemon_prince_arm_r_corpulent_5",
										[11] = "wh3_main_dae_cha_daemon_prince_arm_l_corpulent_6",
										[12] = "wh3_main_dae_cha_daemon_prince_torso_magical_medium_6",
										[13] = "wh3_main_dae_cha_daemon_prince_legs_corpulent_6",
										[14] = "wh3_main_dae_cha_daemon_prince_head_base_11"
									}
								},
								["key"] = "nurgle_1",
								["upgrade_when_exhausted"] = "nurgle_3"
							}
						}
					}
				},
				["SECOND"] = {
					["generated_reward_components"] = {

					},
					["mandatory_reward_components"] = {
						[1] = {
							["costs_resource"] = "rogue_tze_favour",
							["force_fragment_set"] = "start_army_dae_tzeentch",
							["armory_part_set"] = {
								["mandatory_parts"] = {

								},
								["generated_part_slots"] = {
									[1] = {
										[1] = "wh3_main_dae_cha_daemon_prince_legs_bird_7",
										[2] = "wh3_main_dae_cha_daemon_prince_wings_bird_5",
										[3] = "wh3_main_dae_cha_daemon_prince_torso_bird_1",
										[4] = "wh3_main_dae_cha_daemon_prince_arm_l_bird_4",
										[5] = "wh3_main_dae_cha_daemon_prince_head_bird_7",
										[6] = "wh3_main_dae_cha_daemon_prince_arm_r_bird_4",
										[7] = "wh3_main_dae_cha_daemon_prince_tail_snapping_4",
										[8] = "wh3_main_dae_cha_daemon_prince_arm_l_base_5",
										[9] = "wh3_main_dae_cha_daemon_prince_arm_r_bird_5",
										[10] = "wh3_main_dae_cha_daemon_prince_torso_magical_medium_5",
										[11] = "wh3_main_dae_cha_daemon_prince_tail_snapping_5",
										[12] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_sorcerer_staff_2",
										[13] = "wh3_main_dae_cha_daemon_prince_arm_l_bird_5",
										[14] = "wh3_main_dae_cha_daemon_prince_head_bird_8"
									}
								},
								["key"] = "tzeentch_1",
								["upgrade_when_exhausted"] = "tzeentch_2"
							}
						}
					}
				}
			},
			["rogue_start_all_dae"] = {
				["FOURTH"] = {
					["generated_reward_components"] = {

					},
					["mandatory_reward_components"] = {
						[1] = {
							["costs_resource"] = "rogue_nur_favour",
							["force_fragment_set"] = "start_army_dae_nurgle",
							["armory_part_set"] = {
								["mandatory_parts"] = {

								},
								["generated_part_slots"] = {
									[1] = {
										[1] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_warrior_sword_5",
										[2] = "wh3_main_dae_cha_daemon_prince_arm_r_corpulent_6",
										[3] = "wh3_main_dae_cha_daemon_prince_weapon_dragon_ogre_hammer_3",
										[4] = "wh3_main_dae_cha_daemon_prince_arm_l_corpulent_5",
										[5] = "wh3_main_dae_cha_daemon_prince_head_base_8",
										[6] = "wh3_main_dae_cha_daemon_prince_tail_corpulent_3",
										[7] = "wh3_main_dae_cha_daemon_prince_wings_corpulent",
										[8] = "wh3_main_dae_cha_daemon_prince_head_base_7",
										[9] = "wh3_main_dae_cha_daemon_prince_wings_corpulent_3",
										[10] = "wh3_main_dae_cha_daemon_prince_arm_r_corpulent_5",
										[11] = "wh3_main_dae_cha_daemon_prince_arm_l_corpulent_6",
										[12] = "wh3_main_dae_cha_daemon_prince_torso_magical_medium_6",
										[13] = "wh3_main_dae_cha_daemon_prince_legs_corpulent_6",
										[14] = "wh3_main_dae_cha_daemon_prince_head_base_11"
									}
								},
								["key"] = "nurgle_1",
								["upgrade_when_exhausted"] = "nurgle_3"
							}
						}
					}
				},
				["FIRST"] = {
					["generated_reward_components"] = {

					},
					["mandatory_reward_components"] = {
						[1] = {
							["costs_resource"] = "rogue_kho_favour",
							["force_fragment_set"] = "start_army_dae_khorne",
							["armory_part_set"] = {
								["mandatory_parts"] = {

								},
								["generated_part_slots"] = {
									[1] = {
										[1] = "wh3_main_dae_cha_daemon_prince_arm_r_armoured_2",
										[2] = "wh3_main_dae_cha_daemon_prince_legs_beast_7",
										[3] = "wh3_main_dae_cha_daemon_prince_wings_beast",
										[4] = "wh3_main_dae_cha_daemon_prince_arm_l_armoured_4",
										[5] = "wh3_main_dae_cha_daemon_prince_head_beast_2",
										[6] = "wh3_main_dae_cha_daemon_prince_tail_living_2",
										[7] = "wh3_main_dae_cha_daemon_prince_torso_brasscollar_1",
										[8] = "wh3_main_dae_cha_daemon_prince_tail_living_4",
										[9] = "wh3_main_dae_cha_daemon_prince_wings_beast_4",
										[10] = "wh3_main_dae_cha_daemon_prince_legs_beast_8",
										[11] = "wh3_main_dae_cha_daemon_prince_head_beast_1",
										[12] = "wh3_main_dae_cha_daemon_prince_arm_l_armoured_2",
										[13] = "wh3_main_dae_cha_daemon_prince_torso_brasscollar_4",
										[14] = "wh3_main_dae_cha_daemon_prince_tail_living_5"
									}
								},
								["key"] = "khorne_1",
								["upgrade_when_exhausted"] = "khorne_2"
							}
						}
					}
				},
				["SECOND"] = {
					["generated_reward_components"] = {

					},
					["mandatory_reward_components"] = {
						[1] = {
							["costs_resource"] = "rogue_sla_favour",
							["force_fragment_set"] = "start_army_dae_slaanesh",
							["armory_part_set"] = {
								["mandatory_parts"] = {

								},
								["generated_part_slots"] = {
									[1] = {
										[1] = "wh3_main_dae_cha_daemon_prince_tail_fiend_4",
										[2] = "wh3_main_dae_cha_daemon_prince_torso_magical_medium_1",
										[3] = "wh3_main_dae_cha_daemon_prince_weapon_dragon_ogre_hammer_2",
										[4] = "wh3_main_dae_cha_daemon_prince_head_adornedhelmet_8",
										[5] = "wh3_main_dae_cha_daemon_prince_wings_sensuous_3",
										[6] = "wh3_main_dae_cha_daemon_prince_arm_r_scythe_1",
										[7] = "wh3_main_dae_cha_daemon_prince_legs_daemonette_7",
										[8] = "wh3_main_dae_cha_daemon_prince_torso_magical_heavy_1",
										[9] = "wh3_main_dae_cha_daemon_prince_arm_l_scythe_3",
										[10] = "wh3_main_dae_cha_daemon_prince_legs_daemonette_8",
										[11] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_knight_lance_3",
										[12] = "wh3_main_dae_cha_daemon_prince_wings_sensuous_2",
										[13] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_knight_sword_2",
										[14] = "wh3_main_dae_cha_daemon_prince_arm_l_scythe_1"
									}
								},
								["key"] = "slaanesh_1",
								["upgrade_when_exhausted"] = "slaanesh_2"
							}
						}
					}
				},
				["THIRD"] = {
					["generated_reward_components"] = {

					},
					["mandatory_reward_components"] = {
						[1] = {
							["costs_resource"] = "rogue_tze_favour",
							["force_fragment_set"] = "start_army_dae_tzeentch",
							["armory_part_set"] = {
								["mandatory_parts"] = {

								},
								["generated_part_slots"] = {
									[1] = {
										[1] = "wh3_main_dae_cha_daemon_prince_legs_bird_7",
										[2] = "wh3_main_dae_cha_daemon_prince_wings_bird_5",
										[3] = "wh3_main_dae_cha_daemon_prince_torso_bird_1",
										[4] = "wh3_main_dae_cha_daemon_prince_arm_l_bird_4",
										[5] = "wh3_main_dae_cha_daemon_prince_head_bird_7",
										[6] = "wh3_main_dae_cha_daemon_prince_arm_r_bird_4",
										[7] = "wh3_main_dae_cha_daemon_prince_tail_snapping_4",
										[8] = "wh3_main_dae_cha_daemon_prince_arm_l_base_5",
										[9] = "wh3_main_dae_cha_daemon_prince_arm_r_bird_5",
										[10] = "wh3_main_dae_cha_daemon_prince_torso_magical_medium_5",
										[11] = "wh3_main_dae_cha_daemon_prince_tail_snapping_5",
										[12] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_sorcerer_staff_2",
										[13] = "wh3_main_dae_cha_daemon_prince_arm_l_bird_5",
										[14] = "wh3_main_dae_cha_daemon_prince_head_bird_8"
									}
								},
								["key"] = "tzeentch_1",
								["upgrade_when_exhausted"] = "tzeentch_2"
							}
						}
					}
				}
			},
			["rogue_start_chs_quality_vs_dae_quantity"] = {
				["FIRST"] = {
					["generated_reward_components"] = {

					},
					["mandatory_reward_components"] = {
						[1] = {
							["costs_resource"] = "",
							["force_fragment_set"] = "start_army_chs_undivided_quality",
							["armory_part_set"] = {
								["mandatory_parts"] = {

								},
								["generated_part_slots"] = {
									[1] = {
										[1] = "wh3_main_dae_cha_daemon_prince_arm_l_base_6",
										[2] = "wh3_main_dae_cha_daemon_prince_wings_base_6",
										[3] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_shield_2",
										[4] = "wh3_main_dae_cha_daemon_prince_legs_base_2",
										[5] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_warrior_sword_2",
										[6] = "wh3_main_dae_cha_daemon_prince_head_base_2",
										[7] = "wh3_main_dae_cha_daemon_prince_torso_magical_medium_2",
										[8] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_knight_sword_1",
										[9] = "wh3_main_dae_cha_daemon_prince_torso_base_6",
										[10] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_shield_1",
										[11] = "wh3_main_dae_cha_daemon_prince_torso_base_10",
										[12] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_sorcerer_staff_3",
										[13] = "wh3_main_dae_cha_daemon_prince_arm_r_base_6",
										[14] = "wh3_main_dae_cha_daemon_prince_tail_base_5"
									}
								},
								["key"] = "undivided_1",
								["upgrade_when_exhausted"] = "undivided_2"
							}
						}
					}
				},
				["SECOND"] = {
					["generated_reward_components"] = {

					},
					["mandatory_reward_components"] = {
						[1] = {
							["costs_resource"] = "",
							["force_fragment_set"] = "start_army_dae_undivided_quantity",
							["armory_part_set"] = {
								["mandatory_parts"] = {

								},
								["generated_part_slots"] = {
									[1] = {
										[1] = "wh3_main_dae_cha_daemon_prince_arm_l_base_6",
										[2] = "wh3_main_dae_cha_daemon_prince_wings_base_6",
										[3] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_shield_2",
										[4] = "wh3_main_dae_cha_daemon_prince_legs_base_2",
										[5] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_warrior_sword_2",
										[6] = "wh3_main_dae_cha_daemon_prince_head_base_2",
										[7] = "wh3_main_dae_cha_daemon_prince_torso_magical_medium_2",
										[8] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_knight_sword_1",
										[9] = "wh3_main_dae_cha_daemon_prince_torso_base_6",
										[10] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_shield_1",
										[11] = "wh3_main_dae_cha_daemon_prince_torso_base_10",
										[12] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_sorcerer_staff_3",
										[13] = "wh3_main_dae_cha_daemon_prince_arm_r_base_6",
										[14] = "wh3_main_dae_cha_daemon_prince_tail_base_5"
									}
								},
								["key"] = "undivided_1",
								["upgrade_when_exhausted"] = "undivided_2"
							}
						}
					}
				}
			},
			["rogue_start_tze_vs_kho"] = {
				["FIRST"] = {
					["generated_reward_components"] = {

					},
					["mandatory_reward_components"] = {
						[1] = {
							["costs_resource"] = "rogue_tze_favour",
							["force_fragment_set"] = "start_army_chs_tzeentch",
							["armory_part_set"] = {
								["mandatory_parts"] = {

								},
								["generated_part_slots"] = {
									[1] = {
										[1] = "wh3_main_dae_cha_daemon_prince_legs_bird_7",
										[2] = "wh3_main_dae_cha_daemon_prince_wings_bird_5",
										[3] = "wh3_main_dae_cha_daemon_prince_torso_bird_1",
										[4] = "wh3_main_dae_cha_daemon_prince_arm_l_bird_4",
										[5] = "wh3_main_dae_cha_daemon_prince_head_bird_7",
										[6] = "wh3_main_dae_cha_daemon_prince_arm_r_bird_4",
										[7] = "wh3_main_dae_cha_daemon_prince_tail_snapping_4",
										[8] = "wh3_main_dae_cha_daemon_prince_arm_l_base_5",
										[9] = "wh3_main_dae_cha_daemon_prince_arm_r_bird_5",
										[10] = "wh3_main_dae_cha_daemon_prince_torso_magical_medium_5",
										[11] = "wh3_main_dae_cha_daemon_prince_tail_snapping_5",
										[12] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_sorcerer_staff_2",
										[13] = "wh3_main_dae_cha_daemon_prince_arm_l_bird_5",
										[14] = "wh3_main_dae_cha_daemon_prince_head_bird_8"
									}
								},
								["key"] = "tzeentch_1",
								["upgrade_when_exhausted"] = "tzeentch_2"
							}
						}
					}
				},
				["SECOND"] = {
					["generated_reward_components"] = {

					},
					["mandatory_reward_components"] = {
						[1] = {
							["costs_resource"] = "rogue_kho_favour",
							["force_fragment_set"] = "start_army_dae_khorne",
							["armory_part_set"] = {
								["mandatory_parts"] = {

								},
								["generated_part_slots"] = {
									[1] = {
										[1] = "wh3_main_dae_cha_daemon_prince_arm_r_armoured_2",
										[2] = "wh3_main_dae_cha_daemon_prince_legs_beast_7",
										[3] = "wh3_main_dae_cha_daemon_prince_wings_beast",
										[4] = "wh3_main_dae_cha_daemon_prince_arm_l_armoured_4",
										[5] = "wh3_main_dae_cha_daemon_prince_head_beast_2",
										[6] = "wh3_main_dae_cha_daemon_prince_tail_living_2",
										[7] = "wh3_main_dae_cha_daemon_prince_torso_brasscollar_1",
										[8] = "wh3_main_dae_cha_daemon_prince_tail_living_4",
										[9] = "wh3_main_dae_cha_daemon_prince_wings_beast_4",
										[10] = "wh3_main_dae_cha_daemon_prince_legs_beast_8",
										[11] = "wh3_main_dae_cha_daemon_prince_head_beast_1",
										[12] = "wh3_main_dae_cha_daemon_prince_arm_l_armoured_2",
										[13] = "wh3_main_dae_cha_daemon_prince_torso_brasscollar_4",
										[14] = "wh3_main_dae_cha_daemon_prince_tail_living_5"
									}
								},
								["key"] = "khorne_1",
								["upgrade_when_exhausted"] = "khorne_2"
							}
						}
					}
				}
			},
			["rogue_start_sla_vs_nur"] = {
				["FIRST"] = {
					["generated_reward_components"] = {

					},
					["mandatory_reward_components"] = {
						[1] = {
							["costs_resource"] = "rogue_sla_favour",
							["force_fragment_set"] = "start_army_chs_slaanesh",
							["armory_part_set"] = {
								["mandatory_parts"] = {

								},
								["generated_part_slots"] = {
									[1] = {
										[1] = "wh3_main_dae_cha_daemon_prince_tail_fiend_4",
										[2] = "wh3_main_dae_cha_daemon_prince_torso_magical_medium_1",
										[3] = "wh3_main_dae_cha_daemon_prince_weapon_dragon_ogre_hammer_2",
										[4] = "wh3_main_dae_cha_daemon_prince_head_adornedhelmet_8",
										[5] = "wh3_main_dae_cha_daemon_prince_wings_sensuous_3",
										[6] = "wh3_main_dae_cha_daemon_prince_arm_r_scythe_1",
										[7] = "wh3_main_dae_cha_daemon_prince_legs_daemonette_7",
										[8] = "wh3_main_dae_cha_daemon_prince_torso_magical_heavy_1",
										[9] = "wh3_main_dae_cha_daemon_prince_arm_l_scythe_3",
										[10] = "wh3_main_dae_cha_daemon_prince_legs_daemonette_8",
										[11] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_knight_lance_3",
										[12] = "wh3_main_dae_cha_daemon_prince_wings_sensuous_2",
										[13] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_knight_sword_2",
										[14] = "wh3_main_dae_cha_daemon_prince_arm_l_scythe_1"
									}
								},
								["key"] = "slaanesh_1",
								["upgrade_when_exhausted"] = "slaanesh_2"
							}
						}
					}
				},
				["SECOND"] = {
					["generated_reward_components"] = {

					},
					["mandatory_reward_components"] = {
						[1] = {
							["costs_resource"] = "rogue_nur_favour",
							["force_fragment_set"] = "start_army_dae_nurgle",
							["armory_part_set"] = {
								["mandatory_parts"] = {

								},
								["generated_part_slots"] = {
									[1] = {
										[1] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_warrior_sword_5",
										[2] = "wh3_main_dae_cha_daemon_prince_arm_r_corpulent_6",
										[3] = "wh3_main_dae_cha_daemon_prince_weapon_dragon_ogre_hammer_3",
										[4] = "wh3_main_dae_cha_daemon_prince_arm_l_corpulent_5",
										[5] = "wh3_main_dae_cha_daemon_prince_head_base_8",
										[6] = "wh3_main_dae_cha_daemon_prince_tail_corpulent_3",
										[7] = "wh3_main_dae_cha_daemon_prince_wings_corpulent",
										[8] = "wh3_main_dae_cha_daemon_prince_head_base_7",
										[9] = "wh3_main_dae_cha_daemon_prince_wings_corpulent_3",
										[10] = "wh3_main_dae_cha_daemon_prince_arm_r_corpulent_5",
										[11] = "wh3_main_dae_cha_daemon_prince_arm_l_corpulent_6",
										[12] = "wh3_main_dae_cha_daemon_prince_torso_magical_medium_6",
										[13] = "wh3_main_dae_cha_daemon_prince_legs_corpulent_6",
										[14] = "wh3_main_dae_cha_daemon_prince_head_base_11"
									}
								},
								["key"] = "nurgle_1",
								["upgrade_when_exhausted"] = "nurgle_3"
							}
						}
					}
				}
			},
			["rogue_start_dae_quality_vs_chs_quantity"] = {
				["FIRST"] = {
					["generated_reward_components"] = {

					},
					["mandatory_reward_components"] = {
						[1] = {
							["costs_resource"] = "",
							["force_fragment_set"] = "start_army_dae_undivided_quality",
							["armory_part_set"] = {
								["mandatory_parts"] = {

								},
								["generated_part_slots"] = {
									[1] = {
										[1] = "wh3_main_dae_cha_daemon_prince_arm_l_base_6",
										[2] = "wh3_main_dae_cha_daemon_prince_wings_base_6",
										[3] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_shield_2",
										[4] = "wh3_main_dae_cha_daemon_prince_legs_base_2",
										[5] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_warrior_sword_2",
										[6] = "wh3_main_dae_cha_daemon_prince_head_base_2",
										[7] = "wh3_main_dae_cha_daemon_prince_torso_magical_medium_2",
										[8] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_knight_sword_1",
										[9] = "wh3_main_dae_cha_daemon_prince_torso_base_6",
										[10] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_shield_1",
										[11] = "wh3_main_dae_cha_daemon_prince_torso_base_10",
										[12] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_sorcerer_staff_3",
										[13] = "wh3_main_dae_cha_daemon_prince_arm_r_base_6",
										[14] = "wh3_main_dae_cha_daemon_prince_tail_base_5"
									}
								},
								["key"] = "undivided_1",
								["upgrade_when_exhausted"] = "undivided_2"
							}
						}
					}
				},
				["SECOND"] = {
					["generated_reward_components"] = {

					},
					["mandatory_reward_components"] = {
						[1] = {
							["costs_resource"] = "",
							["force_fragment_set"] = "start_army_chs_undivided_quantity",
							["armory_part_set"] = {
								["mandatory_parts"] = {

								},
								["generated_part_slots"] = {
									[1] = {
										[1] = "wh3_main_dae_cha_daemon_prince_arm_l_base_6",
										[2] = "wh3_main_dae_cha_daemon_prince_wings_base_6",
										[3] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_shield_2",
										[4] = "wh3_main_dae_cha_daemon_prince_legs_base_2",
										[5] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_warrior_sword_2",
										[6] = "wh3_main_dae_cha_daemon_prince_head_base_2",
										[7] = "wh3_main_dae_cha_daemon_prince_torso_magical_medium_2",
										[8] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_knight_sword_1",
										[9] = "wh3_main_dae_cha_daemon_prince_torso_base_6",
										[10] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_shield_1",
										[11] = "wh3_main_dae_cha_daemon_prince_torso_base_10",
										[12] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_sorcerer_staff_3",
										[13] = "wh3_main_dae_cha_daemon_prince_arm_r_base_6",
										[14] = "wh3_main_dae_cha_daemon_prince_tail_base_5"
									}
								},
								["key"] = "undivided_1",
								["upgrade_when_exhausted"] = "undivided_2"
							}
						}
					}
				}
			},
			["rogue_start_kho_vs_sla"] = {
				["FIRST"] = {
					["generated_reward_components"] = {

					},
					["mandatory_reward_components"] = {
						[1] = {
							["costs_resource"] = "rogue_kho_favour",
							["force_fragment_set"] = "start_army_chs_khorne",
							["armory_part_set"] = {
								["mandatory_parts"] = {

								},
								["generated_part_slots"] = {
									[1] = {
										[1] = "wh3_main_dae_cha_daemon_prince_arm_r_armoured_2",
										[2] = "wh3_main_dae_cha_daemon_prince_legs_beast_7",
										[3] = "wh3_main_dae_cha_daemon_prince_wings_beast",
										[4] = "wh3_main_dae_cha_daemon_prince_arm_l_armoured_4",
										[5] = "wh3_main_dae_cha_daemon_prince_head_beast_2",
										[6] = "wh3_main_dae_cha_daemon_prince_tail_living_2",
										[7] = "wh3_main_dae_cha_daemon_prince_torso_brasscollar_1",
										[8] = "wh3_main_dae_cha_daemon_prince_tail_living_4",
										[9] = "wh3_main_dae_cha_daemon_prince_wings_beast_4",
										[10] = "wh3_main_dae_cha_daemon_prince_legs_beast_8",
										[11] = "wh3_main_dae_cha_daemon_prince_head_beast_1",
										[12] = "wh3_main_dae_cha_daemon_prince_arm_l_armoured_2",
										[13] = "wh3_main_dae_cha_daemon_prince_torso_brasscollar_4",
										[14] = "wh3_main_dae_cha_daemon_prince_tail_living_5"
									}
								},
								["key"] = "khorne_1",
								["upgrade_when_exhausted"] = "khorne_2"
							}
						}
					}
				},
				["SECOND"] = {
					["generated_reward_components"] = {

					},
					["mandatory_reward_components"] = {
						[1] = {
							["costs_resource"] = "rogue_sla_favour",
							["force_fragment_set"] = "start_army_dae_slaanesh",
							["armory_part_set"] = {
								["mandatory_parts"] = {

								},
								["generated_part_slots"] = {
									[1] = {
										[1] = "wh3_main_dae_cha_daemon_prince_tail_fiend_4",
										[2] = "wh3_main_dae_cha_daemon_prince_torso_magical_medium_1",
										[3] = "wh3_main_dae_cha_daemon_prince_weapon_dragon_ogre_hammer_2",
										[4] = "wh3_main_dae_cha_daemon_prince_head_adornedhelmet_8",
										[5] = "wh3_main_dae_cha_daemon_prince_wings_sensuous_3",
										[6] = "wh3_main_dae_cha_daemon_prince_arm_r_scythe_1",
										[7] = "wh3_main_dae_cha_daemon_prince_legs_daemonette_7",
										[8] = "wh3_main_dae_cha_daemon_prince_torso_magical_heavy_1",
										[9] = "wh3_main_dae_cha_daemon_prince_arm_l_scythe_3",
										[10] = "wh3_main_dae_cha_daemon_prince_legs_daemonette_8",
										[11] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_knight_lance_3",
										[12] = "wh3_main_dae_cha_daemon_prince_wings_sensuous_2",
										[13] = "wh3_main_dae_cha_daemon_prince_weapon_chaos_knight_sword_2",
										[14] = "wh3_main_dae_cha_daemon_prince_arm_l_scythe_1"
									}
								},
								["key"] = "slaanesh_1",
								["upgrade_when_exhausted"] = "slaanesh_2"
							}
						}
					}
				}
			}
		},
		["faction_sets"] = {
			["tze_minor_factions"] = {
				[1] = "wh3_main_tze_all_seeing_eye",
				[2] = "wh3_main_tze_sarthoraels_watchers",
				[3] = "wh3_main_tze_broken_wheel",
				[4] = "wh3_main_tze_flaming_scribes",
				[5] = "wh3_dlc20_tze_the_sightless"
			},
			["nur_minor_factions"] = {
				[1] = "wh3_main_nur_septic_claw",
				[2] = "wh3_main_nur_bubonic_swarm",
				[3] = "wh3_main_nur_maggoth_kin"
			},
			["chs_minor_factions"] = {
				[1] = "wh3_main_chs_khazag",
				[2] = "wh3_main_chs_kvellig",
				[3] = "wh3_main_chs_gharhar",
				[4] = "wh3_main_chs_tong"
			},
			["mirror_match"] = {
				[1] = "wh3_main_dae_daemons_qb1"
			},
			["kho_minor_factions"] = {
				[1] = "wh3_main_kho_bloody_sword",
				[2] = "wh3_main_kho_karneths_sons",
				[3] = "wh3_main_kho_brazen_throne",
				[4] = "wh3_main_kho_crimson_skull"
			},
			["sla_minor_factions"] = {
				[1] = "wh3_main_sla_exquisite_pain",
				[2] = "wh3_main_sla_rapturous_excess",
				[3] = "wh3_main_sla_subtle_torture"
			}
		},
		["force_sets"] = {
			["norscan_tribes_easy"] = {

			},
			["kho_nur_norm"] = {

			},
			["valkia_intro"] = {

			},
			["tze_easy"] = {

			},
			["tze_nurgle_norm"] = {

			},
			["skv_grn_ambush_easy"] = {

			},
			["wulfrik_intro"] = {

			},
			["doom_keep_boss"] = {

			},
			["grn_orcs_easy"] = {

			},
			["starting_enemies"] = {
				[1] = "starting_battle_kho",
				[2] = "starting_battle_nur",
				[3] = "starting_battle_sla",
				[4] = "starting_battle_tze"
			},
			["emp_easy"] = {

			},
			["chs_mutants_easy"] = {

			},
			["kho_easy"] = {

			}
		}
	}