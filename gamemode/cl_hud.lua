surface.CreateFont('HL2FontTrebuchet', { font = 'Trebuchet MS', size = 23, weight = 900 })
surface.CreateFont('HL2Font', { font = 'halflife2', size = 70, additive = true })
surface.CreateFont('HL2Font2', { font = 'halflife2', size = 35, additive = true })

local yellow = Color(255, 270, 0, 255)

function GM:HUDPaint()
	
	self.BaseClass:HUDPaint()
	
	if self.RunningWave then
	
		-- Wave
		draw.SimpleText('WAVE', 'HL2FontTrebuchet', ScrW() - 155, 50, yellow)
		draw.SimpleText(self.CurrentWave, 'HL2Font', ScrW() - 145, 70, yellow)
		
		-- Enemies
		draw.SimpleText('ENEMIES', 'HL2FontTrebuchet', ScrW() - 155, 160, yellow)
		draw.SimpleText(self.CurrentWaveNPCs, 'HL2Font', ScrW() - 145, 180, yellow)
		
		draw.SimpleText('/ ' .. self.CurrentWaveTotalNPCs, 'HL2Font2', ScrW() - 75, 210, yellow)
		
	else
		
		-- Next Wave
		draw.SimpleText('NEXT WAVE', 'HL2FontTrebuchet', ScrW() - 155, 50, yellow)
		draw.SimpleText(self.NextWave - os.time(), 'HL2Font', ScrW() - 145, 70, yellow)
		
	end
	
	-- Survived Waves 
	draw.SimpleText('LEVEL', 'HL2FontTrebuchet', ScrW() - 155, 270, yellow)
	draw.SimpleText(LocalPlayer():GetWaves(), 'HL2Font', ScrW() - 145, 290, yellow)
	
	draw.SimpleText(LocalPlayer():GetWavesStreak(), 'HL2Font2', ScrW() - 75, 320, yellow)
	
	-- Cash
	draw.SimpleText('CASH', 'HL2FontTrebuchet', ScrW() - 155, 380, yellow)
	draw.SimpleText(LocalPlayer():GetCash(), 'HL2Font', ScrW() - 145, 400, yellow)
	
end