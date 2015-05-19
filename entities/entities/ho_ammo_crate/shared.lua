AddCSLuaFile()

ENT.Type	   		= 'anim'
ENT.Base	   		= 'base_anim'
ENT.AutomaticFrameAdvance = true

ENT.Cost = 30

function ENT:Initialize()
	if not SERVER then return end
	
	self:SetModel('models/Items/ammocrate_ar2.mdl')
	self:SetUseType(SIMPLE_USE)
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
end

function ENT:Use(activator, caller)
	if not activator:IsValid() or not activator:IsPlayer() then return end
	
	if not GAMEMODE.RunningWave and activator:CanAfford(self.Cost) then
	
		self:SetSequence(self:LookupSequence('Close'))
		timer.Simple(3, function()
			self:SetSequence(self:LookupSequence('Open')) 
		end)
		
		timer.Simple(1, function()
			gamemode.Call('GiveActiveWeaponAmmo', activator)
		end)
		
	end
end

if CLIENT then
	surface.CreateFont('HL2FontAmmoCrate', { font = 'Trebuchet MS', size = 40, weight = 900 })
	surface.CreateFont('HL2FontAmmoCrate2', { font = 'Trebuchet MS', size = 82, weight = 900 })
	local yellow = Color(255, 270, 0, 255)
	local green = Color(119, 116, 90)
end

function ENT:Draw()	
	self:DrawModel()
	
	local pos = self:GetPos() + (self:GetUp() * 2) + (self:GetForward() * 16)
	local ang = self:GetAngles()
	
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Up(), 90)
	
	cam.Start3D2D(pos, ang, 0.1)
		draw.SimpleText('Buy Ammo', 'HL2FontAmmoCrate', 0, 0, yellow, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(self.Cost, 'HL2FontAmmoCrate2', 0, 50, yellow, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end