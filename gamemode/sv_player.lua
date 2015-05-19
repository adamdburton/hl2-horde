local Player = FindMetaTable('Player')

-- Cash

function Player:GetCash()
	return tonumber(self:GetPData('Cash', 0))
end

function Player:SetCash(cash)
	self:SetPData('Cash', cash)
	self:SendCash()
end

function Player:AddCash(cash)
	self:SetCash(self:GetCash() + cash)
	self:SendCash()
end

function Player:TakeCash(cash)
	self:SetCash(self:GetCash() - cash)
	self:SendCash()
end

function Player:CanAfford(cash)
	return self:GetCash() >= cash
end

function Player:SendCash(cash)
	net.Start('Cash')
		net.WriteEntity(self)
		net.WriteDouble(self:GetCash())
	net.Broadcast()
end

-- Waves

function Player:GetWaves()
	return tonumber(self:GetPData('Waves', 1))
end

function Player:SetWaves(waves)
	self:SetPData('Waves', waves)
	self:CheckWavesStreak(waves)
	self:SendWaves()
end

function Player:AddWaves(waves)
	self:SetWaves(self:GetWaves() + waves)
	self:SendWaves()
end

function Player:TakeWaves(waves)
	self:SetWaves(self:GetWaves() - waves)
	self:SendWaves()
end

function Player:SendWaves()
	net.Start('Waves')
		net.WriteEntity(self)
		net.WriteDouble(self:GetWaves())
	net.Broadcast()
end

-- Waves Streak

function Player:SetWavesStreak(wavesstreak)
	self:SetPData('WavesStreak', wavesstreak)
	self:SendWavesStreak()
end

function Player:GetWavesStreak()
	return tonumber(self:GetPData('WavesStreak', 1))
end

function Player:CheckWavesStreak(waves)
	if waves > self:GetWavesStreak() then
		self:SetWavesStreak(waves)
	end
end

function Player:SendWavesStreak()
	net.Start('WavesStreak')
		net.WriteEntity(self)
		net.WriteDouble(self:GetWavesStreak())
	net.Broadcast()
end

-- Network strings

util.AddNetworkString('Cash')
util.AddNetworkString('Waves')
util.AddNetworkString('WavesStreak')