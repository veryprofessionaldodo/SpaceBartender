-- title:  game title
-- author: game developer
-- desc:   short description
-- script: lua

local t = 0

local dialog_t = 0
local dialog_index = 0

local DIALOG_SPEED = 4
local DIALOG_LIMIT = 25

function init() 
    CLIENT = {
        ASTRONAUT = { START = 0 },
        ALIEN = { OFFENDED = 0 },
        CYBORG = { }
    }

    DRINKS = {
        CALM = { APATHY = 0, COURAGE = 1, RATIONAL = 2 },
        FURY = { APATHY = 3, COURAGE = 4, RATIONAL = 5 }
    }

    CURR_STATE = CLIENT.ASTRONAUT.START
end

function update_state_machine(event)
    if (CURR_STATE == CLIENT.ASTRONAUT.START) then
        if (event == DRINKS.CALM.COURAGE) then CURR_STATE = ALIEN.OFFENDED end
    end
end

function scroll_text(text)
    dialog_t = dialog_t + 1

    if (dialog_t % DIALOG_SPEED == 0) then
        dialog_index = dialog_index + 1
    end

    for i = 1, dialog_index do
        local line = math.ceil(dialog_index / DIALOG_LIMIT)

        for j = 1, line do
            local line_i
            if i >= j * DIALOG_LIMIT then line_i = DIALOG_LIMIT else line_i = i end
            print(text:sub(DIALOG_LIMIT * (j-1), line_i), 0, j*8)
        end
    end
end

function TIC()
    cls(0)
    t = t+1

    scroll_text('poo eyes semen nacho feather leather coat poo eyes semen nacho feather leather coat')
end


