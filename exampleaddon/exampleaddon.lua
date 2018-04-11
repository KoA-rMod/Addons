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
_addon.name     = 'ExampleAddon';
_addon.version  = '1.0';

require 'common';

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when an addon is loaded.
----------------------------------------------------------------------------------------------------
hook.events.register_event('load', 'example_load', function()
    print('ExampleAddon was loaded!');
end);

----------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Event called when an addon is unloaded.
----------------------------------------------------------------------------------------------------
hook.events.register_event('unload', 'example_unload', function()
    print('ExampleAddon was unloaded!');
end);

----------------------------------------------------------------------------------------------------
-- func: command
-- desc: Event called when an addon is given the chance to handle a console command.
----------------------------------------------------------------------------------------------------
hook.events.register_event('command', 'example_command', function(command)
    -- Handle the /test command..
    if (command == '/test') then
        print('ExampleAddon handled the /test command!');
        return true;
    end

    -- Obtain the command arguments..
    local args = command:args();

    -- Handle the foo command with sub-arguments..
    if (#args >= 2 and args[1] == '/foo' and args[2] == 'on') then
        print('ExampleAddon handled the /foo on command!')
        return true;
    end
    if (#args >= 2 and args[1] == '/foo' and args[2] == 'off') then
        print('ExampleAddon handled the /foo off command!')
        return true;
    end

    return false;
end);

----------------------------------------------------------------------------------------------------
-- func: key
-- desc: Event called when an addon is given the change to handle a keyboard event.
----------------------------------------------------------------------------------------------------
hook.events.register_event('key', 'example_key', function(key, down, blocked)
    -- Ignore the event if it was already blocked..
    if (blocked) then
        return blocked;
    end

    -- Block the L key..
    if (key == 0x4C) then
        print('ExampleAddon saw and blocked a key event for the L key!');
        return true;
    end

    return false;
end);

----------------------------------------------------------------------------------------------------
-- func: mouse
-- desc: Event called when an addon is given the change to handle a mouse event.
----------------------------------------------------------------------------------------------------
hook.events.register_event('mouse', 'example_mouse', function(id, x, y, delta, blocked)
    -- Ignore the event if it was already blocked..
    if (blocked) then
        return blocked;
    end

    -- Block all mouse down and up events..
    if (id == 513 or id == 514) then
        print('ExampleAddon saw and blocked a mouse down or up event!');
        return true;
    end

    return false;
end);

----------------------------------------------------------------------------------------------------
-- func: prereset
-- desc: Event called when an addon is told the graphics device is about to reset.
----------------------------------------------------------------------------------------------------
hook.events.register_event('prereset', 'example_prereset', function()
    print('ExampleAddon saw prereset event!');
end);

----------------------------------------------------------------------------------------------------
-- func: postreset
-- desc: Event called when an addon is told the graphics device is has reset.
----------------------------------------------------------------------------------------------------
hook.events.register_event('postreset', 'example_postreset', function()
    print('ExampleAddon saw postreset event!');
end);

----------------------------------------------------------------------------------------------------
-- func: beginscene
-- desc: Event called when an addon is told the graphics device is about to begin a scene.
----------------------------------------------------------------------------------------------------
hook.events.register_event('beginscene', 'example_beginscene', function()
    -- Commented out as this will spam the console with messages..
    -- print('ExampleAddon saw beginscene event!');
end);

----------------------------------------------------------------------------------------------------
-- func: endscene
-- desc: Event called when an addon is told the graphics device has ended a scene.
----------------------------------------------------------------------------------------------------
hook.events.register_event('endscene', 'example_endscene', function()
    -- Commented out as this will spam the console with messages..
    -- print('ExampleAddon saw endscene event!');
end);

----------------------------------------------------------------------------------------------------
-- func: prepresent
-- desc: Event called when an addon is told the graphics device is about to present a scene.
----------------------------------------------------------------------------------------------------
hook.events.register_event('prepresent', 'example_prepresent', function()
    -- Commented out as this will spam the console with messages..
    -- print('ExampleAddon saw prepresent event!');
end);

----------------------------------------------------------------------------------------------------
-- func: postpresent
-- desc: Event called when an addon is told the graphics device has presented a scene.
----------------------------------------------------------------------------------------------------
hook.events.register_event('postpresent', 'example_postpresent', function()
    -- Commented out as this will spam the console with messages..
    -- print('ExampleAddon saw postpresent event!');
end);