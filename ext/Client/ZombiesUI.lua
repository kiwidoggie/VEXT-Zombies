class "ZombiesUI"

local g_Logger = require "__shared/Logger"

function ZombiesUI:__init()
end

function ZombiesUI:OnReadInstance(p_Instance, p_Guid)
	if p_Instance == nil then
		return
	end
	
	-- Get the UIScreenAsset
	if p_Instance.typeName == "UIScreenAsset" then
		local s_Instance = UIScreenAsset(p_Instance)
		
		local s_NodeCount = s_Instance:GetNodesCount() - 1
		
		-- If we don't have anything skip
		if s_NodeCount < 1 then
			return
		end
		
		for i = s_NodeCount, 0, -1 do
			local s_Node = s_Instance:GetNodesAt(i)
			
			-- Check to see if we have a widgetnode
			if s_Node.typeName ~= "WidgetNode" then
				goto continue
			end
			
			if s_Node.name == "SquadList" or
				s_Node.name == "ScoreMessage" or
				s_Node.name == "HudMessageKills" or
				s_Node.name == "Health" or
				s_Node.name == "RewardMessage" or
				s_Node.name == "PassangerList" or
				s_Node.name == "VehicleHealth" or
				s_Node.name == "Ammo" or
				s_Node.name == "HudOutOfBoundsAlertMessage" or
				s_Node.name == "SupportIconManager" or
				s_Node.name == "ScoreAggregator" or
				s_Node.name == "HudInformationMessage" or
				--s_Node.name == "LatencyIndicator" or
				s_Node.name == "InteractionManager" or
				s_Node.name == "HudSubtitleMessage" or
				s_Node.name == "ObjectiveMessage" or 
				s_Node.name == "TooltipMessage" or
				s_Node.name == "AlertManager" or
				s_Node.name == "OverviewMap" or
				--s_Node.name == "Grid" or
				s_Node.name == "SpawnPointsHeader" or
				s_Node.name == "TabBar" then
				
				g_Logger:Write("Removing UI Node: " .. s_Node.name)
				s_Instance:RemoveNodesAt(i)
			end
			
			::continue::
		end
	end
end

return ZombiesUI