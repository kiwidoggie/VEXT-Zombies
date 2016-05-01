class "ZombiesVisuals"

local g_Logger = require "__shared/Logger"

function ZombiesVisuals:__init()
	g_Logger:Write("ZombiesVisuals init.")
end

function ZombiesVisuals:OnStateChanged(p_State)
	-- Make sure all our VE states are fixed.
	local s_States = VisualEnvironmentManager:GetStates()

	for i, s_State in ipairs(s_States) do
		if s_State.entityName ~= 'EffectEntity' then
			self:FixEnvironmentState(s_State)			
		end
	end
end

function ZombiesVisuals:OnLoaded()
	-- Make sure all our VE states are fixed.
	local s_States = VisualEnvironmentManager:GetStates()

	for i, s_State in ipairs(s_States) do
		if s_State.entityName ~= 'EffectEntity' then
			self:FixEnvironmentState(s_State)			
		end
	end
end

function ZombiesVisuals:OnReadInstance(p_Instance, p_Guid)
	if p_Instance == nil then
		return
	end
	
	self:SetFlashlight(p_Instance, p_Guid)
end

function ZombiesVisuals:SetFlashlight(p_Instance, p_Guid)
	if p_Guid == Guid('5FBA51D6-059F-4284-B5BB-6E20F145C064', 'D') then
		local s_Instance = SpotLightEntityData(p_Instance)
		s_Instance.radius = 100
		s_Instance.intensity = 100
		s_Instance.castShadowsEnable = true
	end
	if p_Guid == Guid('995E49EE-8914-4AFD-8EF5-59125CA8F9CD', 'D') then
		local s_Instance = SpotLightEntityData(p_Instance)
		s_Instance.radius = 100
		s_Instance.intensity = 20
		s_Instance.castShadowsEnable = true
		s_Instance.coneOuterAngle = 90
		s_Instance.frustumFov = 50
	end

	if p_Instance.type == "EmitterTemplateData" then
		local s_Instance = EmitterTemplateData(p_Instance)
		s_Instance.actAsPointLight = true
		s_Instance.pointLightRadius = 100
		s_Instance.pointLightRandomIntensityMax = 1000
	end
	
	if p_Instance.type == "SpotLightEntityData" then
		local s_Instance = SpotLightEntityData(p_Instance)
		s_Instance.visible = true
		s_Instance.castShadowsEnable = true
		s_Instance.specularEnable = true
	end	

	if p_Instance.type == "PointLightEntityData" then
		local s_Instance = PointLightEntityData(p_Instance)
		s_Instance.visible = true
		s_Instance.castShadowsEnable = true
		s_Instance.specularEnable = true
	end	
end

function ZombiesVisuals:FixEnvironmentState(p_State)
	--g_Logger:Write('Fixing visual environment state ' .. p_State.entityName .. " for ffs")
	
	self:SetHumanVisuals(p_State)
	
	-- local s_Player = PlayerManager:GetLocalPlayer()
	-- if s_Player == nil then
		-- return
	-- end
	
	-- local s_TeamId = s_Player.teamID
	-- if s_TeamId == TeamId.Team1 then
		-- self:SetHumanVisuals(p_State)
	-- end
	
	-- if s_TeamId == TeamId.Team2 then
		-- self:SetZombieVisuals(p_State)
	-- end
end

function ZombiesVisuals:SetHumanVisuals(p_State)
	local s_ColorCorrection = p_State.colorCorrection

	if s_ColorCorrection ~= nil then
		s_ColorCorrection.brightness = Vec3(1, 1, 1)
		--s_ColorCorrection.brightness = Vec3(1.0, 1.0, 1.0)
		s_ColorCorrection.contrast = Vec3(1.0, 1.0, 1.0)
		s_ColorCorrection.saturation = Vec3(0.8, 0.8, 0.8)
		s_ColorCorrection.colorGradingEnable = true
		s_ColorCorrection.enable = true
	end

	local s_Sky = p_State.sky

	if s_Sky ~= nil then
	    s_Sky.enable = true
	    s_Sky.brightnessScale = 0.03
	    s_Sky.sunSize = 0.004
	    s_Sky.sunScale = 5.0
	    s_Sky.panoramicUVMinX = 0.0
	    s_Sky.panoramicUVMaxX = 1.0
	    s_Sky.panoramicUVMinY = 0.0
	    s_Sky.panoramicUVMaxY = 0.7
	    s_Sky.panoramicTileFactor = 1.0
	    s_Sky.panoramicRotation = 0.578
	    s_Sky.cloudLayerMaskTexture = nil
	    s_Sky.cloudLayerSunColor = Vec3(1.0, 0.917, 0.53)
	    s_Sky.cloudLayer1Altitude = 400000.0
	    s_Sky.cloudLayer1TileFactor = 0.18
	    s_Sky.cloudLayer1Rotation = 30.194
	    s_Sky.cloudLayer1Speed = 0.003
	    s_Sky.cloudLayer1SunLightIntensity = -100
	    s_Sky.cloudLayer1SunLightPower = 0
	    s_Sky.cloudLayer1AmbientLightIntensity = 1
	    s_Sky.cloudLayer1Color = Vec3(1.0, 1.0, 1.0)
	    s_Sky.cloudLayer1AlphaMul = 0
	    s_Sky.cloudLayer1Texture = nil
	    s_Sky.cloudLayer2Altitude = 10000.0
	    s_Sky.cloudLayer2TileFactor = 0.25
	    s_Sky.cloudLayer2Rotation = 0.0
	    s_Sky.cloudLayer2Speed = 0.01
	    s_Sky.cloudLayer2SunLightIntensity = 4.0
	    s_Sky.cloudLayer2SunLightPower = 50.0
	    s_Sky.cloudLayer2AmbientLightIntensity = 0.2
	    s_Sky.cloudLayer2Color = Vec3(1.0, 1.0, 1.0)
	    s_Sky.cloudLayer2AlphaMul = 0
	    s_Sky.cloudLayer2Texture = nil
	    s_Sky.staticEnvmapScale = 0.2
	    s_Sky.skyEnvmap8BitTexScale = 0.25
	    s_Sky.customEnvmapScale = 1.0
	    s_Sky.customEnvmapAmbient = 0.0
	    s_Sky.skyVisibilityExponent = 1.0
	end

	local s_OutdoorLight = p_State.outdoorLight

	if s_OutdoorLight ~= nil then
	    s_OutdoorLight.enable = true
	    s_OutdoorLight.sunRotationX = 255.484
	    s_OutdoorLight.sunRotationY = 18.581
	    s_OutdoorLight.sunColor = Vec3(0.0, 0.0, 0.0)
	    s_OutdoorLight.skyColor = Vec3(0.0, 0.0, 0.0)
	    s_OutdoorLight.groundColor = Vec3(0.023, 0.027, 0.032)
	    s_OutdoorLight.skyLightAngleFactor = -0.134
	    s_OutdoorLight.sunSpecularScale = 0.0
	    s_OutdoorLight.skyEnvmapShadowScale = 1.0
	    s_OutdoorLight.sunShadowHeightScale = 0.298
	    s_OutdoorLight.cloudShadowEnable = false
	    s_OutdoorLight.cloudShadowSpeed = Vec2(30,30)
	    s_OutdoorLight.cloudShadowSize = 3000.0
	    s_OutdoorLight.cloudShadowCoverage = 0.446
	    s_OutdoorLight.cloudShadowExponent = 3.0
	    s_OutdoorLight.translucencyAmbient = 0.0
	    s_OutdoorLight.translucencyScale = 0.0
	    s_OutdoorLight.translucencyPower = 8.0
	    s_OutdoorLight.translucencyDistortion = 0.1
	end

	local s_CharacterLighting = p_State.characterLighting

	if s_CharacterLighting ~= nil then
		s_CharacterLighting.characterLightEnable = true
		s_CharacterLighting.firstPersonEnable = true
		s_CharacterLighting.lockToCameraDirection = false

	end


	local s_TonemapData = p_State.tonemap

	if s_TonemapData ~= nil then
		s_TonemapData.bloomScale = Vec3(0, 0, 0)
		s_TonemapData.minExposure =0.1
		s_TonemapData.middleGray = 0.4
		s_TonemapData.maxExposure = 1.5
	end


	local s_Enlighten = p_State.enlighten

	if s_Enlighten ~= nil then
	    s_Enlighten.enable = false
	    s_Enlighten.bounceScale = 1.0
	    s_Enlighten.sunScale = 0.75
	    s_Enlighten.terrainColor = Vec3(0.1, 0.1, 0.1)
	    s_Enlighten.cullDistance = -1.0
	    s_Enlighten.skyBoxEnable = true
	    s_Enlighten.skyBoxSkyColor = Vec3(0.01, 0.019, 0.032)
	    s_Enlighten.skyBoxGroundColor = Vec3(0.0, 0.0, 0.0)
	    s_Enlighten.skyBoxSunLightColor = Vec3(1.0, 0.759, 0.476)
	    s_Enlighten.skyBoxSunLightColorSize = 1.0
	    s_Enlighten.skyBoxBackLightColor = Vec3(0.0, 0.0, 0.0)
	    s_Enlighten.skyBoxBackLightColorSize = 0.0
	    s_Enlighten.skyBoxBackLightRotationX = 0.0
	    s_Enlighten.skyBoxBackLightRotationY = 60.0

	end

	local s_Vignette = p_State.vignette

	if s_Vignette ~= nil then
		s_Vignette.enable = false
	end

	local s_Fog = p_State.fog

	if s_Fog ~= nil then
	    s_Fog.enable = true
	    s_Fog.fogDistanceMultiplier = 1.0
	    s_Fog.fogGradientEnable = true
	    s_Fog.start = -10.0
	    s_Fog['end'] = 200.0
	    s_Fog.curve = Vec4(3.4986055, -4.841408, 3.4623053, -0.1758487)
	    s_Fog.fogColorEnable = false
	    s_Fog.fogColor = Vec3(0.036, 0.264, 0.374)
	    s_Fog.fogColorStart = -20.0
	    s_Fog.fogColorEnd = 200.0
	    s_Fog.fogColorCurve = Vec4(1.90640783, -2.1295185, 1.0955018, -0.083194144)
	    s_Fog.transparencyFadeStart = 100.0
	    s_Fog.transparencyFadeEnd = 200.0
	    s_Fog.transparencyFadeClamp = 0.5
	    s_Fog.heightFogEnable = true
	    s_Fog.heightFogFollowCamera = 0.0
	    s_Fog.heightFogAltitude = -10.0
	    s_Fog.heightFogDepth = 100.0
	    s_Fog.heightFogVisibilityRange = 100.0
	end

	local s_Wind = p_State.wind

	if s_Wind ~= nil then
		s_Wind.windStrength = SharedUtils:GetRandom(0,10)
	end


	local s_CameraParams = p_State.cameraParams

	if s_CameraParams ~= nil then
		s_CameraParams.viewDistance = 5000
		s_CameraParams.sunShadowmapViewDistance = 100
	end

	VisualEnvironmentManager.dirty = true
end

function ZombiesVisuals:SetZombieVisuals(p_State)
	self:SetHumanVisuals(p_State)
	
	local s_Vignette = p_State.vignette
	
	if s_Vignette ~= nil then
		s_Vignette.scale = Vec2(2.799, 1.600)
		s_Vignette.exponent = 3.0
		s_Vignette.color = Vec3(0, 0.119999997318, 0.324999988079)
		s_Vignette.opacity = 0.600000023842
	end
	
	local s_TonemapData = p_State.tonemap

	if s_TonemapData ~= nil then
		s_TonemapData.bloomScale = Vec3(0.600000023842, 0.600000023842, 0.600000023842)
		s_TonemapData.minExposure = 0.25
		s_TonemapData.middleGray = 0.25
		s_TonemapData.maxExposure = 5.0
		s_TonemapData.exposureAdjustTime = 0.5
		s_TonemapData.chromostereopsisEnable = false
		s_TonemapData.chromostereopsisScale = 1.0
		s_TonemapData.chromostereopsisOffset = 1.0
	end

	local s_Sky = p_State.sky

	if s_Sky ~= nil then
	    s_Sky.enable = true
	    s_Sky.brightnessScale = 0.699999988079
	    s_Sky.sunSize = 0.0
	    s_Sky.sunScale = 1.0
	    s_Sky.panoramicUVMinX = 0.0
	    s_Sky.panoramicUVMaxX = 1.0
	    s_Sky.panoramicUVMinY = 0.0
	    s_Sky.panoramicUVMaxY = 1.0
	    s_Sky.panoramicTileFactor = 1.0
	    s_Sky.panoramicRotation = 0.0
	    s_Sky.cloudLayerMaskTexture = nil
	    s_Sky.cloudLayerSunColor = Vec3(1.0, 1, 1)
	    s_Sky.cloudLayer1Altitude = 10000.0
	    s_Sky.cloudLayer1TileFactor = 0.25
	    s_Sky.cloudLayer1Rotation = 0.0
	    s_Sky.cloudLayer1Speed = 0.00999999977648
	    s_Sky.cloudLayer1SunLightIntensity = 4.0
	    s_Sky.cloudLayer1SunLightPower = 50.0
	    s_Sky.cloudLayer1AmbientLightIntensity = 0.20000000298
	    s_Sky.cloudLayer1Color = Vec3(1.0, 1.0, 1.0)
	    s_Sky.cloudLayer1AlphaMul = 0
	    s_Sky.cloudLayer1Texture = nil
	    s_Sky.cloudLayer2Altitude = 10000.0
	    s_Sky.cloudLayer2TileFactor = 0.25
	    s_Sky.cloudLayer2Rotation = 0.0
	    s_Sky.cloudLayer2Speed = 0.00999999977648
	    s_Sky.cloudLayer2SunLightIntensity = 4.0
	    s_Sky.cloudLayer2SunLightPower = 50.0
	    s_Sky.cloudLayer2AmbientLightIntensity = 0.2
	    s_Sky.cloudLayer2Color = Vec3(1.0, 1.0, 1.0)
	    s_Sky.cloudLayer2AlphaMul = 0
	    s_Sky.cloudLayer2Texture = nil
	    s_Sky.staticEnvmapScale = 0.0
	    s_Sky.skyEnvmap8BitTexScale = 0.10000000149
	    s_Sky.customEnvmapScale = 0.0
	    s_Sky.customEnvmapAmbient = 0.0
	    s_Sky.skyVisibilityExponent = 0.0
	end
	
	local s_OutdoorLight = p_State.outdoorLight

	if s_OutdoorLight ~= nil then
	    s_OutdoorLight.enable = true
	    s_OutdoorLight.sunRotationX = 0
	    s_OutdoorLight.sunRotationY = 90
	    s_OutdoorLight.sunColor = Vec3(0.10000000149, 0.10000000149, 0.10000000149)
	    s_OutdoorLight.skyColor = Vec3(0.0500000007451, 0.0500000007451, 0.0500000007451)
	    s_OutdoorLight.groundColor = Vec3(0.0500000007451, 0.0500000007451, 0.0500000007451)
	    s_OutdoorLight.skyLightAngleFactor = -0.134
	    s_OutdoorLight.sunSpecularScale = 0.0
	    s_OutdoorLight.skyEnvmapShadowScale = 0.0
	    s_OutdoorLight.sunShadowHeightScale = 0.5
	    s_OutdoorLight.cloudShadowEnable = false
	    s_OutdoorLight.cloudShadowSpeed = Vec2(2.0, 2.0)
	    s_OutdoorLight.cloudShadowSize = 500.0
	    s_OutdoorLight.cloudShadowCoverage = 0.300000011921
	    s_OutdoorLight.cloudShadowExponent = 8.0
	    s_OutdoorLight.translucencyAmbient = 0.0
	    s_OutdoorLight.translucencyScale = 0.0
	    s_OutdoorLight.translucencyPower = 8.0
	    s_OutdoorLight.translucencyDistortion = 0.1
	end
	
	local s_Fog = p_State.fog

	if s_Fog ~= nil then
	    s_Fog.enable = true
	    s_Fog.fogDistanceMultiplier = 1.0
	    s_Fog.fogGradientEnable = true
	    s_Fog.start = 0.0
	    s_Fog['end'] = 700.0
	    s_Fog.curve = Vec4(4.60107469559, -8.06933879852, 5.14824676514, -0.7186845541)
	    s_Fog.fogColorEnable = false
	    s_Fog.fogColor = Vec3(0.036, 0.264, 0.374)
	    s_Fog.fogColorStart = 0.0
	    s_Fog.fogColorEnd = 1000.0
	    s_Fog.fogColorCurve = Vec4(2.72282457352, -4.49439191818, 2.86069464684, -0.340569168329)
	    s_Fog.transparencyFadeStart = -50.0
	    s_Fog.transparencyFadeEnd = 200.0
	    s_Fog.transparencyFadeClamp = 0.800000011921
	    s_Fog.heightFogEnable = false
	    s_Fog.heightFogFollowCamera = 0.0
	    s_Fog.heightFogAltitude = 0.0
	    s_Fog.heightFogDepth = 100.0
	    s_Fog.heightFogVisibilityRange = 100.0
	end
	
	local s_Enlighten = p_State.enlighten

	if s_Enlighten ~= nil then
	    s_Enlighten.enable = false
	    s_Enlighten.bounceScale = 1.0
	    s_Enlighten.sunScale = 0.0
	    s_Enlighten.terrainColor = Vec3(0.1, 0.1, 0.1)
	    s_Enlighten.cullDistance = -1.0
	    s_Enlighten.skyBoxEnable = true
	    s_Enlighten.skyBoxSkyColor = Vec3(1.0, 1.0, 1.0)
	    s_Enlighten.skyBoxGroundColor = Vec3(1.0, 1.0, 1.)
	    s_Enlighten.skyBoxSunLightColor = Vec3(1.0, 1.0, 1.)
	    s_Enlighten.skyBoxSunLightColorSize = 0.0
	    s_Enlighten.skyBoxBackLightColor = Vec3(0.0, 0.0, 0.0)
	    s_Enlighten.skyBoxBackLightColorSize = 0.0
	    s_Enlighten.skyBoxBackLightRotationX = 209.477005005
	    s_Enlighten.skyBoxBackLightRotationY = 26.0279998779

	end
	
	local s_ColorCorrection = p_State.colorCorrection

	if s_ColorCorrection ~= nil then
		s_ColorCorrection.brightness = Vec3(1.5, 1.5, 1.5)
		--s_ColorCorrection.brightness = Vec3(1.0, 1.0, 1.0)
		s_ColorCorrection.contrast = Vec3(1.39999997616, 1.39999997616, 1.39999997616)
		s_ColorCorrection.saturation = Vec3(0.8, 0.8, 0.8)
		s_ColorCorrection.colorGradingEnable = true
		s_ColorCorrection.enable = true
	end
end

return ZombiesVisuals