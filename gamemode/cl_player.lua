local Player = FindMetaTable('Player')

-- Cash

function Player:GetCash()
	return self.Cash or 0
end

function Player:CanAfford(cash)
	return self:GetCash() >= cash
end

-- Waves

function Player:GetWaves()
	return self.Waves or 0
end

-- Waves Streak

function Player:GetWavesStreak()
	return self.WavesStreak or 0
end

net.Receive('Cash', function()
	local ply = net.ReadEntity()
	local cash = net.ReadDouble()
	
	ply.Cash = cash
end)

net.Receive('Waves', function()
	local ply = net.ReadEntity()
	local waves = net.ReadDouble()
	
	ply.Waves = waves
end)

net.Receive('WavesStreak', function()
	local ply = net.ReadEntity()
	local wavesstreak = net.ReadDouble()
	
	ply.WavesStreak = wavesstreak
end)