AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
AddCSLuaFile('cl_player.lua')
AddCSLuaFile('cl_scoreboard.lua')
AddCSLuaFile('cl_hud.lua')

AddCSLuaFile('vgui/killicon.lua')
AddCSLuaFile('vgui/scoreboard.lua')

include('shared.lua')
include('sv_player.lua')

DEFINE_BASECLASS("gamemode_base")

GM.CurrentWave = 0
GM.CurrentWaveTotalNPCs = 0
GM.CurrentWaveSpawnedNPCs = {}
GM.CurrentWaveKilledNPCs = 0
GM.RunningWave = false

GM.Started = false

function GM:Initialize()

	self.BaseClass:Initialize()
	
end

function GM:InitPostEntity()

	self.BaseClass:InitPostEntity()

	local ammocrate = ents.Create('ho_ammo_crate')
	
	ammocrate:SetPos(Vector(-271.968750, -42.008945, 32))
	ammocrate:Spawn()
	
	for k, v in pairs(self.ExplosivesLocations) do
		local ex = ents.Create('ho_explosive')
		
		ex:SetPos(v)
		ex:Spawn()
	end
	
end

function GM:PlayerInitialSpawn(ply)
	
	self.BaseClass:PlayerInitialSpawn(ply)
	
	if not self.Started then
		self:PreStartWave()
	end
	
	timer.Simple(1, function()
		ply:SendCash()
		ply:SendWaves()
		ply:SendWavesStreak()
	end)
	
end

function GM:PlayerSpawn(ply)

	self.BaseClass:PlayerSpawn(ply)
	
	ply:SetModel(table.Random(self.PlayerModels))
	
	ply:RemoveAllAmmo()
	
	self:GiveWaveWeapons(ply)
	
end

function GM:GiveWaveWeapons(ply)

	for k, v in pairs(self.WeaponUpgrades) do
		if ply:GetWaves() >= k then
		
			if self.Ammo[v] then
				for l, w in pairs(self.Ammo[v]) do
					ply:GiveAmmo(w, l, true)
				end
			end
			
			if not ply:HasWeapon(v) then
				ply:Give(v)
			end
			
		end
	end
	
	ply:SwitchToDefaultWeapon()
	
end

function GM:GiveActiveWeaponAmmo(ply)
	
	local weapon = ply:GetActiveWeapon()
	
	if self.Ammo[weapon:GetClass()] and ply:GetAmmoCount(weapon:GetPrimaryAmmoType()) > -1 then
		for k, v in pairs(self.Ammo[weapon:GetClass()]) do
			ply:GiveAmmo(v, k)
		end
		
		ply:TakeCash(30)
	end
	
end

function GM:PlayerNoClip(ply)
	
	return false
	
end

function GM:PlayerSwitchFlashlight(ply, switch)
	
	return true
	
end

function GM:PlayerDeath(ply)

	ply:SetWaves(1)
	
end

function GM:ScaleNPCDamage(npc, hitgroup, dmginfo)

	self.BaseClass:ScaleNPCDamage(npc, hitgroup, dmginfo)
	
	dmginfo:ScaleDamage(1 - (self.CurrentWave / 125))
	
end

function GM:ScalePlayerDamage(ply, hitgroup, dmginfo)
	
	self.BaseClass:ScalePlayerDamage(ply, hitgroup, dmginfo)
	
end

function GM:OnNPCKilled(npc, killer, weapon)

	if npc.WaveNPC then
		net.Start('NPCKilled')
			net.WriteString(npc:GetClass())
			net.WriteString(npc:GetModel())
			net.WriteEntity(killer)
		net.Broadcast()
		
		if killer:IsPlayer() then
			killer:AddCash(self.NPCCash[npc:GetClass()])
		end
		
		self.CurrentWaveKilledNPCs = self.CurrentWaveKilledNPCs + 1
	end
	
end

function GM:Think()
	
	self.BaseClass:Think()
	
	if self.RunningWave then
	
		-- check if we should spawn an npc
		for k, v in pairs(self.WaveNPCs[self:GetCurrentWave()]) do
			if not self.CurrentWaveSpawnedNPCs[k] then self.CurrentWaveSpawnedNPCs[k] = 0 end
		
			if self.CurrentWaveSpawnedNPCs[k] < (v * #player.GetAll()) then
				-- spawn an npc
				timer.Simple(math.random(0, 10), function() self:SpawnWaveNPC(k) end)
				self.CurrentWaveSpawnedNPCs[k] = self.CurrentWaveSpawnedNPCs[k] + 1
			end
		end
		
		-- Check if we should end the current wave
		if self.CurrentWaveKilledNPCs == self.CurrentWaveTotalNPCs then
			self:EndWave()
		end
		
	end
	
end

function GM:SpawnWaveNPC(npctype)

	local rand = VectorRand() * 100
	rand.z = 50
	
	local npc = ents.Create(npctype)
	npc:SetPos(table.Random(self.WaveSpawnPositions) + rand)
	
	if self.WaveNPCsWeapons and self.WaveNPCsWeapons[npctype] then
		npc:SetKeyValue('additionalequipment', self.WaveNPCsWeapons[npctype])
	end
	
	npc:SetKeyValue('spawnflags', bit.bor(SF_NPC_FADE_CORPSE, SF_NPC_ALWAYSTHINK))
	
	local player = table.Random(player.GetAll())
	
	npc:NavSetGoal(player:GetPos())
	
	npc:SetCurrentWeaponProficiency(self:GetNPCProficiency())
	
	npc:Spawn()
	npc:Activate()
	
	npc.WaveNPC = true
	
end

function GM:GetNPCProficiency()
	
	local prof
	
	for k, v in pairs(self.NPCProficiencies) do
		if self.CurrentWave >= k then
			prof = v
		end
	end
	
	return prof
	
end

function GM:PreStartWave()

	self.Started = true
	
	net.Start('PreStartWave')
	net.Broadcast()
	
	timer.Simple(self.PreWaveWaitTime, function() self:StartWave() end)
	
end

function GM:StartWave()

	for k, v in pairs(ents.FindByClass('npc_*')) do
		v:Remove()
	end
	
	self.CurrentWave = self.CurrentWave + 1
	
	for k, v in pairs(self.WaveNPCs[self:GetCurrentWave()]) do
		self.CurrentWaveTotalNPCs = self.CurrentWaveTotalNPCs + (v * #player.GetAll())
	end
	
	net.Start('StartWave')
		net.WriteDouble(self.CurrentWave)
		net.WriteDouble(self.CurrentWaveTotalNPCs)
	net.Broadcast()
	
	self.RunningWave = true
	
end

function GM:EndWave()
	
	net.Start('EndWave')
	net.Broadcast()
	
	for k, v in pairs(player.GetAll()) do
		v:AddWaves(1)
	end
	
	self.RunningWave = false
	self.CurrentWaveTotalNPCs = 0
	self.CurrentWaveSpawnedNPCs = {}
	self.CurrentWaveKilledNPCs = 0
	
	self:PreStartWave()

end

-- Network strings

util.AddNetworkString('PreStartWave')
util.AddNetworkString('StartWave')
util.AddNetworkString('EndWave')
util.AddNetworkString('NPCKilled')
