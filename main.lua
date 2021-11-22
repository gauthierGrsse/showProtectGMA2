-- ShowProtect
-- v0.1
-- Mot de passe :
local password = "012345"
-- A noter que le mot de passe est en clair dans le plugin, mais il ne pourra pas être lu par quelqu'un voulant charger le show.
-- Vous pouvez compiler le code pour le cacher mais vous ne pourrez plus modifier votre mot de passe facilement.

-- Shortcut :
local cmd = gma.cmd
local confirm = gma.gui.confirm
local textinput = gma.textinput
local getobj = gma.show.getobj
local msgbox = gma.gui.msgbox

local function feedback(text)
    gma.feedback("Plugin ShowProtect : " .. text)
end

local function bigFeedback(text)
    msgbox("ShowProtect", text)
    feedback(text)
end

local function error(text)
    msgbox("Plugin ShowProtect ERREUR", text)
    feedback("ShowProtect plugin ERREUR : " .. text)
end

-- START Plugin

local function findMacroName(name)
    if getobj.verify(getobj.handle('Macro "' .. name .. '"')) then
        return true
    else
        return false
    end
end

local function findAvailableMacro()
    running = true
    id = 1
    while running do
        if not getobj.verify(getobj.handle("Macro " .. id)) then
            running = false
            return id
        else
            id = id + 1
        end
    end
end

local function start(cmdArg)
    if cmdArg == "startShow" then
        local entry
        local running = true
        while running do
            entry = textinput("Mot de passe :", "")
            if entry == password then
                running = false
            else
                if confirm("Mauvais MDP", "Reessayer (ok) ou nouveau show vierge (cancel)") then
                    running = true
                else
                    running = false
                    cmd('NewShow "Nouveau show ' .. gma.gettime() ..
                            '" /timeconfig /globalsetting /localsetting /protocols /network /user')
                end
            end
        end
    else
        if findMacroName("STARTSHOW_SP") then
            error("Macro STARTSHOW existe deja")
        else
            local id = findAvailableMacro()
            cmd('Store Macro ' .. id .. ' "STARTSHOW_SP"')
            cmd('Store Macro 1.' .. id .. '.1')
            cmd('Assign Macro 1.' .. id .. '.1 /wait=0.5')
            cmd('Store Macro 1.' .. id .. '.2 "Plugin SHOWPROTECT startShow"')
            cmd('Assign Root 3.3 /startup="Macro STARTSHOW_SP"')
            bigFeedback("Macro startshow create at Macro " .. id)
        end
    end
end

return start
