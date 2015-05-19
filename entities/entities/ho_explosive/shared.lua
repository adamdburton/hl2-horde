AddCSLuaFile()

ENT.Type	   		= 'anim'
ENT.Base	   		= 'base_anim'

ENT.Cost = 50

function ENT:Initialize()

	self:SetRenderMode(RENDERMODE_TRANSALPHA)

	if not SERVER then return end
	
	self:SetModel('models/combine_helicopter/helicopter_bomb01.mdl')
	self:SetUseType(SIMPLE_USE)
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	
end

function ENT:Use(activator, caller)

	if CLIENT then return end

	if not activator:IsValid() or not activator:IsPlayer() then return end
	
	if not self.Armed and activator:CanAfford(self.Cost) then
		activator:TakeCash(self.Cost)
		
		self:SetNWBool('Armed', true)
		self:SetNWEntity('ArmedBy', activator)
	end
	
end

function ENT:Draw()
	
	if self:GetNWBool('Armed', false) then
		self:SetColor(Color(255, 255, 255, 255))
	elseif LocalPlayer():CanAfford(self.Cost) then
		self:SetColor(Color(131, 255, 0, 150))
	else
		self:SetColor(Color(255, 20, 0, 150))
	end
	
	self:DrawModel()
	
end

function ENT:Think()

	if CLIENT then return end
	
	if self:GetNWBool('Armed', false) then
		for k, v in pairs(ents.FindInSphere(self:GetPos(), 128)) do
			if v:IsNPC() then
				return self:Explode()
			end
		end
	end
	
end

function ENT:Explode()
	
	local effect = EffectData()
		effect:SetOrigin(self:GetPos())
		effect:SetStart(self:GetPos())
		effect:SetMagnitude(1024)
		effect:SetScale(256)
	util.Effect('Explosion', effect)
	util.BlastDamage(self, self:GetNWEntity('ArmedBy', nil), self:GetPos(), 200, 150)
	
	self:SetNWBool('Armed', false)
	self:SetNWEntity('ArmedBy', nil)
	
end