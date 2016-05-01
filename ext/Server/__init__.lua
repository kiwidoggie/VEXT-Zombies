class "ZombiesServer"

local ZombiesTeamManager = require "ZombiesTeamManager"
local ZombiesLogic = require "ZombiesLogic"

function ZombiesServer:__init()
	self.m_TeamManager = ZombiesTeamManager()
	self.m_GameLogic = ZombiesLogic()
	
	self.m_UpdateEvent = Events:Subscribe("Engine:Update", self, self.OnUpdate)
	
	self.m_HumanCurrentDamage = 1.0
	
	self.m_SoldierDamageHook = Hooks:Install('Soldier:DamageSimple', self, self.SoldierDamage)
end

function ZombiesServer:OnUpdate(p_Delta, p_SimulationDelta)
	-- Call our game logic update function
	self.m_GameLogic:OnUpdate(p_Delta, p_SimulationDelta)
	
	local s_HumanCount = TeamSquadManager:GetTeamPlayerCount(TeamId.Team1)
	local s_ZombieCount = TeamSquadManager:GetTeamPlayerCount(TeamId.Team2)
	if s_HumanCount ~= 0 then
		local s_Calculation = s_ZombieCount / s_HumanCount
	
		self.m_HumanCurrentDamage = math.max(2, s_Calculation)
	end
end

function ZombiesServer:SoldierDamage(p_Hook, p_Soldier, p_Giver, p_Damage, p_DamageOverTime, p_DamageType)
	--print('Got damage event')

	if p_Soldier == nil then
		p_Hook:CallOriginal(p_Soldier, p_Giver, p_Damage, p_DamageOverTime, p_DamageType)
		return
	end

	--print('Getting player')

	local s_Player = p_Soldier.player

	if s_Player == nil then
		p_Hook:CallOriginal(p_Soldier, p_Giver, p_Damage, p_DamageOverTime, p_DamageType)
		return
	end
	
	
	
	if self.m_HumanCurrentDamage ~= 0 then
		p_Damage = self.m_HumanCurrentDamage
	end
		
	--print(string.format('"%s" got %f (%f) damage of type %f.', s_Player.name, p_Damage, p_DamageOverTime, p_DamageType))

	p_Hook:CallOriginal(p_Soldier, p_Giver, p_Damage, p_DamageOverTime, p_DamageType)
end

local g_AdminServer = ZombiesServer()