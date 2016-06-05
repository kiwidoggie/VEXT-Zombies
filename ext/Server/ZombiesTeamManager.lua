class "ZombiesTeamManager"

local g_Logger = require("__shared/Logger")

function ZombiesTeamManager:__init()
	self.m_PlayerKilledEvent = Events:Subscribe("Player:Killed", self, self.OnPlayerKilled)
	--self.m_PlayerRespawnEvent = Events:Subscribe("Player:Respawn", self, self.OnPlayerRespawn)
	
	self.m_IsInGameChangedEvent = Events:Subscribe("Logic:IsInGameChanged", self, self.OnIsInGameChanged)
	self.m_InitTeamsEvent = Events:Subscribe("TeamManager:InitTeams", self, self.OnInitTeams)
	self.m_SelectZombieEvent = Events:Subscribe("TeamManager:SelectZombie", self, self.OnSelectZombies)
	
	self.m_SoldierToKill = nil
	
	self.m_IsInGame = false
end

-- Event for getting when IsInGame is changed
function ZombiesTeamManager:OnIsInGameChanged(p_IsInGame)
	self.m_IsInGame = p_IsInGame
end

function ZombiesTeamManager:OnInitTeams()
	self:InitTeams()
end

function ZombiesTeamManager:OnSelectZombies()
	self:SelectZombie()
end

-- Event when a player gets killed
function ZombiesTeamManager:OnPlayerKilled(p_Victom, p_Inflictor, p_Position, p_Weapon, p_RoadKill, p_HeadShot, p_VictomInReviveState)
	-- Check to see if we are in game, if not skip the anouncing of messages
	if self.m_IsInGame ~= true then
		return
	end
	
	-- Ensure the attacker and victom are valid
	if p_Victom == nil or p_Inflictor == nil then
		return
	end
	
	local s_VictomTeam = p_Victom.teamID
	local s_AttackerTeam = p_Inflictor.teamID
	
	-- Send a debug message each time a zombie gets killed by a human
	if s_VictomTeam == TeamId.Team2 and s_AttackerTeam == TeamId.Team1 then
		g_Logger:Write("Zombie " .. p_Victom.name .. " was killed!")
		--ServerChatManager:SendMessage("Zombie " .. p_Victom.name .. " was killed!")
	end
	
	-- If a human gets killed via a zombie, infect the player
	if s_VictomTeam == TeamId.Team1 and s_AttackerTeam == TeamId.Team2 then
		self:InfectPlayer(p_Victom)
	end
end

-- This should only be called on player killed
function ZombiesTeamManager:InfectPlayer(p_Player)
	-- Ensure that our player is valid
	if p_Player == nil then
		return
	end
	
	-- Change the players team
	p_Player.teamID = TeamId.Team2
	
	-- Send out notification to all players
	ServerChatManager:SendMessage("Human " .. p_Player.name .. " has been infected!")
end

-- Event for when players spawn/respawn
function ZombiesTeamManager:OnPlayerRespawn(p_Player)
	-- if p_Player == nil then
		-- return
	-- end
	
	-- local s_PlayerTeam = p_Player.teamID
	
	-- -- If the player that spawned is on the zombies team, give them extra health
	-- if s_PlayerTeam == TeamId.Team2 then
		-- local s_Soldier = p_Player.soldier
		-- if s_Soldier == nil then
			-- return
		-- end
		
		-- s_Soldier.maxHealth = 200
		-- --s_Soldier.physicsEnabled = false
	-- end
end

function ZombiesTeamManager:InitTeams()
	for s_Index, s_Player in pairs(PlayerManager:GetPlayers()) do
		-- Reset our soldier to kill
		self.m_SoldierToKill = nil
		
		-- If we are not on the human team kill
		if s_Player.teamID ~= TeamId.Team1 then
			-- Get the soldier
			self.m_SoldierToKill = s_Player.soldier
			
			-- Attempt to kill the player
			if self.m_SoldierToKill ~= nil then
				self.m_SoldierToKill:Kill(false)
			end
			
			-- Set the player to the human team
			s_Player.teamID = TeamId.Team1
		end
	end
end

function ZombiesTeamManager:SelectZombie()
	local s_PlayerCount = PlayerManager:GetPlayerCount()
	if s_PlayerCount == 0 then
		return
	end

	local s_SelectedIndex = math.random(0, s_PlayerCount - 1)
	
	for s_Index, s_Player in pairs(PlayerManager:GetPlayers()) do
		-- Reset our soldier to kill
		self.m_SoldierToKill = nil
		
		-- If we have our lucky winner
		if s_Index == s_SelectedIndex then
			-- Save our soldier
			self.m_SoldierToKill = s_Player.soldier
			if self.m_SoldierToKill ~= nil then
				self.m_SoldierToKill:Kill(false)
			end
			
			-- Switch the team to zombies
			s_Player.teamID = TeamId.Team2
			
			-- Echo out our message
			ServerChatManager:SendMessage("Selected new Zombie: " .. s_Player.name)
			return
		end
	end
end

return ZombiesTeamManager