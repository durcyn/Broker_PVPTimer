local _G = getfenv(0)
local obj = _G.LibStub("LibDataBroker-1.1"):NewDataObject("PVP Timer", { type = "data source", label = "PVP", text = "" })
local format = _G.string.format
local floor = _G.floor
local CreateFrame = _G.CreateFrame
local SecondsToTimeAbbrev = _G.SecondsToTimeAbbrev
local IsPVPTimerRunning = _G.IsPVPTimerRunning
local GetPVPTimer = _G.GetPVPTimer
local UnitIsPVPFreeForAll = _G.UnitIsPVPFreeForAll
local UnitFactionGroup = _G.UnitFactionGroup
local UnitIsPVP = _G.UnitIsPVP

local iconpath="Interface\\Addons\\Broker_PVPTimer\\icons\\%s"
local time = nil

local f = CreateFrame("frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD");
f:RegisterEvent("PLAYER_FLAGS_CHANGED");
f:SetScript("OnEvent", function()
	if IsPVPTimerRunning() then
		time = GetPVPTimer()	
	elseif UnitIsPVP("player") then
		time = 0
	else
		time = nil
	end

	local icon
	if UnitIsPVPFreeForAll("player") then
		icon = "freeforall"
	else
		local faction = UnitFactionGroup("player")
		if time then
			icon = format("%s_%s", faction, "active")
		else
			icon = format("%s_%s", faction, "inactive")
		end	
	end
	obj.icon = format(iconpath, icon)
end)

local counter = 0
f:SetScript("OnUpdate", function(self, elapsed)
	counter = counter + elapsed
	if counter >= 1 then
		if time then
			if time < 0 then
				time = nil
			elseif time == 0 then
				obj.text = "On"
			elseif time then
				time = time - elapsed*1000
				local fmt, digit = SecondsToTimeAbbrev(floor(time/1000))
				obj.text = format(fmt, digit)
			end
		else
			obj.text = "Off"
		end
	end
end)

