class "ZombiesShared"

SharedUnlocks = require '__shared/SharedUnlocks'
SharedSpecials = require '__shared/SharedSpecials'

g_Logger = require '__shared/Logger'

function ZombiesShared:__init()
	g_Logger:Write("Zombies: Shared Zombies Init.")
	
	-- Initialize the unlocks
	self.m_SharedUnlocks = SharedUnlocks()
	self.m_SharedSpecials = SharedSpecials()
	
	-- Subscribe to the Read Instance event
	Events:Subscribe('Partition:ReadInstance', self, self.OnReadInstance)
end

function ZombiesShared:OnReadInstance(p_Instance, p_Guid)
	-- Ensure that our instance is not null
	if p_Instance == nil then
		return
	end
	
	-- Call OnReadInstance for SharedUnlocks
	self.m_SharedUnlocks:OnReadInstance(p_Instance, p_Guid)
	
	-- Call OnReadInstance for SharedSpecials
	self.m_SharedSpecials:OnReadInstance(p_Instance, p_Guid)
end

g_ZombiesShared = ZombiesShared()