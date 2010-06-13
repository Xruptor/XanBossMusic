
local f = CreateFrame("frame","XanBossMusic",UIParent)
f:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)

----------------------
--      Enable      --
----------------------
f.bossEngaged = false;
f.bossID = 0;

function f:PLAYER_LOGIN()
	DEFAULT_CHAT_FRAME:AddMessage("XanBossMusic Loaded")
	f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	
	self:UnregisterEvent("PLAYER_LOGIN")
	self.PLAYER_LOGIN = nil
end

function f:COMBAT_LOG_EVENT_UNFILTERED(event, timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
	
	if srcGUID then
		bossID = tonumber(srcGUID:sub(9, 12), 16)
		if bossID and LibStub("LibBossIDs-1.0").BossIDs[bossID] and not UnitIsDeadOrGhost("player") then
			if not f.bossEngaged then
				f.bossID = bossID
				f.bossEngaged = true
				PlayMusic("Interface\\AddOns\\XanBossMusic\\music.mp3");
			end
		end
	
	end
	
	if eventtype == 'UNIT_DIED' and dstGUID then
		bossChk = tonumber(dstGUID:sub(9, 12), 16)
		if bossChk == f.bossID and f.bossEngaged then
			StopMusic()
			f.bossEngaged = false
		elseif UnitIsDeadOrGhost("player") and f.bossEngaged then
			StopMusic()
			f.bossEngaged = false
		end
	end
	
end


if IsLoggedIn() then f:PLAYER_LOGIN() else f:RegisterEvent("PLAYER_LOGIN") end
