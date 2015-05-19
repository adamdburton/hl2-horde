DEFINE_BASECLASS("gamemode_base")

GM.Name = "HL2: Horde"
GM.Author = "_Undefined"
GM.Email = "adam@burt0n.net"
GM.Website = ""

-- Lots of shared info

GM.WaveNPCs = {
	{ npc_metropolice = 5, npc_manhack = 2 },
	{ npc_headcrab = 2, npc_zombie = 4 },
	{ npc_combine_s = 3 },
	{ npc_zombie = 5 },
	{ npc_antlion = 10 },
	{ npc_antlionguard = 1 },
	{ npc_fastzombie = 3, npc_headcrab_fast = 5 },
}

GM.WaveNPCsWeapons = {
	npc_metropolice = 'weapon_smg1',
	npc_combine_s = 'weapon_ar2'
}

GM.WaveSpawnPositions = {
	Vector(1276.829346, -513.553284, 0),
	Vector(-325.469604, 1320.210449, 0),
	Vector(-1526.653564, -535.232605, 0),
	Vector(-548.547302, -1447.488892, 0)
}

GM.NPCCash = {
	npc_metropolice = 2,
	npc_manhack = 1,
	npc_headcrab = 1,
	npc_fastzombie = 3,
	npc_combine_s = 3,
	npc_combinegunship = 10,
	npc_zombie = 2,
	npc_headcrab_fast = 2,
	npc_antlion = 3,
	npc_antlionguard = 10,
	npc_rollermine = 1,
	npc_cscanner = 1
}

GM.NPCProficiencies = {
	[1] = WEAPON_PROFICIENCY_VERY_GOOD,
	[20] = WEAPON_PROFICIENCY_PERFECT
}

GM.PlayerModels = {
	'models/player/Group01/Male_01.mdl',
	'models/player/Group01/Male_02.mdl',
	'models/player/Group01/Male_03.mdl',
	'models/player/Group01/Male_04.mdl',
	'models/player/Group01/Male_05.mdl',
	'models/player/Group01/Male_06.mdl',
	'models/player/Group01/Male_07.mdl',
	'models/player/Group01/Male_08.mdl',
	'models/player/Group01/Male_09.mdl',
	'models/player/Group01/Female_01.mdl',
	'models/player/Group01/Female_02.mdl',
	'models/player/Group01/Female_03.mdl',
	'models/player/Group01/Female_04.mdl',
	'models/player/Group01/Female_06.mdl',
	'models/player/Group01/Female_07.mdl',
	'models/player/Group03/Male_01.mdl',
	'models/player/Group03/Male_02.mdl',
	'models/player/Group03/Male_03.mdl',
	'models/player/Group03/Male_04.mdl',
	'models/player/Group03/Male_05.mdl',
	'models/player/Group03/Male_06.mdl',
	'models/player/Group03/Male_07.mdl',
	'models/player/Group03/Male_08.mdl',
	'models/player/Group03/Male_09.mdl',
	'models/player/Group03/Female_01.mdl',
	'models/player/Group03/Female_02.mdl',
	'models/player/Group03/Female_03.mdl',
	'models/player/Group03/Female_04.mdl',
	'models/player/Group03/Female_06.mdl',
	'models/player/Group03/Female_07.mdl',
	'models/humans/Group03m/Male_01.mdl',
	'models/humans/Group03m/Male_02.mdl',
	'models/humans/Group03m/Male_03.mdl',
	'models/humans/Group03m/Male_04.mdl',
	'models/humans/Group03m/Male_05.mdl',
	'models/humans/Group03m/Male_06.mdl',
	'models/humans/Group03m/Male_07.mdl',
	'models/humans/Group03m/Male_08.mdl',
	'models/humans/Group03m/Male_09.mdl',
	'models/humans/Group03m/Female_01.mdl',
	'models/humans/Group03m/Female_02.mdl',
	'models/humans/Group03m/Female_03.mdl',
	'models/humans/Group03m/Female_04.mdl',
	'models/humans/Group03m/Female_06.mdl',
	'models/humans/Group03m/Female_07.mdl'
}

GM.WeaponUpgrades = {
	[1] = 'weapon_crowbar',
	[2] = 'weapon_pistol',
	[3] = 'weapon_smg1',
	[10] = 'weapon_shotgun',
	[12] = 'weapon_ar2',
	[20] = 'weapon_357',
	[25] = 'weapon_frag',
	[30] = 'weapon_crossbow',
	[40] = 'weapon_rpg',
	[50] = 'weapon_stunstick'
}

GM.Ammo = {
	weapon_pistol = { Pistol = 64 },
	weapon_smg1 = { SMG1 = 64, SMG1_Grenade = 2 },
	weapon_shotgun = { Buckshot = 64 },
	weapon_ar2 = { AR2 = 100, AR2AltFire = 2 },
	weapon_357 = { [357] = 32 },
	weapon_frag = { Grenade = 4 },
	weapon_crossbow = { XBowBolt = 32 },
	weapon_rpg = { RPG_Round = 2 }
}

GM.ExplosivesLocations = {
	Vector(-431.968750, 704.222229, 44.137650),
	Vector(-144.031250, 703.435425, 44.806511),
	Vector(576.705444, -512.337219, 143.931091),
	Vector(-1024.184082, -512.170593, 143.949615),
}

GM.PreWaveWaitTime = 15

-- Shared functions

function GM:GetCurrentWave()
	
	if self.CurrentWave > #self.WaveNPCs then
		local iter = math.floor(self.CurrentWave / #self.WaveNPCs)
		local wave = self.CurrentWave - (iter * #self.WaveNPCs)
		return wave > 0 and wave or #self.WaveNPCs
	end
	
	return self.CurrentWave
	
end