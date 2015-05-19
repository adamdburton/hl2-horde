local scoreboard

function GM:CreateScoreboard()
	
	scoreboard = vgui.Create('Scoreboard')
	scoreboard:SetPos(ScrW() / 2 - scoreboard:GetWide() / 2, ScrH() / 2 - scoreboard:GetTall() / 2)
	
end

function GM:ScoreboardShow()
	
	if not scoreboard then self:CreateScoreboard() end
	
	scoreboard:Show()
	
end

function GM:ScoreboardHide()
	
	scoreboard:Hide()
	
end