
-----------------------------------------------------------------------------------
local ADDONNAME, THIS = ...;
local AgiTimers = LibStub("AgiTimers")
-----------------------------------------------------------------------------------

-- localize

local pairs, strfind, strtrim, GetTime = pairs, strfind, strtrim, GetTime

-- variables

local muteSpam_msgCounts =              {}
local muteSpam_msgTimes =               {}

-----------------------------------------------------------------------------------

local lastReturn = false
local debugCounterID = 0
local function debugCounter(...)
    local id = select(9, ...)
    if ( debugCounterID == id ) then
        return false
    end
    debugCounterID = id
    return true
end

-----------------------------------------------------------------------------------

local function hideChannelJoinLeave(self, event, message, author, ...)
    if ( not debugCounter(...) ) then return lastReturn end
    lastReturn = CSU_HideJoinEnter
    return lastReturn
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_JOIN", hideChannelJoinLeave)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LEAVE", hideChannelJoinLeave)

-----------------------------------------------------------------------------------

local function hideSystemContains(self, event, msg)
    for k,v in pairs(CSU_HideSystemContains) do
        if ( strfind(msg, k) ) then
            return v
        end
    end
    return false
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", hideSystemContains)

-----------------------------------------------------------------------------------

local function muteSpam(self, event, message, author, ...)
    if ( not debugCounter(...) ) then return lastReturn end

    if ( CSU_MuteSpam == false ) then
        return false
    end

    message = strtrim(message)
    if ( CSU_MuteSpam_PerUser ) then
        message = author..message
    end
    local timeNow = GetTime()
    local doblock = false

    if ( muteSpam_msgCounts[message] == nil ) then
        muteSpam_msgCounts[message] = 0
    else
        if ( muteSpam_msgTimes[message] > timeNow ) then
            muteSpam_msgCounts[message] = muteSpam_msgCounts[message] + 1
            if ( muteSpam_msgCounts[message] >= CSU_MuteSpam_MaxCount[event] ) then
                doblock = true
            end
        end
    end

    if ( doblock ) then
        lastReturn = true
    else
        muteSpam_msgTimes[message] = timeNow + CSU_MuteSpam_Duration[event]
        lastReturn = false
    end

    return lastReturn
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY",         muteSpam)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL",     muteSpam)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY",       muteSpam)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID",        muteSpam)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL",        muteSpam)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER",     muteSpam)
ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE",       muteSpam)
ChatFrame_AddMessageEventFilter("CHAT_MSG_TEXT_EMOTE",  muteSpam)

-----------------------------------------------------------------------------------

local function cleanup()
    local timeToDrop = GetTime() - CSU_Cleanup_Interval
    for message,lastTime in pairs(muteSpam_msgTimes) do
        if ( lastTime < timeToDrop ) then
            muteSpam_msgTimes[message] = nil
            muteSpam_msgCounts[message] = nil
        end
    end
end
AgiTimers:SetInterval(cleanup, CSU_Cleanup_Interval)

-----------------------------------------------------------------------------------
