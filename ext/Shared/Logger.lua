class "Logger"

function Logger:__init()
	print("Logger Init")
end

function Logger:Write(p_Message)
	print("[Zombies] : " .. p_Message)
end

return Logger