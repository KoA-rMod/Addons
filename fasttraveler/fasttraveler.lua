--[[
* rMod - Copyright (c) 2018 atom0s [atom0s@live.com]
*
* This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
* To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/ or send a letter to
* Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
*
* By using rMod, you agree to the above license and its terms.
*
*      Attribution - You must give appropriate credit, provide a link to the license and indicate if changes were
*                    made. You must do so in any reasonable manner, but not in any way that suggests the licensor
*                    endorses you or your use.
*
*   Non-Commercial - You may not use the material (rMod) for commercial purposes.
*
*   No-Derivatives - If you remix, transform, or build upon the material (rMod), you may not distribute the
*                    modified material. You are, however, allowed to submit the modified works back to the original
*                    rMod project in attempt to have it added to the original project.
*
* You may not apply legal terms or technological measures that legally restrict others
* from doing anything the license permits.
*
* No warranties are given.
]]--

_addon.author   = 'Kender';
_addon.name     = 'fasttraveler';
_addon.version  = '1.0';
_addon.description = 'Allows fast travel from inside dungeons, caves, buildings, etc.'

require 'common';

----------------------------------------------------------------------------------------------------
-- Fast traveler Variables
----------------------------------------------------------------------------------------------------
local fasttraveler = { };
fasttraveler.address = 0;

----------------------------------------------------------------------------------------------------
-- func: set_fast_traveler
-- desc: Enables or disables Fast traveler.
----------------------------------------------------------------------------------------------------
local function set_fast_traveler(enabled)
    -- Ensure the required address was found..
    if (fasttraveler.address == 0) then
        return;
    end

    -- Prepare the write value..
    local v = string.char(0xE8, 0xD6, 0x5B, 0xD4, 0xFF);
    if (enabled == true) then
        v = string.char(0xB0, 0x01, 0x90, 0x90, 0x90);
    end

    -- Unprotect the address and write the value..
    for i = 1,string.len(v)
    do
        hook.memory.unprotect(fasttraveler.address + i - 1, 1);
        hook.memory.write_uint8(fasttraveler.address + i - 1, string.byte(v, i));
    end
end

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when an addon is loaded.
----------------------------------------------------------------------------------------------------
hook.events.register_event('load', 'fasttraveler_load', function()
    -- Find the Lua registration function for 'fast_travel_allowed'..
    local addr = hook.memory.findpattern('Reckoning.exe', 0, '00 00 A6 13 4B 01 C7 84', 0, 0);
    if (addr == 0) then
        error('[fasttraveler] Failed to find the required pointer information. (1)');
        return;
    end
    
    -- Read the func offset..
    local func = hook.memory.read_uint32(addr + 0x0D)
    if (func == 0) then
        error('[fasttraveler] Failed to find the required pointer information. (2)');
        return;
    end
    
    -- Find the call being done to get the value to return.
    local call = hook.memory.findpattern(func, 0x300, 'E8 D6 5B D4 FF', 0, 0);
    if (call == 0) then
        error('[fasttraveler] Failed to find the required pointer information. (3)');
        return;
    end
    
    -- Store the address of the value for later use..
    fasttraveler.address = call;
    HookCore:GetConsole():Write(math.d3dcolor(255, 0, 175, 255), '[fasttraveler] Ready for use. Enable with: /fasttraveler on');
end);

----------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Event called when an addon is unloaded.
----------------------------------------------------------------------------------------------------
hook.events.register_event('unload', 'fasttraveler_unload', function()
    -- Turn Fast traveler off when unloading..
    set_fast_traveler(false);
end);

----------------------------------------------------------------------------------------------------
-- func: command
-- desc: Event called when an addon is given the chance to handle a console command.
----------------------------------------------------------------------------------------------------
hook.events.register_event('command', 'fasttraveler_command', function(command)
    -- Get the command arguments..
    local args = command:args();
    if (args[1] ~= '/fasttraveler') then
        return false;
    end

    -- Handle the /fasttraveler on command..
    if (#args == 2 and args[2] == 'on') then
        set_fast_traveler(true);
        HookCore:GetConsole():Write(math.d3dcolor(255, 0, 175, 255), '[fasttraveler] Fast traveler is now enabled!');
        return true;
    end

    -- Handle the /fasttraveler off command..
    if (#args == 2 and args[2] == 'off') then
        set_fast_traveler(false);
        HookCore:GetConsole():Write(math.d3dcolor(255, 0, 175, 255), '[fasttraveler] Fast traveler is now disabled!');
        return true;
    end

    return true;
end);
