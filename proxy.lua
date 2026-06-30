--========================================================--
-- LucjferProxy v1.0
-- Author : Lucjfer#9704
--========================================================--

local CONFIG = {
    AUTHOR = "Lucjfer#9704",
    VERSION = "1.0",
    PREFIX = "`9[Lucjfer#9704] `w"
}

local ITEM = {
    d = {id = 1796, name = "Diamond Lock"},
    w = {id = 242, name = "World Lock"},
    b = {id = 7188, name = "Blue Gem Lock"}
}

------------------------------------------------------------
-- Inventory
------------------------------------------------------------

function GetItemCount(id)
    for _, item in pairs(getInventory()) do
        if item.id == id then
            return item.amount
        end
    end
    return 0
end

------------------------------------------------------------
-- Drop Item
------------------------------------------------------------

function DropItem(id, amount)
    SendPacket(2,
        "action|dialog_return\n" ..
        "dialog_name|drop\n" ..
        "item_drop|" .. id .. "|\n" ..
        "item_count|" .. amount
    )
end

------------------------------------------------------------
-- Menu
------------------------------------------------------------

function OpenMenu()

    SendVariant({
        v0 = "OnDialogRequest",
        v1 = [[
set_default_color|`w

add_label_with_icon|big|`9LucjferProxy|left|1796|
add_spacer|small|

add_textbox|`2Status : `aLoaded|left|
add_textbox|`2Version : `91.0|left|
add_textbox|`2Author : `9Lucjfer#9704|left|

add_spacer|small|

add_textbox|`bDrop Commands|left|

add_textbox|`2/d <amount> `8» `wDrop Diamond Lock|left|
add_textbox|`2/da `8» `wDrop All Diamond Lock|left|

add_textbox|`2/w <amount> `8» `wDrop World Lock|left|
add_textbox|`2/wa `8» `wDrop All World Lock|left|

add_textbox|`2/b <amount> `8» `wDrop Blue Gem Lock|left|
add_textbox|`2/ba `8» `wDrop All Blue Gem Lock|left|

add_spacer|small|

add_textbox|`bUtilities|left|
add_textbox|`2/ls `8» `wLock Status|left|

add_spacer|small|

end_dialog|menu|Close|
]]
    })

end

------------------------------------------------------------
-- Lock Status
------------------------------------------------------------

function LockStatus()

    local wl = GetItemCount(242)
    local dl = GetItemCount(1796)
    local bgl = GetItemCount(7188)

    SendVariant({
        v0 = "OnDialogRequest",
        v1 =
"set_default_color|`w\n" ..

"add_label_with_icon|big|`bLock Status|left|1796|\n" ..

"add_spacer|small|\n" ..

"add_textbox|`2World Lock `8: `9"..wl.."|left|\n" ..
"add_textbox|`2Diamond Lock `8: `9"..dl.."|left|\n" ..
"add_textbox|`2Blue Gem Lock `8: `9"..bgl.."|left|\n" ..

"add_spacer|small|\n" ..

"add_textbox|`2Author `8: `9"..CONFIG.AUTHOR.."|left|\n" ..

"end_dialog|close|Close|"
    })

end


------------------------------------------------------------
-- Command Handler
------------------------------------------------------------

AddHook("OnSendPacket", "LucjferProxy", function(type, pkt)

    if type ~= 2 then
        return
    end

    --------------------------------------------------------
    -- MENU
    --------------------------------------------------------

    if pkt:find("action|input\n|text|/m") or pkt:find("action|input\n|text|/menu") then
        OpenMenu()
        return true
    end

    --------------------------------------------------------
    -- LOCK STATUS
    --------------------------------------------------------

    if pkt:find("action|input\n|text|/ls") then
        LockStatus()
        return true
    end

    --------------------------------------------------------
    -- DROP DIAMOND LOCK
    --------------------------------------------------------

    local d = pkt:match("action|input\n|text|/d%s+(%d+)")

    if d then
        DropItem(1796, tonumber(d))
        LogToConsole(CONFIG.PREFIX ..
            "`2Dropped `9" .. d .. " `bDiamond Lock")
        return true
    end

    --------------------------------------------------------
    -- DROP ALL DIAMOND LOCK
    --------------------------------------------------------

    if pkt:find("action|input\n|text|/da") then

        local count = GetItemCount(1796)

        if count > 0 then
            DropItem(1796, count)
            LogToConsole(CONFIG.PREFIX ..
                "`2Dropped All `9Diamond Lock `7(" .. count .. ")")
        else
            LogToConsole(CONFIG.PREFIX ..
                "`4You don't have any Diamond Lock.")
        end

        return true
    end

    --------------------------------------------------------
    -- DROP WORLD LOCK
    --------------------------------------------------------

    local w = pkt:match("action|input\n|text|/w%s+(%d+)")

    if w then
        DropItem(242, tonumber(w))
        LogToConsole(CONFIG.PREFIX ..
            "`2Dropped `9" .. w .. " `6World Lock")
        return true
    end

    --------------------------------------------------------
    -- DROP ALL WORLD LOCK
    --------------------------------------------------------

    if pkt:find("action|input\n|text|/wa") then

        local count = GetItemCount(242)

        if count > 0 then
            DropItem(242, count)
            LogToConsole(CONFIG.PREFIX ..
                "`2Dropped All `6World Lock `7(" .. count .. ")")
        else
            LogToConsole(CONFIG.PREFIX ..
                "`4You don't have any World Lock.")
        end

        return true
    end

    --------------------------------------------------------
    -- DROP BLUE GEM LOCK
    --------------------------------------------------------

    local b = pkt:match("action|input\n|text|/b%s+(%d+)")

    if b then
        DropItem(7188, tonumber(b))
        LogToConsole(CONFIG.PREFIX ..
            "`2Dropped `9" .. b .. " `1Blue Gem Lock")
        return true
    end

    --------------------------------------------------------
    -- DROP ALL BLUE GEM LOCK
    --------------------------------------------------------

    if pkt:find("action|input\n|text|/ba") then

        local count = GetItemCount(7188)

        if count > 0 then
            DropItem(7188, count)
            LogToConsole(CONFIG.PREFIX ..
                "`2Dropped All `1Blue Gem Lock `7(" .. count .. ")")
        else
            LogToConsole(CONFIG.PREFIX ..
                "`4You don't have any Blue Gem Lock.")
        end

        return true
    end

end)

------------------------------------------------------------
-- Startup
------------------------------------------------------------

LogToConsole("`9======================================")
LogToConsole(CONFIG.PREFIX .. "`2Loaded Successfully!")
LogToConsole(CONFIG.PREFIX .. "`7Version : `91.0")
LogToConsole(CONFIG.PREFIX .. "`7Author  : `9" .. CONFIG.AUTHOR)
LogToConsole(CONFIG.PREFIX .. "`7Commands: `2/menu `7or `2/m")
LogToConsole("`9======================================")
