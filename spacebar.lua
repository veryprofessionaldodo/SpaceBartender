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
        ASTRONAUT = { START = 00, BATTLE = 01 },
        ALIEN = { OFFENDED = 10, DINNER = 11, MARRIAGE = 12 },
        CYBORG = { ADVICE = 20, SAD = 21, BATTLE_AGGRO = 22, BATTLE_CALM = 23 }
    }
    
    -- BATTLE_CA means astronaut was CALM and cyborg was AGGRO.
    ENDING = {
        SABOTAGE = 100, THREAT = 101, CONFORMED = 102,
        BATTLE_CA = 103, BATTLE_AC = 104, BATTLE_CC = 105, BATTLE_AA = 106,
        NOTHING = 107, MARRIED = 108, BARTENDER_QUITS = 109, LGBTQ = 110, GENOCIDE = 111, ALL_ALONE = 112
    }

    DRINKS = {
        CALM = { APATHY = 0, COURAGE = 1, RATIONAL = 2 },
        AGGRO = { APATHY = 3, COURAGE = 4, RATIONAL = 5 }
    }

    CURR_STATE = CLIENT.ASTRONAUT.START
end

function update_state_machine(event)
    -- First astronaut interaction.
    if (CURR_STATE == CLIENT.ASTRONAUT.START) then
        if (event == DRINKS.AGGRO.COURAGE) then CURR_STATE = CLIENT.ALIEN.OFFENDED end
        if (event == DRINKS.AGGRO.RATIONAL) then CURR_STATE = CLIENT.ALIEN.MARRIAGE end
        if (event == DRINKS.AGGRO.APATHY) then CURR_STATE = ENDING.NOTHING end
        if (event == DRINKS.CALM.COURAGE) then CURR_STATE = CLIENT.ALIEN.MARRIAGE end
        if (event == DRINKS.CALM.RATIONAL) then CURR_STATE = CLIENT.ALIEN.DINNER end
        if (event == DRINKS.CALM.APATHY) then CURR_STATE = ENDING.NOTHING end

    elseif (CURR_STATE == CLIENT.ALIEN.OFFENDED) then
        if (event == DRINKS.AGGRO.COURAGE) then CURR_STATE = CLIENT.CYBORG.ADVICE end
        if (event == DRINKS.AGGRO.RATIONAL) then CURR_STATE = CLIENT.CYBORG.ADVICE end
        if (event == DRINKS.AGGRO.APATHY) then CURR_STATE = CLIENT.CYBORG.ADVICE end
        if (event == DRINKS.CALM.COURAGE) then CURR_STATE = CLIENT.CYBORG.SAD end
        if (event == DRINKS.CALM.RATIONAL) then CURR_STATE = CLIENT.CYBORG.SAD end
        if (event == DRINKS.CALM.APATHY) then CURR_STATE = CLIENT.CYBORG.ADVICE end

    elseif (CURR_STATE == CLIENT.ALIEN.MARRIAGE) then
        if (event == DRINKS.AGGRO.COURAGE) then CURR_STATE = ENDING.MARRIED end
        if (event == DRINKS.AGGRO.RATIONAL) then CURR_STATE = CLIENT.CYBORG.ADVICE end
        if (event == DRINKS.AGGRO.APATHY) then CURR_STATE = CLIENT.CYBORG.ADVICE end
        if (event == DRINKS.CALM.COURAGE) then CURR_STATE = ENDING.MARRIED end
        if (event == DRINKS.CALM.RATIONAL) then CURR_STATE = CLIENT.CYBORG.ADVICE end
        if (event == DRINKS.CALM.APATHY) then CURR_STATE = CLIENT.CYBORG.ADVICE end

    elseif (CURR_STATE == CLIENT.ALIEN.DINNER) then
        if (event == DRINKS.AGGRO.COURAGE) then CURR_STATE = CLIENT.CYBORG.ADVICE end
        if (event == DRINKS.AGGRO.RATIONAL) then CURR_STATE = ENDING.BARTENDER_QUITS end
        if (event == DRINKS.AGGRO.APATHY) then CURR_STATE = CLIENT.CYBORG.SAD end
        if (event == DRINKS.CALM.COURAGE) then CURR_STATE = CLIENT.CYBORG.SAD end
        if (event == DRINKS.CALM.RATIONAL) then CURR_STATE = CLIENT.CYBORG.SAD end
        if (event == DRINKS.CALM.APATHY) then CURR_STATE = CLIENT.CYBORG.SAD end

    elseif (CURR_STATE == CLIENT.CYBORG.ADVICE) then
        if (event == DRINKS.AGGRO.COURAGE) then CURR_STATE = ENDING.GENOCIDE end
        if (event == DRINKS.AGGRO.RATIONAL) then CURR_STATE = ENDING.GENOCIDE end
        if (event == DRINKS.AGGRO.APATHY) then CURR_STATE = ENDING.CONFORMED end
        if (event == DRINKS.CALM.COURAGE) then CURR_STATE = ENDING.LGBTQ end
        if (event == DRINKS.CALM.RATIONAL) then CURR_STATE = ENDING.ALL_ALONE end
        if (event == DRINKS.CALM.APATHY) then CURR_STATE = ENDING.ALL_ALONE end

    elseif (CURR_STATE == CLIENT.CYBORG.SAD) then
        if (event == DRINKS.AGGRO.COURAGE) then CURR_STATE = CLIENT.ASTRONAUT.BATTLE end
        if (event == DRINKS.AGGRO.RATIONAL) then CURR_STATE = ENDING.SABOTAGE end
        if (event == DRINKS.AGGRO.APATHY) then CURR_STATE = ENDING.CONFORMED end
        if (event == DRINKS.CALM.COURAGE) then CURR_STATE = ENDING.THREAT end
        if (event == DRINKS.CALM.RATIONAL) then CURR_STATE = ENDING.CONFORMED end
        if (event == DRINKS.CALM.APATHY) then CURR_STATE = ENDING.CONFORMED end

    elseif (CURR_STATE == CLIENT.ASTRONAUT.BATTLE) then
        if (event == DRINKS.AGGRO.COURAGE) then CURR_STATE = CLIENT.CYBORG.BATTLE_AGGRO end
        if (event == DRINKS.AGGRO.RATIONAL) then CURR_STATE = CLIENT.CYBORG.BATTLE_AGGRO end
        if (event == DRINKS.AGGRO.APATHY) then CURR_STATE = CLIENT.CYBORG.BATTLE_AGGRO end
        if (event == DRINKS.CALM.COURAGE) then CURR_STATE = CLIENT.CYBORG.BATTLE_CALM end
        if (event == DRINKS.CALM.RATIONAL) then CURR_STATE = CLIENT.CYBORG.BATTLE_CALM end
        if (event == DRINKS.CALM.APATHY) then CURR_STATE = CLIENT.CYBORG.BATTLE_CALM end

    elseif (CURR_STATE == CLIENT.CYBORG.BATTLE_AGGRO) then
        if (event == DRINKS.AGGRO.COURAGE) then CURR_STATE = ENDING.BATTLE_AA end
        if (event == DRINKS.AGGRO.RATIONAL) then CURR_STATE = ENDING.BATTLE_AA end
        if (event == DRINKS.AGGRO.APATHY) then CURR_STATE = ENDING.BATTLE_AA end
        if (event == DRINKS.CALM.COURAGE) then CURR_STATE = ENDING.BATTLE_AC end
        if (event == DRINKS.CALM.RATIONAL) then CURR_STATE = ENDING.BATTLE_AC end
        if (event == DRINKS.CALM.APATHY) then CURR_STATE = ENDING.BATTLE_AC end

    elseif (CURR_STATE == CLIENT.CYBORG.BATTLE_CALM) then
        if (event == DRINKS.AGGRO.COURAGE) then CURR_STATE = ENDING.BATTLE_CA end
        if (event == DRINKS.AGGRO.RATIONAL) then CURR_STATE = ENDING.BATTLE_CA end
        if (event == DRINKS.AGGRO.APATHY) then CURR_STATE = ENDING.BATTLE_CA end
        if (event == DRINKS.CALM.COURAGE) then CURR_STATE = ENDING.BATTLE_CC end
        if (event == DRINKS.CALM.RATIONAL) then CURR_STATE = ENDING.BATTLE_CC end
        if (event == DRINKS.CALM.APATHY) then CURR_STATE = ENDING.BATTLE_CC end
    end
end

function start_encounter()

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


