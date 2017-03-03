class "ZombiesClient"

local ZombiesVisuals = require "ZombiesVisuals"
local ZombiesUI = require "ZombiesUI"

local g_Logger = require "__shared/Logger"

function ZombiesClient:__init()
	-- Init the visual tweaks
	self.m_Visuals = ZombiesVisuals()
	self.m_UI = ZombiesUI()
	
	self.m_OnReadInstance = Events:Subscribe('Partition:ReadInstance', self, self.OnReadInstance)
	self.m_ExtensionLoadedEvent = Events:Subscribe('ExtensionLoaded', self, self.OnLoaded)
	self.m_StateAddedEvent = Events:Subscribe('VE:StateAdded', self, self.OnStateAdded)
	self.m_StateRemovedEvent = Events:Subscribe('VE:StateRemoved', self, self.OnStateRemoved)
	
	g_Logger:Write("ZombiesClient init.")
end

function ZombiesClient:OnLoaded()
	self.m_Visuals:OnLoaded()
end

function ZombiesClient:OnReadInstance(p_Instance, p_Guid)
	self.m_Visuals:OnReadInstance(p_Instance, p_Guid)
	
	-- Client UI Tweaks
	self.m_UI:OnReadInstance(p_Instance, p_Guid)
end

function ZombiesClient:OnStateAdded(p_State)
	self.m_Visuals:OnStateChanged(p_State)
end

function ZombiesClient:OnStateRemoved(p_State)
	self.m_Visuals:OnStateChanged(p_State)
end

g_ZombiesClient = ZombiesClient()