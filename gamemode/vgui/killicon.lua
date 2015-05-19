local PANEL = {}

function PANEL:Init()
	self:SetSize(150, 50)
	
	self.MP1 = vgui.Create('DModelPanel', self)
	self.MP1:SetSize(50, 50)
	self.MP1:SetCamPos(Vector(0, 30, 0))
	self.MP1:SetLookAt(Vector(0, 0, 0))
	self.MP1:SetPos(0, 0)
	
	self.MP2 = vgui.Create('DModelPanel', self)
	self.MP1:SetSize(50, 50)
	self.MP2:SetCamPos(Vector(0, 30, 0))
	self.MP2:SetLookAt(Vector(0, 0, 0))
	self.MP2:SetPos(100, 0)
	
	timer.Simple(3, function() self:MoveTo(-150, 100, 0.1, 0, 0.1) end)
end

function PANEL:SetModels(one, two)
	self.MP1:SetModel(one)
	self.MP2:SetModel(two)
	
	local PrevMins, PrevMaxs = self.MP1.Entity:GetRenderBounds()
	self.MP1:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.75, 0.75, 0.5))
	self.MP1:SetLookAt((PrevMaxs + PrevMins) / 2)
	
	local PrevMins, PrevMaxs = self.MP2.Entity:GetRenderBounds()
	self.MP2:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.75, 0.75, 0.5))
	self.MP2:SetLookAt((PrevMaxs + PrevMins) / 2)
end

function PANEL:Think()
	self.MP1.Entity:SetAngles(Angle(0, RealTime() * 200, 0))
	self.MP2.Entity:SetAngles(Angle(0, RealTime() * 200, 0))
end

local bg = Color(0, 0, 0, 200)

function PANEL:Paint()
	draw.RoundedBox(6, 0, 0, 150, 50, bg)
end

vgui.Register('KillIcon', PANEL)
