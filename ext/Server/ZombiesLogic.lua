class "ZombiesLogic"

function ZombiesLogic:__init()
	-- Don't actually start the game until the conditions are met
	self.m_IsInGame = false
	
	-- Set the current round time to 5m
	self.m_RoundTime = 300.0
	self.m_CurrentRoundTime = 0.0	
end

function ZombiesLogic:IsInGame()
	return self.m_IsInGame
end

function ZombiesLogic:SetIsInGame(p_IsInGame)
	self.m_IsInGame = p_IsInGame
	
	-- Send an event in order to update everything else
	Events:Dispatch("Logic:IsInGameChanged", p_IsInGame)
end

-- OnUpdate is called by ZombiesServer:OnUpdate
function ZombiesLogic:OnUpdate(p_Delta, p_SimulationDelta)
	
	-- Check game over condition
	if self.m_CurrentRoundTime >= self.m_RoundTime and self.m_IsInGame == true then
		self:OnGameOver()
		return
	end
	
	-- Check if we are at an even minute to announce how many minutes are left
	if self.m_IsInGame == true and self.m_CurrentRoundTime % 60 == 0 and self.m_CurrentRoundTime ~= 0 then
		self:AnnounceTimeLeft()
		return
	end
	
	
	if self.m_IsInGame == true then
		self:OnIngame(p_Delta, p_SimulationDelta)
	else
		self:OnPregame(p_Delta, p_SimulationDelta)
	end
end

function ZombiesLogic:OnGameOver()
	self:SetIsInGame(false)
	
	self.m_CurrentRoundTime = 0.0
	
	ServerChatManager:SendMessage("Game Over!")
	
	self:AnnounceGameResults()
end

function ZombiesLogic:OnPregame(p_Delta, p_SimulationDelta)
	if self.m_IsInGame == true then
		return
	end

	-- Check every 2 seconds
	if self.m_CurrentRoundTime % 2 == 0 then
		-- Force everyone to humans, I don't give a fuck.
		Events:Dispatch("TeamManager:InitTeams")

		-- TODO: Check to see if the game is ready to start
		local s_HumanCount = TeamSquadManager:GetTeamPlayerCount(TeamId.Team1)

		if s_HumanCount > 1 then
			self:SetIsInGame(true)
			Events:Dispatch("TeamManager:SelectZombie")
		end
	end
end

function ZombiesLogic:OnIngame(p_Delta, p_SimulationDelta)
	if self.m_IsInGame ~= true then
		return
	end
	
	-- Time Expires
	if self.m_CurrentRoundTime >= self.m_RoundTime then
		self:OnGameOver()
		return
	end
	
	local s_HumanCount = TeamSquadManager:GetTeamPlayerCount(TeamId.Team1)
	local s_ZombieCount = TeamSquadManager:GetTeamPlayerCount(TeamId.Team2)
	
	-- Zombies kill all humans
	if s_HumanCount == 0 and s_ZombieCount > 0 then
		self:OnGameOver()
		return
	end
	
	-- Tick the current round time forward
	self.m_CurrentRoundTime = self.m_CurrentRoundTime + p_Delta
end

function ZombiesLogic:AnnounceTimeLeft()	
	local s_TimeRemaining = self.m_CurrentRoundTime / 60
	ServerChatManager:SendMessage(s_TimeRemaining .. " minutes before humans extract...")
end

function ZombiesLogic:AnnounceGameResults()
	local s_HumanCount = TeamSquadManager:GetTeamPlayerCount(TeamId.Team1)
	local s_ZombieCount = TeamSquadManager:GetTeamPlayerCount(TeamId.Team2)
	
	if s_ZombieCount == 0 then
		return
	end
	
	if s_HumanCount >= s_ZombieCount then
		ServerChatManager:SendMessage("Humans survived to the extraction time!")
		return
	end
	
	ServerChatManager:SendMessage("Zombies spread the infection to all humans!")
end

function ZombiesLogic:OnSpawnOnSelectedSpawnPoint(p_Player)
	-- YOLO
end

return ZombiesLogic