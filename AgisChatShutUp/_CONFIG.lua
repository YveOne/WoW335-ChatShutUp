
-- hide join/enter messages for custom chat channels?
CSU_HideJoinEnter =         true

-- hide all system messages that contains one of the following substrings
CSU_HideSystemContains = {
    ["Autobroadcast"] =     true,
}

-- enable anti spam feature?
CSU_MuteSpam =              true

-- use anti spam per user? (true recommended)
CSU_MuteSpam_PerUser =      true

-- max spam messages to appear in each channel
CSU_MuteSpam_MaxCount = {
    CHAT_MSG_SAY =          1,
    CHAT_MSG_CHANNEL =      1,
    CHAT_MSG_PARTY =        2,
    CHAT_MSG_RAID =         3,
    CHAT_MSG_YELL =         1,
    CHAT_MSG_WHISPER =      1,
    CHAT_MSG_EMOTE =        1,
    CHAT_MSG_TEXT_EMOTE =   1,
}

-- max mute duration of spam
CSU_MuteSpam_Duration = {
    CHAT_MSG_RAID =         1.0,
    CHAT_MSG_PARTY =        2.0,
    CHAT_MSG_SAY =          5.0,
    CHAT_MSG_CHANNEL =      5.0,
    CHAT_MSG_YELL =         5.0,
    CHAT_MSG_WHISPER =      5.0,
    CHAT_MSG_EMOTE =        5.0,
    CHAT_MSG_TEXT_EMOTE =   5.0,
}

-- cleanup interval, just leave it to 1 minute
CSU_Cleanup_Interval =      60
