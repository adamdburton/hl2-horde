include('shared.lua')
include('cl_player.lua')
include('cl_scoreboard.lua')
include('cl_hud.lua')

include('vgui/scoreboard.lua')
include('vgui/killicon.lua')

DEFINE_BASECLASS('gamemode_base')

GM.CurrentWave = 0
GM.CurrentWaveNPCs = 0
GM.CurrentWaveTotalNPCs = 0

GM.RunningWave = false
GM.NextWave = 0

-- Net hooks

net.Receive('PreStartWave', function()
	GAMEMODE.NextWave = os.time() + GAMEMODE.PreWaveWaitTime
end)

net.Receive('StartWave', function()
	local wave = net.ReadDouble()
	local npcs = net.ReadDouble()
	
	GAMEMODE.CurrentWave = wave
	GAMEMODE.CurrentWaveNPCs = npcs
	GAMEMODE.CurrentWaveTotalNPCs = npcs
	
	GAMEMODE.RunningWave = true
	
	surface.PlaySound('music/stingers/HL1_stinger_song8.mp3')
end)

net.Receive('EndWave', function()
	GAMEMODE.CurrentWaveNPCs = 0
	GAMEMODE.CurrentWaveTotalNPCs = 0
	
	GAMEMODE.RunningWave = false
	
	timer.Simple(1, function() surface.PlaySound('weapons/physgun_off.wav') end)
end)

net.Receive('NPCKilled', function()
	local class = net.ReadString()
	local model = net.ReadString()
	local killer = net.ReadEntity()
	
	GAMEMODE.CurrentWaveNPCs = GAMEMODE.CurrentWaveNPCs - 1
	
	GAMEMODE:AddKillIcon(killer:GetModel(), model)
end)

function GM:AddKillIcon(one, two)
	
	if not self.KillIcons then self.KillIcons = {} end
	
	
	
end