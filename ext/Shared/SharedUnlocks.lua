class "SharedUnlocks"

local g_Logger = require "__shared/Logger"

function SharedUnlocks:__init()
	g_Logger:Write("Shared Unlocks Init.")
	
	self.m_ModifiedKitId = Guid("28ec16e7-0bbf-4cb0-9321-473c6ec54125", "D")
	self.m_ModifiedKit = nil
	self.m_NoSpecializationInstance = nil
	self.m_SprintBoostL2Instance = nil
end

function SharedUnlocks:OnReadInstance(p_Instance, p_Guid)
	if p_Instance == nil then
		return
	end
	
	self:SetUnlocks(p_Instance, p_Guid)
end

function SharedUnlocks:LockHumans(p_Instance)
	local s_Instance = CustomizationUnlockParts(p_Instance)
	
	g_Logger:Write("LockHumans CategoryID: " .. s_Instance.uICategorySid)
	
	if 	s_Instance.uICategorySid == "ID_M_SOLDIER_GADGET2" or
		s_Instance.uICategorySid == "GADGET1" or
		s_Instance.uICategorySid == "ID_M_SOLDIER_GADGET1" then
		-- Remove all current unlocks
		s_Instance:ClearSelectableUnlocks()
		
		g_Logger:Write("Cleared unlocks for " .. s_Instance.uICategorySid)
	end

	local s_Count = s_Instance:GetSelectableUnlocksCount()
	if s_Count == 0 then
		return
	end
	
	s_Count = s_Count - 1
	for i=s_Count,0,-1 do 
		local s_UnlockInstance = s_Instance:GetSelectableUnlocksAt(i)		
		if s_UnlockInstance.typeName == "SoldierWeaponUnlockAsset" then
			local s_Unlock = SoldierWeaponUnlockAsset(s_UnlockInstance)
			local s_Name = s_Unlock.name:lower()
			if string.find(s_Name, "m67") ~= nil or
				string.find(s_Name, "medicbag") ~= nil then
				s_Instance:RemoveSelectableUnlocksAt(i)
			end
		end
	end
	
	if self:IsSpecializationUnlocks(s_Instance) then
		print("Found Specializations")
		local s_NoSpecializationName = "Weapons/Common/NoSpecialization"
		
		self.s_NoSpecializationInstance = self:GetUnlockByName(s_Instance, s_NoSpecializationName:lower())
		
		if self.s_NoSpecializationInstance == nil then
			g_Logger:Write("NoSpecialization Instance is nil.")
			return
		end
		

		
		s_Instance:ClearSelectableUnlocks()

		s_Instance:AddSelectableUnlocks(self.s_NoSpecializationInstance)
		
		g_Logger:Write("Modified specializations.")
	end
end

function SharedUnlocks:LockZombies(p_Instance)
	local s_Instance = CustomizationUnlockParts(p_Instance)
	
	g_Logger:Write("LockZombies CategoryID: " .. s_Instance.uICategorySid)
	
	if s_Instance.uICategorySid == "ID_M_SOLDIER_PRIMARY" or
		s_Instance.uICategorySid == "ID_M_SOLDIER_SECONDARY" or
		s_Instance.uICategorySid == "ID_M_SOLDIER_GADGET2" or
		s_Instance.uICategorySid == "GADGET1" or
		s_Instance.uICategorySid == "ID_M_SOLDIER_GADGET1" then
		-- Remove all current unlocks
		s_Instance:ClearSelectableUnlocks()
		
		g_Logger:Write("Cleared unlocks for " .. s_Instance.uICategorySid)
	end
	
	local s_Count = s_Instance:GetSelectableUnlocksCount()
	if s_Count == 0 then
		return
	end
	
	s_Count = s_Count - 1
	for i=s_Count,0,-1 do 
		local s_UnlockInstance = s_Instance:GetSelectableUnlocksAt(i)		
		if s_UnlockInstance.typeName == "SoldierWeaponUnlockAsset" then
			local s_Unlock = SoldierWeaponUnlockAsset(s_UnlockInstance)
			local s_Name = s_Unlock.name:lower()
			if string.find(s_Name, "m67") ~= nil or
				string.find(s_Name, "medicbag") ~= nil then
				s_Instance:RemoveSelectableUnlocksAt(i)
			end
		end
	end
	
	if self:IsSpecializationUnlocks(s_Instance) then
		print("Found Specializations")
		local s_NoSpecializationName = "Weapons/Common/NoSpecialization"
		local s_SprintBoostL2Name = "Persistence/Unlocks/Soldiers/Specializations/SprintBoostL2"
		
		self.s_NoSpecializationInstance = self:GetUnlockByName(s_Instance, s_NoSpecializationName:lower())
		self.s_SprintBoostL2Instance = self:GetUnlockByName(s_Instance, s_SprintBoostL2Name:lower())
		
		if self.s_NoSpecializationInstance == nil then
			g_Logger:Write("NoSpecialization Instance is nil.")
			return
		end
		
		if self.s_SprintBoostL2Instance == nil then
			g_Logger:Write("SprintBoostL2 Instance is nil.")
			return
		end
		
		s_Instance:ClearSelectableUnlocks()
		
		--s_Instance:AddSelectableUnlocks(self.s_NoSpecializationInstance)
		s_Instance:AddSelectableUnlocks(self.s_SprintBoostL2Instance)
		
		g_Logger:Write("Modified specializations.")
	end
end

function SharedUnlocks:IsSpecializationUnlocks(p_Instance)
	local s_Instance = CustomizationUnlockParts(p_Instance)
	
	local s_Count = s_Instance:GetSelectableUnlocksCount()
	if s_Count == 0 then
		return false
	end
	
	local s_UnlockInstance = s_Instance:GetSelectableUnlocksAt(0)
	--g_Logger:Write("UnlockInstance: " .. s_UnlockInstance.typeName)
	if s_UnlockInstance.typeName == "ValueUnlockAsset" then
		local s_Unlock = ValueUnlockAsset(s_UnlockInstance)
		local s_Name = s_Unlock.name:lower()
		--g_Logger:Write("Unlock: " .. s_Name)
		if string.find(s_Name, "persistence/unlocks/soldiers/specializations") ~= nil then
			return true
		end
	end
	
	return false
end

function SharedUnlocks:GetUnlockByName(p_Instance, p_Name)
	local s_Instance = CustomizationUnlockParts(p_Instance)
	--g_Logger:Write("1")
	local s_Count = s_Instance:GetSelectableUnlocksCount()
	if s_Count == 0 then
		return nil
	end
	s_Count = s_Count - 1
	
	--g_Logger:Write("2")
	
	for i=s_Count,0,-1 do 
		local s_UnlockInstance = s_Instance:GetSelectableUnlocksAt(i)
		--g_Logger:Write("UnlockInstance: " .. s_UnlockInstance.typeName)
		if s_UnlockInstance.typeName == "ValueUnlockAsset" then
			--g_Logger:Write("3")
			local s_Unlock = ValueUnlockAsset(s_UnlockInstance)
			local s_Name = s_Unlock.name:lower()
			--g_Logger:Write("Unlock: " .. s_Name)
			if string.find(s_Name, p_Name) ~= nil then
				--g_Logger:Write("4")
				return s_UnlockInstance
			end
		end
		
		if s_UnlockInstance.typeName == "UnlockAsset" then
			--g_Logger:Write("3")
			local s_Unlock = UnlockAsset(s_UnlockInstance)
			local s_Name = s_Unlock.name:lower()
			--g_Logger:Write("Unlock: " .. s_Name)
			if string.find(s_Name, p_Name) ~= nil then
				--g_Logger:Write("4")
				return s_UnlockInstance
			end
		end
	end
	
	return nil
end

function SharedUnlocks:RunUnlocks(p_Name, p_Table)
	local s_UnlockCount = p_Table:GetUnlockPartsCount() - 1
		
	for i=s_UnlockCount,0,-1 do
		local s_UnlockPart = p_Table:GetUnlockPartsAt(i)
		
		if string.find(p_Name, "gameplay/kits/ru") ~= nil then
			g_Logger:Write("Locking Zombies Team " .. p_Name)
			self:LockZombies(s_UnlockPart)
		end
		
		if string.find(p_Name, "gameplay/kits/us") ~= nil then
			g_Logger:Write("Locking Humans Team " .. p_Name)
			self:LockHumans(s_UnlockPart)
		end
	
		p_Table:SetUnlockPartsAt(i, s_UnlockPart)
	end
end

function SharedUnlocks:SetUnlocks(p_Instance, p_Guid)
	if p_Instance.typeName == "VeniceSoldierCustomizationAsset" then
		local s_Instance = VeniceSoldierCustomizationAsset(p_Instance)
		
		local s_Name = s_Instance.name:lower()

		local s_WeaponTable = s_Instance.weaponTable
		local s_SpecializationTable = s_Instance.specializationTable
		
		self:RunUnlocks(s_Name, s_WeaponTable)
		self:RunUnlocks(s_Name, s_SpecializationTable)
	end
end

return SharedUnlocks