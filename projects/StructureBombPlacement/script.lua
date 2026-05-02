GSL_res = {}
GSL_saveName = ""
-- LINK_CONSTRUCTION = 0
-- LINK_REPAIR = 2
-- LINK_SCRAP = 3
-- LINK_DISABLED_REPAIR = 5
function GetSupportiveLinks(nodeA, nodeB, likePos, saveName, deviceId)
	local state = GetLinkState(nodeA, nodeB)
	if deviceId==0 and GetPlatformSupportsDevice(NodePosition(nodeA), NodePosition(nodeB), GSL_saveName)
	and state~=LINK_CONSTRUCTION and state~=LINK_REPAIR and state~=LINK_SCRAP and state~=LINK_DISABLED_REPAIR then
		GSL_res[#GSL_res+1] = {nodeA, nodeB}
	end
	return true
end

--[[
Try to place a device(deviceSaveName) in a structure(structureId)
@t: the relative position([0,1]) on the link to place the device, default to {0.5}
@return: the device's id placed, 0 if failed
]]
function RandomPlaceDeviceInStructure(structureId, deviceSaveName, t)
	local teamId = GetStructureTeam(structureId)
	-- The device must be enabled so CreateDevice works
	local enabled = GetDeviceEnabled(deviceSaveName, teamId)
	if not enabled then EnableDevice(deviceSaveName, true, teamId) end

	GSL_res = {}
	GSL_saveName = deviceSaveName
	-- Get all possible links to place the device in GSL_res
	EnumerateStructureLinks(teamId, structureId, "GetSupportiveLinks", false)
	local deviceId = 0
	-- default t table
	if not t then t = {0.2, 0.5, 0.8} end
	local size = #GSL_res
	for i=1, size do
		-- Random selection until making a successful placement
		local j = GetRandomInteger(i, size, "SBP Random")
		GSL_res[i], GSL_res[j] = GSL_res[j], GSL_res[i]
		local link = GSL_res[i]
		for _, x in ipairs(t) do
			deviceId = CreateDevice(teamId, deviceSaveName, link[1], link[2], x)
			if deviceId>0 then break end
		end
		if deviceId>0 then break end
	end
	if not enabled then EnableDevice(deviceSaveName, false, teamId) end
	return deviceId
end
--[[
Fill the whole structure(structureId) with a type of device(deviceSaveName)
@t: the relative position([0,1]) on the link to place the device, default to {0.5}
@return: how many devices it has placed
]]
function FillDeviceInStructure(structureId, deviceSaveName, t)
	local teamId = GetStructureTeam(structureId)
	-- The device must be enabled so CreateDevice works
	local enabled = GetDeviceEnabled(deviceSaveName, teamId)
	if not enabled then EnableDevice(deviceSaveName, true, teamId) end

	GSL_res = {}
	GSL_saveName = deviceSaveName
	-- Get all possible links to place the device in GSL_res
	EnumerateStructureLinks(teamId, structureId, "GetSupportiveLinks", false)
	local cnt = 0
	-- default t table
	if not t then t = {0.5} end
	local size = #GSL_res
	for i=1, size do
		-- try to place the device on every link
		local link = GSL_res[i]
		for _, x in ipairs(t) do
			if CreateDevice(teamId, deviceSaveName, link[1], link[2], x)>0 then
				cnt = cnt + 1
				break
			end
		end
	end
	if not enabled then EnableDevice(deviceSaveName, false, teamId) end
	return cnt
end

RegisterEvent("OnLinkHit", function(nodeIdA, nodeIdB, objectId, objectTeamId, objectSaveName, damage, pos, reflectedByEnemy)
	if GetNodeProjectileSaveName(objectId) == "SBP_EBS" then
		RandomPlaceDeviceInStructure(NodeStructureId(nodeIdA), "SBP_EB")
	elseif GetNodeProjectileSaveName(objectId) == "SBP_EBF" then
		FillDeviceInStructure(NodeStructureId(nodeIdA), "SBP_EB", {0.5, 0.2, 0.8})
	end
end)
