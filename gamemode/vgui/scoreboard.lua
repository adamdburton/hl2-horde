local bg = Color(0, 0, 0, 200)
local yellow = Color(255, 270, 0, 255)

local row_height = 25
local header_height = 148

surface.CreateFont('ScoreboardFont', { font = 'Trebuchet MS', size = 20, weight = 500 })
surface.CreateFont('ScoreboardFontHeading', { font = 'Trebuchet MS', size = 20, weight = 900 })

local PANEL = {}

function PANEL:Init()
	
	self:SetSize(800, header_height + (#player.GetAll() * row_height) + 10)
	
	self.Logo = vgui.Create("DImage", self)
	self.Logo:SetImage("../gamemodes/hl2horde/logo.png")
	self.Logo:SetSize(288, 128)
	self.Logo:SetPos(self:GetWide() / 2 - self.Logo:GetWide() / 2, 0)
	
end

function PANEL:Think()
	
	self:SetSize(800, header_height + (#player.GetAll() * row_height) + 10)
	
end

function PANEL:Paint()
	
	draw.RoundedBox(6, 0, 0, self:GetWide(), self:GetTall(), bg)
	
	draw.SimpleText('Name', 'ScoreboardFontHeading', 10, header_height - (row_height / 2), yellow, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	draw.SimpleText('Cash', 'ScoreboardFontHeading', self:GetWide() - 140, header_height - (row_height / 2), yellow, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	draw.SimpleText('Level', 'ScoreboardFontHeading', self:GetWide() - 80, header_height - (row_height / 2), yellow, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	draw.SimpleText('Streak', 'ScoreboardFontHeading', self:GetWide() - 10, header_height - (row_height / 2), yellow, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	
	surface.SetDrawColor(yellow)
	surface.DrawLine(10, header_height, self:GetWide() - 10, header_height)
	
	for k, v in pairs(player.GetAll()) do
		
		draw.SimpleText(v:Nick(), 'ScoreboardFont', 10, header_height + (k * row_height), yellow, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText(v:GetCash(), 'ScoreboardFont', self:GetWide() - 140, header_height + (k * row_height), yellow, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		draw.SimpleText(v:GetWaves(), 'ScoreboardFont', self:GetWide() - 80, header_height + (k * row_height), yellow, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		draw.SimpleText(v:GetWavesStreak(), 'ScoreboardFont', self:GetWide() - 10, header_height + (k * row_height), yellow, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
	end
	
end

vgui.Register('Scoreboard', PANEL)