class "SharedSpecials"

local g_Logger = require "__shared/Logger"

function SharedSpecials:__init()
	g_Logger:Write("SharedSpecials init.")
end

function SharedSpecials:OnReadInstance(p_Instance, p_Guid)
	if p_Instance == nil then
		return
	end
	
	-- Persistence/Unlocks/Soldiers/Specializations/SprintBoostL2
	if p_Guid == Guid("405b4c2d-e669-4b6b-8ef2-03678d9b3d9e", "D") then
		local s_Instance = FloatUnlockValuePair(p_Instance)
		s_Instance:MakeWritable()
		s_Instance.unlockedValue = 1.50
	end
	
	-- Persistence/Unlocks/Soldiers/Specializations/HealSpeedBoostL1
	if p_Guid == Guid("05490b98-c2b1-4c9c-87d0-b03f9a5bbe68", "D") then
		local s_Instance = FloatUnlockValuePair(p_Instance)
		s_Instance:MakeWritable()
		s_Instance.unlockedValue = 0.6
	end
	
	-- lulz
	if p_Instance.typeName == "ScoringTypeData" then
		local s_Instance = ScoringTypeData(p_Instance)
		s_Instance:MakeWritable()
		s_Instance.score = 420
	end
	
	-- Characters/Soldiers/MpSoldier SoldierBlueprint 261E43BF-259B-41D2-BF3B-9AE4DDA96AD2 #primary instance
	if p_Guid == Guid("261e43bf-259b-41d2-bf3b-9ae4dda96ad2", "D") then
		local s_Instance = SoldierEntityData(p_Instance)
		s_Instance:MakeWritable()
		s_Instance.maxHealth = 200
	end
	
	-- mpsoldier healthmodule
	-- Disable Spawn Protection
	-- Characters/Soldiers/MpSoldier VeniceSoldierHealthModuleData 705967EE-66D3-4440-88B9-FEEF77F53E77
	if p_Guid == Guid("705967ee-66d3-4440-88b9-feef77f53e77", "D") then
		local s_Instance = VeniceSoldierHealthModuleData(p_Instance)
		s_Instance:MakeWritable()
		s_Instance.immortalTimeAfterSpawn = 0
		s_Instance.interactiveManDown = false
	end
	
	if p_Instance.typeName == "KitPickupEntityData" then
		local s_Instance = KitPickupEntityData(p_Instance)
		s_Instance:MakeWritable()
		s_Instance.timeToLive = 0
		s_Instance.allowPickup = false
		s_Instance.removeWeaponOnDrop = true
	end
end

return SharedSpecials