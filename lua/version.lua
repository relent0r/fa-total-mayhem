local Version = "138"
---@alias VERSION "138"
---@return PATCH
function GetVersion()
    LOG('Supreme Commander: Forged Alliance Total Mayhem version ' .. Version)
    return Version
end