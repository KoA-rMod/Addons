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
_addon.name     = 'expmon';
_addon.version  = '1.0';

require 'common';

----------------------------------------------------------------------------------------------------
-- Default Addon Settings
----------------------------------------------------------------------------------------------------
local default_settings =
{
    -- Main settings..
    main = {
        position    = { -1, -1 },
    },

    -- Main bar settings..
    bar = {
        color       = 0xFFFFFFFF,
        bgcolor     = 0xFFFFFFFF,
        file        = 'textures\\bar.png',
        scale       = { 1, 1 },
        size        = { 472, 5 },
    },

    -- Fill bar settings..
    fill = {
        color       = 0xFFFFF8B8,
        bgcolor     = 0xFFFFFFFF,
        file        = 'textures\\fill.png',
        max_width   = 466,
        position    = { 3, 0 }, -- Offset from the main bar..
        scale       = { 1, 1 },
        size        = { 1, 5 },
    },

    -- Overall font settings..
    font = {
        file        = 'fonts\\eurostarregularextended.ttf',
        name        = 'eurostar regular extended',
        bold        = true,
        drawflags   = 0x10, -- Stroke
        format      = '%d / %d',
        prefix      = 'EXP: ',
        size        = 10,
        strokecolor = 0xFF1E1E19,
    },
};

----------------------------------------------------------------------------------------------------
-- Variables
----------------------------------------------------------------------------------------------------
local expmon_settings = default_settings;

----------------------------------------------------------------------------------------------------
-- UI Variables
----------------------------------------------------------------------------------------------------
local variables =
{
    -- Main editor window variables..
    ['var_expmon_showeditor']       = { nil, ImGuiVar_BOOLCPP,      false },

    -- Main settings..
    ['var_expmon_main_positionx']   = { nil, ImGuiVar_INT32,        -1 },
    ['var_expmon_main_positiony']   = { nil, ImGuiVar_INT32,        0x0000 },

    -- Main bar settings..
    ['var_expmon_bar_color']        = { nil, ImGuiVar_FLOATARRAY,   0x0004 },
    ['var_expmon_bar_bgcolor']      = { nil, ImGuiVar_FLOATARRAY,   0x0004 },
    ['var_expmon_bar_file']         = { nil, ImGuiVar_CDSTRING,     0x00FF },
    ['var_expmon_bar_scalex']       = { nil, ImGuiVar_INT32,        0x0001 },
    ['var_expmon_bar_scaley']       = { nil, ImGuiVar_INT32,        0x0001 },
    ['var_expmon_bar_sizex']        = { nil, ImGuiVar_INT32,        0x01D8 },
    ['var_expmon_bar_sizey']        = { nil, ImGuiVar_INT32,        0x0005 },
    
    -- Fill bar settings..
    ['var_expmon_fill_color']       = { nil, ImGuiVar_FLOATARRAY,   0x0004 },
    ['var_expmon_fill_bgcolor']     = { nil, ImGuiVar_FLOATARRAY,   0x0004 },
    ['var_expmon_fill_file']        = { nil, ImGuiVar_CDSTRING,     0x00FF },
    ['var_expmon_fill_maxwidth']    = { nil, ImGuiVar_INT32,        0x01D2 },
    ['var_expmon_fill_positionx']   = { nil, ImGuiVar_INT32,        0x0003 },
    ['var_expmon_fill_positiony']   = { nil, ImGuiVar_INT32,        0x0000 },
    ['var_expmon_fill_scalex']      = { nil, ImGuiVar_INT32,        0x0001 },
    ['var_expmon_fill_scaley']      = { nil, ImGuiVar_INT32,        0x0001 },
    ['var_expmon_fill_sizex']       = { nil, ImGuiVar_INT32,        0x0001 },
    ['var_expmon_fill_sizey']       = { nil, ImGuiVar_INT32,        0x0005 },

    -- Font settings..
    ['var_expmon_font_file']        = { nil, ImGuiVar_CDSTRING,     0x00FF },
    ['var_expmon_font_name']        = { nil, ImGuiVar_CDSTRING,     0x00FF },
    ['var_expmon_font_bold']        = { nil, ImGuiVar_BOOLCPP,      true },
    ['var_expmon_font_drawflags']   = { nil, ImGuiVar_INT32,        0x0010 },
    ['var_expmon_font_format']      = { nil, ImGuiVar_CDSTRING,     0x00FF },
    ['var_expmon_font_prefix']      = { nil, ImGuiVar_CDSTRING,     0x00FF },
    ['var_expmon_font_size']        = { nil, ImGuiVar_INT32,        0x000A },
    ['var_expmon_font_strokecolor'] = { nil, ImGuiVar_FLOATARRAY,   0x0004 },
};

----------------------------------------------------------------------------------------------------
-- func: load_settings
-- desc: Loads the addons settings and assigns the ui variable values.
----------------------------------------------------------------------------------------------------
local function load_settings()
    -- Load or default the settings..
    expmon_settings = hook.settings.load_merged(_addon.path .. '\\settings\\settings.json', expmon_settings);

    -- Create the main exp bar..
    local bar = HookCore:GetFontManager():Create('expmon_bar');
    bar:SetAutoResize(false);
    bar:SetBorderSize(0);
    bar:SetColor(expmon_settings.bar.color);
    bar:SetPositionX(expmon_settings.main.position[1]);
    bar:SetPositionY(expmon_settings.main.position[2]);
    bar:SetText('');
    bar:SetVisible(true);
    bar:GetBackground():SetTextureFromFile(_addon.path .. expmon_settings.bar.file);
    bar:GetBackground():SetColor(expmon_settings.bar.bgcolor);
    bar:GetBackground():SetHeight(expmon_settings.bar.size[2]);
    bar:GetBackground():SetScaleX(expmon_settings.bar.scale[1]);
    bar:GetBackground():SetScaleY(expmon_settings.bar.scale[2]);
    bar:GetBackground():SetVisible(true);
    bar:GetBackground():SetWidth(expmon_settings.bar.size[1]);

    -- Create the bar filling..
    local fill = HookCore:GetFontManager():Create('expmon_fill');
    fill:SetAnchor(FrameAnchor.TopLeft)
    fill:SetAutoResize(false);
    fill:SetBold(expmon_settings.font.bold);
    fill:SetBorderSize(0);
    fill:SetColor(expmon_settings.fill.color);
    fill:SetDrawFlags(expmon_settings.font.drawflags);
    fill:SetFontFamily(expmon_settings.font.name);
    fill:SetFontFile(_addon.path .. expmon_settings.font.file);
    fill:SetFontHeight(expmon_settings.font.size);
    fill:SetParent(bar);
    fill:SetPositionX(expmon_settings.fill.position[1]);
    fill:SetPositionY(expmon_settings.fill.position[2]);
    fill:SetStrokeColor(expmon_settings.font.strokecolor);
    fill:SetText('ExpMon by atom0s');
    fill:SetVisible(true);
    fill:GetBackground():SetTextureFromFile(_addon.path .. expmon_settings.fill.file);
    fill:GetBackground():SetColor(expmon_settings.fill.bgcolor);
    fill:GetBackground():SetBorderSizes(0, 0, 0, 0);
    fill:GetBackground():SetBorderVisible(true);
    fill:GetBackground():SetHeight(expmon_settings.fill.size[2]);
    fill:GetBackground():SetScaleX(1);
    fill:GetBackground():SetScaleY(expmon_settings.fill.scale[2]);
    fill:GetBackground():SetVisible(true);
    fill:GetBackground():SetWidth(expmon_settings.fill.size[1]);

    -- Center the exp bar (x axis) if the x position is -1..
    if (expmon_settings.main.position[1] == -1) then
        local gw = HookCore:GetGameWidth();
        local bw = (gw / 2) - (expmon_settings.bar.size[1] / 2);
        expmon_settings.main.position[1] = bw;
        bar:SetPositionX(expmon_settings.main.position[1]);
    end

    -- Position the exp bar (y axis) towards the bottom of the screen..
    if (expmon_settings.main.position[2] == -1) then
        local gh = HookCore:GetGameHeight();
        local bh = gh - 175;
        expmon_settings.main.position[2] = bh;
        bar:SetPositionY(expmon_settings.main.position[2]);
    end

    -- Update the ui variables..
    imgui.SetVarValue(variables['var_expmon_showeditor'][1], false);
    imgui.SetVarValue(variables['var_expmon_main_positionx'][1], expmon_settings.main.position[1]);
    imgui.SetVarValue(variables['var_expmon_main_positiony'][1], expmon_settings.main.position[2]);

    local a, r, g, b = math.color_to_argb(expmon_settings.bar.color);
    imgui.SetVarValue(variables['var_expmon_bar_color'][1], r / 255, g / 255, b / 255, a / 255);
    local a, r, g, b = math.color_to_argb(expmon_settings.bar.bgcolor);
    imgui.SetVarValue(variables['var_expmon_bar_bgcolor'][1], r / 255, g / 255, b / 255, a / 255);
    imgui.SetVarValue(variables['var_expmon_bar_file'][1], expmon_settings.bar.file);
    imgui.SetVarValue(variables['var_expmon_bar_scalex'][1], 1);
    imgui.SetVarValue(variables['var_expmon_bar_scaley'][1], expmon_settings.bar.scale[2]);
    imgui.SetVarValue(variables['var_expmon_bar_sizex'][1], expmon_settings.bar.size[1]);
    imgui.SetVarValue(variables['var_expmon_bar_sizey'][1], expmon_settings.bar.size[2]);

    local a, r, g, b = math.color_to_argb(expmon_settings.fill.color);
    imgui.SetVarValue(variables['var_expmon_fill_color'][1], r / 255, g / 255, b / 255, a / 255);
    local a, r, g, b = math.color_to_argb(expmon_settings.fill.bgcolor);
    imgui.SetVarValue(variables['var_expmon_fill_bgcolor'][1], r / 255, g / 255, b / 255, a / 255);
    imgui.SetVarValue(variables['var_expmon_fill_file'][1], expmon_settings.fill.file);
    imgui.SetVarValue(variables['var_expmon_fill_maxwidth'][1], expmon_settings.fill.max_width);
    imgui.SetVarValue(variables['var_expmon_fill_positionx'][1], expmon_settings.fill.position[1]);
    imgui.SetVarValue(variables['var_expmon_fill_positiony'][1], expmon_settings.fill.position[2]);
    imgui.SetVarValue(variables['var_expmon_fill_scalex'][1], expmon_settings.fill.scale[1]);
    imgui.SetVarValue(variables['var_expmon_fill_scaley'][1], expmon_settings.fill.scale[2]);
    imgui.SetVarValue(variables['var_expmon_fill_sizex'][1], expmon_settings.fill.size[1]);
    imgui.SetVarValue(variables['var_expmon_fill_sizey'][1], expmon_settings.fill.size[2]);

    imgui.SetVarValue(variables['var_expmon_font_file'][1], expmon_settings.font.file);
    imgui.SetVarValue(variables['var_expmon_font_name'][1], expmon_settings.font.name);
    imgui.SetVarValue(variables['var_expmon_font_bold'][1], expmon_settings.font.bold);
    imgui.SetVarValue(variables['var_expmon_font_drawflags'][1], expmon_settings.font.drawflags);
    imgui.SetVarValue(variables['var_expmon_font_format'][1], expmon_settings.font.format);
    imgui.SetVarValue(variables['var_expmon_font_prefix'][1], expmon_settings.font.prefix);
    imgui.SetVarValue(variables['var_expmon_font_size'][1], expmon_settings.font.size);
    local a, r, g, b = math.color_to_argb(expmon_settings.font.strokecolor);
    imgui.SetVarValue(variables['var_expmon_font_strokecolor'][1], r / 255, g / 255, b / 255, a / 255);
end

----------------------------------------------------------------------------------------------------
-- func: save_settings
-- desc: Saves the addons settings.
----------------------------------------------------------------------------------------------------
local function save_settings()
    -- Get the font objects..
    local bar = HookCore:GetFontManager():Get('expmon_bar');
    local fill = HookCore:GetFontManager():Get('expmon_fill');

    -- Update the main settings..
    expmon_settings.main.position[1] = bar:GetPositionX();
    expmon_settings.main.position[2] = bar:GetPositionY();
    
    -- Update the main bar settings..
    expmon_settings.bar.color = bar:GetColor();
    expmon_settings.bar.bgcolor = bar:GetBackground():GetColor();
    expmon_settings.bar.file = imgui.GetVarValue(variables['var_expmon_bar_file'][1]);
    expmon_settings.bar.scale[1] = bar:GetBackground():GetScaleX();
    expmon_settings.bar.scale[2] = bar:GetBackground():GetScaleY();
    expmon_settings.bar.size[1] = bar:GetBackground():GetWidth();
    expmon_settings.bar.size[2] = bar:GetBackground():GetHeight();
    
    -- Update the fill bar settings..
    expmon_settings.fill.color = fill:GetColor();
    expmon_settings.fill.bgcolor = fill:GetBackground():GetColor();
    expmon_settings.fill.file = imgui.GetVarValue(variables['var_expmon_fill_file'][1]);
    expmon_settings.fill.max_width = imgui:GetVarValue(variables['var_expmon_fill_maxwidth'][1]);
    expmon_settings.fill.position[1] = fill:GetPositionX();
    expmon_settings.fill.position[2] = fill:GetPositionY();
    expmon_settings.fill.scale[1] = fill:GetBackground():GetScaleX();
    expmon_settings.fill.scale[2] = fill:GetBackground():GetScaleY();
    expmon_settings.fill.size[1] = fill:GetBackground():GetWidth();
    expmon_settings.fill.size[2] = fill:GetBackground():GetHeight();
    
    -- Update the font settings..
    expmon_settings.font.file = imgui.GetVarValue(variables['var_expmon_font_file'][1]);
    expmon_settings.font.name = imgui.GetVarValue(variables['var_expmon_font_name'][1]);
    expmon_settings.font.bold = fill:GetBold();
    expmon_settings.font.drawflags = fill:GetDrawFlags();
    expmon_settings.font.format = imgui.GetVarValue(variables['var_expmon_font_format'][1]);
    expmon_settings.font.prefix = imgui.GetVarValue(variables['var_expmon_font_prefix'][1]);
    expmon_settings.font.size = fill:GetFontHeight();
    expmon_settings.font.strokecolor = fill:GetStrokeColor();

    -- Save the settings table..
    hook.settings.save(_addon.path .. '\\settings\\settings.json', expmon_settings);
end

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is first loaded.
----------------------------------------------------------------------------------------------------
hook.events.register_event('load', 'expmon_load', function()
    -- Load the ui variables..
    for k, v in pairs(variables) do
        if (v[2] >= ImGuiVar_CDSTRING) then
            -- Handle array based variable types..
            variables[k][1] = imgui.CreateVar(variables[k][2], variables[k][3]);
        else
            -- Handle non-array based variable types..
            variables[k][1] = imgui.CreateVar(variables[k][2]);
        end
        
        -- Initialize the variables with their default values..
        if (v[2] < ImGuiVar_CDSTRING) then
            imgui.SetVarValue(variables[k][1], variables[k][3]);
        end 
    end

    -- Load the settings..
    load_settings();
end);

----------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Event called when the addon is unloaded.
----------------------------------------------------------------------------------------------------
hook.events.register_event('unload', 'expmon_unload', function()
    -- Save the settings..
    save_settings();

    -- Cleanup ui variables..
    for k, v in pairs(variables) do
        if (variables[k][1] ~= nil) then
            imgui.DeleteVar(variables[k][1]);
        end
        variables[k][1] = nil;
    end

    -- Cleanup the font objects..
    HookCore:GetFontManager():Delete('expmon_bar');
    HookCore:GetFontManager():Delete('expmon_fill');
end);

----------------------------------------------------------------------------------------------------
-- func: command
-- desc: Event called when the addon is given the chance to handle a console command.
----------------------------------------------------------------------------------------------------
hook.events.register_event('command', 'expmon_command', function(command)
    -- Ignore non-expmon commands..
    if (command ~= '/expmon') then
        return false;
    end

    -- Toggle the editor ui..
    imgui.SetVarValue(variables['var_expmon_showeditor'][1], not imgui.GetVarValue(variables['var_expmon_showeditor'][1]));
    return true;
end);

----------------------------------------------------------------------------------------------------
-- func: prepresent
-- desc: Event called when the addon is told the game is about to present a scene.
----------------------------------------------------------------------------------------------------
hook.events.register_event('prepresent', 'expmon_prepresent', function()
    -- Obtain the exp bar fill object..
    local fill = HookCore:GetFontManager():Get('expmon_fill');
    if (fill == nil) then
        return;
    end

    -- Obtain the local player actor..
    local p = reckoning.actor.get_local_player_actor();
    if (p == nil or p == 0) then
        return;
    end

    -- Obtain the local players level..
    local lvl = reckoning.actor.get_level(p);
    if (lvl == 0) then
        return;
    end
    
    -- Obtain the local players total exp..
    local exp = reckoning.actor.get_variable(p, 0x00378381);
    if (exp == nil or exp.value == nil or exp.value[1] == nil) then
        return;
    end

    -- Calculate the players exp values..
    local currentExp = exp.value[1] - reckoning.constants.exp_to_level_table[lvl];
    local neededExp = reckoning.constants.exp_to_level_table[lvl + 1] - reckoning.constants.exp_to_level_table[lvl];
    
    -- Calculate the bar width based on its texture size and exp values..
    local fillWidth = ((currentExp / neededExp) * expmon_settings.fill.max_width);

    -- Update the bar fill..
    fill:GetBackground():SetScaleX(fillWidth);
        
    -- Update the bar text..
    local str = expmon_settings.font.prefix;
    str = str .. string.format(expmon_settings.font.format, currentExp, neededExp);
    fill:SetText(str);
end);

----------------------------------------------------------------------------------------------------
-- func: prepresent
-- desc: Event called when the addon is told the game is about to present a scene.
----------------------------------------------------------------------------------------------------
hook.events.register_event('prepresent', 'expmon_prepresent_editor', function()
    -- Check if the editor window should be drawn..
    if (imgui.GetVarValue(variables['var_expmon_showeditor'][1]) == false) then
        return;
    end

    -- Obtain the bar objects..
    local bar = HookCore:GetFontManager():Get('expmon_bar');
    local fill = HookCore:GetFontManager():Get('expmon_fill');
    if (bar == nil or fill == nil) then
        return;
    end

    -- Render the bar editor window..
    imgui.SetNextWindowSize(550, 600, ImGuiSetCondition_FirstUseEver);
    imgui.SetNextWindowSizeConstraints(550, 600, FLT_MAX, FLT_MAX);
    if (not imgui.Begin('ExpMon Settings Editor', variables['var_expmon_showeditor'][1], ImGuiWindowFlags_NoResize)) then
        imgui.End();
        return;
    end

    -- Begin the inner child element..
    imgui.BeginChild('leftpane', -1, -1, true);

    -- Begin main settings..
    imgui.TextColored(0.2, 0.8, 1.0, 1.0, 'Main Settings');
    imgui.Separator();

    if (imgui.InputInt('Bar Position X', variables['var_expmon_main_positionx'][1])) then
        local x = imgui.GetVarValue(variables['var_expmon_main_positionx'][1]);
        bar:SetPositionX(x);
        save_settings();
    else
        imgui.SetVarValue(variables['var_expmon_main_positionx'][1], bar:GetPositionX());
    end
    if (imgui.InputInt('Bar Position Y', variables['var_expmon_main_positiony'][1])) then
        local y = imgui.GetVarValue(variables['var_expmon_main_positiony'][1]);
        bar:SetPositionY(y);
        save_settings();
    else
        imgui.SetVarValue(variables['var_expmon_main_positiony'][1], bar:GetPositionY());
    end

    -- Begin main bar settings..
    imgui.Separator();
    imgui.TextColored(0.2, 0.8, 1.0, 1.0, 'Main Bar Settings');
    imgui.Separator();

    if (imgui.ColorEdit4('Bar Color', variables['var_expmon_bar_color'][1])) then
        bar:SetColor(math.colortable_to_int(imgui.GetVarValue(variables['var_expmon_bar_color'][1])));
        save_settings();
    end
    if (imgui.ColorEdit4('Bar Background Color', variables['var_expmon_bar_bgcolor'][1])) then
        bar:GetBackground():SetColor(math.colortable_to_int(imgui.GetVarValue(variables['var_expmon_bar_bgcolor'][1])));
        save_settings();
    end
    if (imgui.InputText('Bar Texture File', variables['var_expmon_bar_file'][1], 255)) then
        local path = _addon.path .. imgui.GetVarValue(variables['var_expmon_bar_file'][1]);
        bar:GetBackground():SetTextureFromFile(path);
        save_settings();
    end
    if (imgui.InputInt('Bar Scale X', variables['var_expmon_bar_scalex'][1])) then
        local x = imgui.GetVarValue(variables['var_expmon_bar_scalex'][1]);
        bar:GetBackground():SetScaleX(x);
        save_settings();
    end
    if (imgui.InputInt('Bar Scale Y', variables['var_expmon_bar_scaley'][1])) then
        local y = imgui.GetVarValue(variables['var_expmon_bar_scaley'][1]);
        bar:GetBackground():SetScaleY(y);
        save_settings();
    end
    if (imgui.InputInt('Bar Size X', variables['var_expmon_bar_sizex'][1])) then
        local x = imgui.GetVarValue(variables['var_expmon_bar_sizex'][1]);
        bar:GetBackground():SetWidth(x);
        save_settings();
    end
    if (imgui.InputInt('Bar Size Y', variables['var_expmon_bar_sizey'][1])) then
        local y = imgui.GetVarValue(variables['var_expmon_bar_sizey'][1]);
        bar:GetBackground():SetHeight(y);
        save_settings();
    end

    -- Begin fill bar settings..
    imgui.Separator();
    imgui.TextColored(0.2, 0.8, 1.0, 1.0, 'Fill Bar Settings');
    imgui.Separator();

    if (imgui.ColorEdit4('Fill Color', variables['var_expmon_fill_color'][1])) then
        fill:SetColor(math.colortable_to_int(imgui.GetVarValue(variables['var_expmon_fill_color'][1])));
        save_settings();
    end
    if (imgui.ColorEdit4('Fill Background Color', variables['var_expmon_fill_bgcolor'][1])) then
        fill:GetBackground():SetColor(math.colortable_to_int(imgui.GetVarValue(variables['var_expmon_fill_bgcolor'][1])));
        save_settings();
    end
    if (imgui.InputText('Fill Texture File', variables['var_expmon_fill_file'][1], 255)) then
        local path = _addon.path .. imgui.GetVarValue(variables['var_expmon_fill_file'][1]);
        fill:GetBackground():SetTextureFromFile(path);
        save_settings();
    end
    if (imgui.InputInt('Fill Max Width', variables['var_expmon_fill_maxwidth'][1])) then
        save_settings();
    end
    if (imgui.InputInt('Fill Position X', variables['var_expmon_fill_positionx'][1])) then
        local x = imgui.GetVarValue(variables['var_expmon_fill_positionx'][1]);
        fill:SetPositionX(x);
        save_settings();
    end
    if (imgui.InputInt('Fill Position Y', variables['var_expmon_fill_positiony'][1])) then
        local y = imgui.GetVarValue(variables['var_expmon_fill_positiony'][1]);
        fill:SetPositionY(y);
        save_settings();
    end
    if (imgui.InputInt('Fill Scale X', variables['var_expmon_fill_scalex'][1])) then
        local x = imgui.GetVarValue(variables['var_expmon_fill_scalex'][1]);
        fill:GetBackground():SetScaleX(x);
        save_settings();
    end
    if (imgui.InputInt('Fill Scale Y', variables['var_expmon_fill_scaley'][1])) then
        local y = imgui.GetVarValue(variables['var_expmon_fill_scaley'][1]);
        fill:GetBackground():SetScaleY(y);
        save_settings();
    end
    if (imgui.InputInt('Fill Size X', variables['var_expmon_fill_sizex'][1])) then
        local x = imgui.GetVarValue(variables['var_expmon_fill_sizex'][1]);
        fill:GetBackground():SetWidth(x);
        save_settings();
    end
    if (imgui.InputInt('Fill Size Y', variables['var_expmon_fill_sizey'][1])) then
        local y = imgui.GetVarValue(variables['var_expmon_fill_sizey'][1]);
        fill:GetBackground():SetHeight(y);
        save_settings();
    end

    -- Begin font settings..
    imgui.Separator();
    imgui.TextColored(0.2, 0.8, 1.0, 1.0, 'Font Settings');
    imgui.Separator();

    if (imgui.InputText('Font File', variables['var_expmon_font_file'][1], 255)) then
        local path = _addon.path .. imgui.GetVarValue(variables['var_expmon_font_file'][1]);
        fill:SetFontFile(path);
        save_settings();
    end
    if (imgui.InputText('Font Name', variables['var_expmon_font_name'][1], 255)) then
        local name = imgui.GetVarValue(variables['var_expmon_font_name'][1]);
        fill:SetFontFamily(name);
        save_settings();
    end
    if (imgui.InputInt('Font Size', variables['var_expmon_font_size'][1])) then
        local size = imgui.GetVarValue(variables['var_expmon_font_size'][1]);
        fill:SetFontHeight(size);
        save_settings();
    end
    if (imgui.Checkbox('Use Bold Font?', variables['var_expmon_font_bold'][1])) then
        save_settings();
    end
    if (imgui.InputText('Font Prefix', variables['var_expmon_font_prefix'][1], 255)) then
        save_settings();
    end
    if (imgui.InputText('Font Format', variables['var_expmon_font_format'][1], 255)) then
        save_settings();
    end
    if (imgui.InputInt('Font Draw Flags', variables['var_expmon_font_drawflags'][1])) then
        local flags = imgui.GetVarValue(variables['var_expmon_font_drawflags'][1]);
        fill:SetDrawFlags(flags);
        save_settings();
    end
    if (imgui.ColorEdit4('Font Stroke Color', variables['var_expmon_font_strokecolor'][1])) then
        fill:SetStrokeColor(math.colortable_to_int(imgui.GetVarValue(variables['var_expmon_font_strokecolor'][1])));
        save_settings();
    end

    imgui.EndChild();
    imgui.End();
end);