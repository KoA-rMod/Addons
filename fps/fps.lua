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
_addon.name     = 'fps';
_addon.version  = '1.0';

require 'common';

----------------------------------------------------------------------------------------------------
-- Default Addon Settings
----------------------------------------------------------------------------------------------------
local default_settings =
{
    font =
    {
        color = math.d3dcolor(255, 255, 0, 0),
        bold = false,
        name = 'Arial',
        position = { 1, 1 },
        size = 12,
    },
    format = 'FPS: %.1f'
};

----------------------------------------------------------------------------------------------------
-- FPS Variables
----------------------------------------------------------------------------------------------------
local fps_settings = default_settings;
local fps = { };
fps.count = 0;
fps.timer = 0;
fps.frame = 0;
fps.show = true;

----------------------------------------------------------------------------------------------------
-- func: print_help
-- desc: Displays a help block for proper command usage.
----------------------------------------------------------------------------------------------------
local function print_help(cmd, help)
    -- Print the invalid format header..
    HookCore:GetConsole():Write(math.d3dcolor(255, 255, 0, 0), string.format('[Lua] [%s] Invalid format for command: %s', _addon.name, cmd));
    
    -- Loop and print the help commands..
    for k, v in pairs(help) do
        HookCore:GetConsole():Write(math.d3dcolor(255, 255, 0, 0), string.format('[Lua] [%s]    Syntax: %s %s', _addon.name, v[1], v[2]));
    end
end

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when an addon is loaded.
----------------------------------------------------------------------------------------------------
hook.events.register_event('load', 'fps_load', function()
    -- Load or default the settings..
    fps_settings = hook.settings.load_merged(_addon.path .. '\\settings\\settings.json', fps_settings);

    -- Create the fps font object..
    local f = HookCore:GetFontManager():Create('__fps_addon');
    f:SetBold(fps_settings.font.bold);
    f:SetBorderSize(0);
    f:SetColor(fps_settings.font.color);
    f:SetFontFamily(fps_settings.font.name);
    f:SetFontHeight(fps_settings.font.size);
    f:SetPositionX(fps_settings.font.position[1]);
    f:SetPositionY(fps_settings.font.position[2]);
    f:SetText('FPS by atom0s');
    f:SetVisible(true);
end);

----------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Event called when an addon is unloaded.
----------------------------------------------------------------------------------------------------
hook.events.register_event('unload', 'fps_unload', function()
    -- Get the fps font object..
    local f = HookCore:GetFontManager():Create('__fps_addon');

    -- Update the settings information with the fonts current values..
    fps_settings.font.bold = f:GetBold();
    fps_settings.font.color = f:GetColor();
    fps_settings.font.name = f:GetFontFamily();
    fps_settings.font.position = { f:GetPositionX(), f:GetPositionY(); };
    fps_settings.font.size = f:GetFontHeight();

    -- Save the fps settings..
    hook.settings.save(_addon.path .. '\\settings\\settings.json', fps_settings);

    -- Delete the fps font object..
    HookCore:GetFontManager():Delete('__fps_addon');
end);

----------------------------------------------------------------------------------------------------
-- func: command
-- desc: Event called when the addon is given the chance to handle a console command.
----------------------------------------------------------------------------------------------------
hook.events.register_event('command', 'fps_command', function(command)
    -- Ignore non-fps commands..
    local args = command:args();
    if (args[1] ~= '/fps') then
        return false;
    end

    -- Toggle the fps visibility..
    if (#args == 1 or args[2] == 'show') then
        fps.show = not fps.show;
        return true;
    end

    -- Set the fps color..
    if (#args >= 6 and args[2] == 'color') then
        fps_settings.font.color = math.d3dcolor(tonumber(args[3]), tonumber(args[4]), tonumber(args[5]), tonumber(args[6]));
        local f = HookCore:GetFontManager():Get('__fps_addon');
        if (f ~= nil) then
            f:SetColor(fps_settings.font.color);
            print('Set the fps count color.');
        end
        return true;
    end

    -- Set the fps font family and height..
    if (#args >= 4 and args[2] == 'font') then
        fps_settings.font.name = args[3];
        fps_settings.font.size = tonumber(args[4]);
        local f = HookCore:GetFontManager():Get('__fps_addon');
        if (f ~= nil) then
            f:SetFontFamily(fps_settings.font.name);
            f:SetFontHeight(fps_settings.font.size);
            print('Set the fps count font family and height.');
        end
        return true;
    end

    -- Print the addons command help information..
    print_help('/fps', {
        { '/fps show',                  '- Toggles the FPS display on and off.' },
        { '/fps color [a] [r] [g] [b]', '- Sets the FPS display color.' },
        { '/fps font [name] [size]',    '- Sets the FPS display font family and height.' },
    });
    return true;
end);

----------------------------------------------------------------------------------------------------
-- func: prepresent
-- desc: Event called when an addon is told the graphics device is about to present a scene.
----------------------------------------------------------------------------------------------------
hook.events.register_event('prepresent', 'fps_prepresent', function()
    -- Get the fps font object..
    local f = HookCore:GetFontManager():Get('__fps_addon');
    if (f == nil) then
        return;
    end

    -- Set the fonts visibility..
    f:SetVisible(fps.show);
    if (not fps.show) then
        return;
    end

    -- Calculate the current fps..
    fps.count = fps.count + 1;
    if (os.time() >= fps.timer + 1) then
        fps.frame = fps.count;
        fps.count = 0;
        fps.timer = os.time();
    end
    
    -- Update the font objects display..
    f:SetText(string.format(fps_settings.format, fps.frame));
end);