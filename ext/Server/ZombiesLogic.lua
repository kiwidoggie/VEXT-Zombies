class "ZombiesLogic"

function ZombiesLogic:__init()
	-- Game States:
	-- 0 - PreGame
	-- 1 - In Game
	-- 2 - Game Over

	self.m_GameState = 0
	
	-- Set the current round time to 5m
	self.m_RoundTime = 300.0
	self.m_CurrentRoundTime = 0.0	
end

function ZombiesLogic:GetGameState()
	return self.m_GameState
end

function ZombiesLogic:SetGameState(p_GameState)
	self.m_GameState = p_GameState
end

-- OnUpdate is called by ZombiesServer:OnUpdate
function ZombiesLogic:OnUpdate(p_Delta, p_SimulationDelta)
	-- Check game over condition for time running out
	if self.m_CurrentRoundTime >= self.m_RoundTime and self.m_IsInGame == true then
		self:OnGameOver()
		return
	end
	
	-- Check if we are at an even minute to announce how many minutes are left
	if self.m_IsInGame == true and self.m_CurrentRoundTime % 60 == 0 and self.m_CurrentRoundTime ~= 0 then
		self:AnnounceTimeLeft()
		return
	end
	
	-- If the game state is in pregame
	if self:GetGameState() == 0 then
		self:OnPregame(p_Delta, p_SimulationDelta)
	end
	
	-- If the game state is running
	if self:GetGameState() == 1 then
		self:OnIngame(p_Delta, p_SimulationDelta)
	end
	
	-- If the game state is in game over
	if self:GetGameState() == 2 then
		self:OnGameOver(p_Delta, p_SimulationDelta)
	end
end

function ZombiesLogic:OnGameOver(p_Delta, p_SimulationDelta)
	-- Run this check every 2 seconds
	if self.m_CurrentRoundTime % 2 == 0 then
		ChatManager:SendMessage("Game Over!")
		self:AnnounceGameResults()
	end
	
	-- Run this check every 3 seconds
	if self.m_CurrentRoundTime % 3 == 0 then
		self.m_CurrentRoundTime = 0.0
		self:SetGameState(0)
	end
end

function ZombiesLogic:OnPregame(p_Delta, p_SimulationDelta)
	-- If we are not in the pregame state skip
	if self:GetGameState() ~= 0 then
		return
	end

	-- Check every 2 seconds
	if self.m_CurrentRoundTime % 2 == 0 then
		-- If the game is not ready to start then we need to configure the teams
		if self:IsReadyToStart() == false then
			-- Force everyone to humans, I don't give a fuck.
			Events:Dispatch("TeamManager:InitTeams")
			
			-- Select a zombie
			Events:Dispatch("TeamManager:SelectZombie")
		end
	end
	
	-- Check every 3 seconds
	if self.m_CurrentRoundTime % 3 == 0 then
		if self:IsReadyToStart() == true then
			self:SetGameState(1)
		end
	end
end

function ZombiesLogic:IsReadyToStart()
	s_HumanCount = TeamSquadManager:GetTeamPlayerCount(TeamId.Team1)
	s_ZombieCount = TeamSquadManager:GetTeamPlayerCount(TeamId.Team2)
	
	if s_ZombieCount ~= 1 then
		return false
	end
	
	if s_HumanCount < 1 then
		return false
	end
	
	return true
end

function ZombiesLogic:OnIngame(p_Delta, p_SimulationDelta)
	if self.m_IsInGame ~= true then
		return
	end
	
	-- Time Expires
	if self.m_CurrentRoundTime >= self.m_RoundTime then
		self:SetGameState(2)
		return
	end
	
	s_HumanCount = TeamSquadManager:GetTeamPlayerCount(TeamId.Team1)
	s_ZombieCount = TeamSquadManager:GetTeamPlayerCount(TeamId.Team2)
	
	-- Zombies kill all humans
	if s_HumanCount == 0 and s_ZombieCount > 0 then
		self:SetGameState(2)
		return
	end
	
	-- Tick the current round time forward
	self.m_CurrentRoundTime = self.m_CurrentRoundTime + p_Delta
end

function ZombiesLogic:AnnounceTimeLeft()	
	s_TimeRemaining = self.m_CurrentRoundTime / 60
	ChatManager:SendMessage(s_TimeRemaining .. " minutes before humans extract...")
end

function ZombiesLogic:AnnounceGameResults()
	s_HumanCount = TeamSquadManager:GetTeamPlayerCount(TeamId.Team1)
	s_ZombieCount = TeamSquadManager:GetTeamPlayerCount(TeamId.Team2)
	
	if s_ZombieCount == 0 then
		return
	end
	
	if s_HumanCount >= s_ZombieCount then
		ChatManager:SendMessage("Humans survived to the extraction time!")
		return
	end
	
	ChatManager:SendMessage("Zombies spread the infection to all humans!")
end

function ZombiesLogic:OnSpawnOnSelectedSpawnPoint(p_Player)
	-- YOLO
end

return ZombiesLogic