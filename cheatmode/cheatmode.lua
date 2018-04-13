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

_addon.author   = 'atom0s';
_addon.name     = 'cheatmode';
_addon.version  = '1.0';

require 'common';

----------------------------------------------------------------------------------------------------
-- Cheat Mode Variables
----------------------------------------------------------------------------------------------------
local cheatmode = { };
cheatmode.address = 0;

----------------------------------------------------------------------------------------------------
-- func: set_cheat_mode
-- desc: Enables or disables cheat mode.
----------------------------------------------------------------------------------------------------
local function set_cheat_mode(enabled)
    -- Ensure the required address was found..
    if (cheatmode.address == 0) then
        return;
    end

    -- Prepare the write value..
    local v = 1;
    if (enabled == true) then
        v = 0;
    end

    -- Unprotect the address and write the value..
    hook.memory.unprotect(cheatmode.address, 1);
    hook.memory.write_uint8(cheatmode.address, v);
end

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when an addon is loaded.
----------------------------------------------------------------------------------------------------
hook.events.register_event('load', 'cheatmode_load', function()
    -- Find the Lua registration function for 'is_ship_build'..
    local addr = hook.memory.findpattern('Reckoning.exe', 0, 'C7 44 24 20 13 D3 94 00 88 44 24 26', 0, 0);
    if (addr == 0) then
        error('[CheatMode] Failed to find the required pointer information. (1)');
        return;
    end

    -- Read the call offset..
    local call = hook.memory.read_uint32(addr + 0x10)
    if (call == 0) then
        error('[CheatMode] Failed to find the required pointer information. (2)');
        return;
    end

    -- Find the Lua data being pushed onto the stack for the value of 'is_ship_build'..
    local data = hook.memory.findpattern(call, 0x100, 'C6 44 24 20 ?? C7', 4, 0);
    if (data == 0) then
        error('[CheatMode] Failed to find the required pointer information. (3)');
        return;
    end

    -- Store the address of the value for later use..
    cheatmode.address = data;
    HookCore:GetConsole():Write(math.d3dcolor(255, 0, 175, 255), '[CheatMode] Required data was found, ready for use!');
end);

----------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Event called when an addon is unloaded.
----------------------------------------------------------------------------------------------------
hook.events.register_event('unload', 'cheatmode_unload', function()
    -- Turn cheat mode off when unloading..
    set_cheat_mode(false);
end);

----------------------------------------------------------------------------------------------------
-- func: command
-- desc: Event called when an addon is given the chance to handle a console command.
----------------------------------------------------------------------------------------------------
hook.events.register_event('command', 'cheatmode_command', function(command)
    -- Get the command arguments..
    local args = command:args();
    if (args[1] ~= '/cheatmode') then
        return false;
    end

    -- Handle the /cheatmode on command..
    if (#args == 2 and args[2] == 'on') then
        set_cheat_mode(true);
        HookCore:GetConsole():Write(math.d3dcolor(255, 0, 175, 255), '[CheatMode] Cheat mode is now enabled!');
        return true;
    end

    -- Handle the /cheatmode off command..
    if (#args == 2 and args[2] == 'off') then
        set_cheat_mode(false);
        HookCore:GetConsole():Write(math.d3dcolor(255, 0, 175, 255), '[CheatMode] Cheat mode is now disabled!');
        return true;
    end

    return true;
end);