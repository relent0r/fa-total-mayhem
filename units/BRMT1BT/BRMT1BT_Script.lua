----------------------------------------------------------------------------
--
--  File     :  /cdimage/units/UEL0201/UEL0201_script.lua
--  Author(s):  John Comes, David Tomandl, Jessica St. Croix
--
--  Summary  :  BRN Tiger Light Tank
--
--  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
----------------------------------------------------------------------------

local TLandUnit = import('/lua/terranunits.lua').TLandUnit
local WeaponsFile = import('/lua/terranweapons.lua')
local TDFGaussCannonWeapon = WeaponsFile.TDFLandGaussCannonWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local TMEffectTemplate = import('/mods/fa-total-mayhem/lua/TMEffectTemplates.lua')

BRMT1BT = Class(TLandUnit){
	Weapons = {
		MainGun = Class(TDFGaussCannonWeapon){
			FxMuzzleFlashScale = 2.1,
			FxMuzzleFlash = {
				'/effects/emitters/proton_artillery_muzzle_01_emit.bp',
				'/effects/emitters/proton_artillery_muzzle_03_emit.bp',
				'/effects/emitters/cybran_artillery_muzzle_smoke_01_emit.bp',
			},
			FxGroundEffect = EffectTemplate.ConcussionRingLrg01,
			FxVentEffect3 = EffectTemplate.CDisruptorGroundEffect,
			FxVentEffect = EffectTemplate.CDisruptorVentEffect,
			FxVentEffect2 = EffectTemplate.WeaponSteam01,
			FxVentEffect4 = EffectTemplate.CHvyProtonCannonHitUnit01,
			FxVentEffect5 = EffectTemplate.CElectronBolterMuzzleFlash01,
			FxMuzzleEffect = EffectTemplate.CElectronBolterMuzzleFlash01,
			FxCoolDownEffect = EffectTemplate.CDisruptorCoolDownEffect,
			PlayFxMuzzleSequence = function(self, muzzle)
				local army = self.unit:GetArmy()
				for k, v in self.FxVentEffect3 do
					self.unit.Trash:Add(CreateAttachedEmitter(self.unit, 'BRMT1BT', army, v):ScaleEmitter(0.7))
				end
				for k, v in self.FxMuzzleEffect do
					self.unit.Trash:Add(CreateAttachedEmitter(self.unit, 'Turret_Muzzle', army, v):ScaleEmitter(1.85))
				end
				for k, v in self.FxVentEffect do
					self.unit.Trash:Add(CreateAttachedEmitter(self.unit, 'vent01', army, v):ScaleEmitter(0.7))
				end
				for k, v in self.FxVentEffect do
					self.unit.Trash:Add(CreateAttachedEmitter(self.unit, 'vent02', army, v):ScaleEmitter(0.7))
				end
				for k, v in self.FxVentEffect2 do
					self.unit.Trash:Add(CreateAttachedEmitter(self.unit, 'Turret_Muzzle', army, v):ScaleEmitter(1))
				end
			end,
		},
		autoattack = Class(TDFGaussCannonWeapon){ FxMuzzleFlashScale = 0.0 },
	},
	OnStopBeingBuilt = function(self, builder, layer)
		TLandUnit.OnStopBeingBuilt(self, builder, layer)
		self.SetAIAutoattackWeapon(self)
	end,
	OnDetachedFromTransport = function(self, transport, bone)
		TLandUnit.OnDetachedFromTransport(self, transport, bone)
		self.SetAIAutoattackWeapon(self)
	end,
	SetAIAutoattackWeapon = function(self)
		if self:GetAIBrain().BrainType == 'Human' and IsUnit(self) then
			self:SetWeaponEnabledByLabel('autoattack', false)
		else
			self:SetWeaponEnabledByLabel('autoattack', true)
		end
	end,
	OnKilled = function(self, instigator, damagetype, overkillRatio)
		TLandUnit.OnKilled(self, instigator, damagetype, overkillRatio)
		self:CreatTheEffectsDeath()
	end,
	CreatTheEffectsDeath = function(self)
		local army = self:GetArmy()
		for k, v in TMEffectTemplate['CybranT1BattleTankDeath'] do
			self.Trash:Add(CreateAttachedEmitter(self, 'BRMT1BT', army, v):ScaleEmitter(2.0))
		end
	end,
}

TypeClass = BRMT1BT
