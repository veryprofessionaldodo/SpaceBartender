-- title:  game title
-- author: game developer
-- desc:   short description
-- script: lua

bartender = {
	anim_time = 0.8,
	anim_counter = 0,
	anim_frame = 0
}

stages = {
	base = 0,
	reaction = 1
}

selection_state = {
    can_select = false,
	is_selecting = false,
    stage = stages.base,
    curr_selection = 1    
}

stars = {}
drinks = {}

counter = {
	y = 90,
	offset = 0,
	anim_time = 0.5,
	anim_counter = 1	
}

drink_types = { 
	calm="calm",
	aggro="aggro",
	rational="rational", 
	apathy="apathy",
	courage="courage" 
}

selected_drink = {
	-- selected position in drink array
	--pos = 0,
	base = "",
	reaction = ""
}

characters = {
	ai="ai",
	alien="alien",
	astronaut="astronaut"
}

-- Creates drinks and pushes them to the drinks array.
function create_drinks()
	calm = {
		type = drink_types.calm,
		x = 20,
		y = 10,
		offset_y = 0,
		sprite = 2,
		dir = 1,
		anim_time = 30 + math.random(50),
		anim_counter = math.random(20),
		description = 'Wow, so calm'
	}

	aggro = {
		type = drink_types.aggro,
		x = 70,
		y = 10,
		offset_y = 0,
		sprite = 0,
		dir = 1,
		anim_time = 30 + math.random(50),
		anim_counter = math.random(20),
		description = 'Damn, so angery'
	}  
	
	courage = {
		type = drink_types.courage,
		x = 10,
		y = 50,
		offset_y = 0,
		sprite = 6,
		dir = 1,
		anim_time = 30 + math.random(50),
		anim_counter = math.random(20),
		description = 'Wow, much courage'
	}
	
	apathy  = {
 	type = drink_types.apathy,
		x = 47,
		y = 50,
		sprite = 4,
		dir = 1,
		offset_y = 0,
		anim_time = 30 + math.random(50),
		anim_counter = math.random(20),
		description = 'idgaf'
	}
	
	rational = {
		type = drink_types.rational,
		x = 85,
		y = 50,
		sprite = 8,
		offset_y = 0,
		anim_time = 30 + math.random(50),
		anim_counter = math.random(20),
		dir = 1,
		description = 'Big brain time'
	}

    table.insert(drinks,calm)
    table.insert(drinks,aggro)
	table.insert(drinks,courage)
	table.insert(drinks,apathy)
	table.insert(drinks,rational)
	
end

function create_stars() 
	for i = 1, 70 do
		star = {
			distance = math.random(100,600),
			x = math.random(-10,250),
			y = math.random(-10,170)
		}
		
		table.insert(stars,star)
	end
end

function update_stars()
	for i = 1 , #stars do
		stars[i].x = stars[i].x - 10/stars[i].distance
		if stars[i].x < -5 then
			stars[i].x = math.random(250,280)
			stars[i].y = math.random(0,170)
		end
	end
end

function update_drinks()
	for i = 1, #drinks do 
		drinks[i].anim_counter = drinks[i].anim_counter + 1/3
		if drinks[i].anim_counter > drinks[i].anim_time then
			drinks[i].anim_counter = 0
			drinks[i].offset_y = drinks[i].dir
			drinks[i].dir = -drinks[i].dir
		end
	end
end

function draw_drinks()
    for i = 1, #drinks do 
        spr(drinks[i].sprite, drinks[i].x, drinks[i].y+drinks[i].offset_y,0,2,0,0,2,2)
        if selection_state.is_selecting then 
            if selection_state.curr_selection == i then 
                spr(64,drinks[i].x,drinks[i].y,0,2,0,0,2,2)
            else 
                spr(32,drinks[i].x,drinks[i].y,0,2,0,0,2,2)
            end
        else 
            spr(32,drinks[i].x,drinks[i].y,0,2,0,0,2,2)
        end
	end
end

function draw_stars()
	for i = 1 , #stars do
		color = 0
		
		if stars[i].distance < 250 then
			-- white
			color = 15
		elseif stars[i].distance < 400 then  
		 -- light grey
			color = 10
		else 
		 -- light grey
			color = 3
		end
		
		pix(stars[i].x, stars[i].y, color)
		
	end

end

function update_background()
	update_stars()
	
	update_drinks()
end

function draw_background()
	draw_stars()
	
	draw_drinks()
end

function update_bartender()
	bartender.anim_counter = bartender.anim_counter + 1/60
	if bartender.anim_counter > bartender.anim_time then
		bartender.anim_counter = 0
		bartender.anim_frame = (bartender.anim_frame + 1)%2
	end
end

function draw_bartender()
	anim_id = 256 + 112*bartender.anim_frame
	
	spr(anim_id,120,10,0,2,0,0,5,7)
end

function set_variables()
	ai_wave_counter = 0
	t = 0

	dialog_t = 0
	dialog_index = 0

	DIALOG_SPEED = 4
	DIALOG_LIMIT = 25

	CLIENT = {
        ASTRONAUT = { START = 00, BATTLE = 01 },
        ALIEN = { OFFENDED = 10, DINNER = 11, MARRIAGE = 12 },
        AI = { ADVICE = 20, SAD = 21, BATTLE_AGGRO = 22, BATTLE_CALM = 23 }
    }
    
    -- BATTLE_CA means astronaut was CALM and AI was AGGRO.
    ENDING = {
        SABOTAGE = 100, THREAT = 101, CONFORMED = 102,
        BATTLE_CA = 103, BATTLE_AC = 104, BATTLE_CC = 105, BATTLE_AA = 106,
        NOTHING = 107, MARRIED = 108, BARTENDER_QUITS = 109, LGBTQ = 110, GENOCIDE = 111
    }

    DRINKS = {
        CALM = { APATHY = "CALM_APATHY", COURAGE = "CALM_COURAGE", RATIONAL = "CALM_RATIONAL" },
        AGGRO = { APATHY = "AGGRO_APATHY", COURAGE = "AGGRO_COURAGE", RATIONAL = "AGGRO_RATIONAL" }
    }

	CURR_CLIENT = characters.astronaut
	CURR_STATE = CLIENT.ASTRONAUT.START
	TEXT_FEED = "An astronaut enters the bar."
	TEXT_FEED_OLD = TEXT_FEED
end

function init() 
	create_stars()	
	create_drinks()
	set_variables()
end

init()

function draw_counter()
	spr(34,10,90,0,2,0,0,8,2)
	spr(34,180,90,0,2,0,0,8,2)
	spr(34,70,90,0,2,0,0,8,2)
end

-- Draw clients.
function draw_ai()
	radius = 30
	
	for i = 1, 400 do
		pix(
		50+math.cos(i)*radius+math.sin(ai_wave_counter/60+i)*5 + math.sin(ai_wave_counter/60+i),
		90+math.sin(i)*radius+math.cos(ai_wave_counter/50+i) + math.cos(ai_wave_counter/60+i),7)
	end
	
	radius = 4*math.sin(ai_wave_counter/30)-2*math.sin(ai_wave_counter/30*5)
	radius = math.abs(radius) + 3
	
	circ(50,90,radius, 7)
	
	radius = 17
	
	for i = 1, 400 do
		pix(
		50+math.cos(i)*radius+math.sin(ai_wave_counter/20+i*4),
		90+math.sin(i)*radius+math.cos(ai_wave_counter/20+i*4),15)
	end
	
end

function draw_astronaut()
	spr(261,0,10,0,2,0,0,7,9)
end

function draw_alien()
	spr(389,0,10,0,2,0,0,7,9)
end

function draw_character(character)
	if character == characters.ai then draw_ai() end
	if character == characters.astronaut then draw_astronaut() end
	if character == characters.alien then draw_alien() end
end

-- Gets drink state from base and reagent type strings.
function get_drink_state(base, reagent)
	return string.upper(base) .. "_" .. string.upper(reagent)
end

function handle_input()
	-- left 2
	if btnp(2) then
		if selection_state.stage == stages.base then
			selection_state.curr_selection = 1
        else 
            selection_state.curr_selection = math.max(3,math.min(5, selection_state.curr_selection - 1))
        end
	end
	-- right 3
	if btnp(3) then 
        if selection_state.stage == stages.base then
			selection_state.curr_selection = 2
        else 
            selection_state.curr_selection = math.max(3,math.min(5, selection_state.curr_selection + 1))
        end
    end 
    
    if btnp(4) then 
        if selection_state.stage == stages.base then 
            selection_state.stage = stages.reaction
            selected_drink.base = drinks[selection_state.curr_selection].type
            selection_state.curr_selection = 3
        else 
            selected_drink.reaction = drinks[selection_state.curr_selection].type
            selection_state.curr_selection = 1
            selection_state.stage = stages.base
            selection_state.is_selecting = false
			selection_state.can_select = false
			
			update_state_machine(get_drink_state(selected_drink.base, selected_drink.reaction))
        end
    end
end

function draw_dialog_box(text) 
	if (text ~= TEXT_FEED_OLD) then 
		dialog_index = 0 
		TEXT_FEED_OLD = text
	end

	dialog_t = dialog_t + 1
	local x_pos = 120 - (DIALOG_LIMIT / 2) * 6
	local y_pos = 120

    if (dialog_t % DIALOG_SPEED == 0) then
        dialog_index = dialog_index + 1
	end
	
    for i = 1, dialog_index do
        local line = math.ceil(dialog_index / DIALOG_LIMIT)

        for j = 1, line do
            local line_i
            if i >= j * DIALOG_LIMIT then line_i = DIALOG_LIMIT else line_i = i end
            print(text:sub(DIALOG_LIMIT * (j-1), line_i - 1), x_pos, y_pos + (j-1)*8)
        end
    end
end

function update()
	update_background()
	update_bartender()
	
	if selection_state.is_selecting then
		handle_input()
	end
	
	ai_wave_counter = ai_wave_counter + 1 
end

function draw()
	cls()
	draw_background()
	draw_bartender()
	draw_counter()

	if not selection_state.is_selecting then
		draw_character(CURR_CLIENT)
	end

	draw_dialog_box(TEXT_FEED)
end

function TIC()
	update()
	
	if btnp(4) and selection_state.can_select then
		selection_state.is_selecting = true
    end
    
    if btnp(5) then
        selection_state.can_select  = true
    end
	
	draw()	
end

-- State Machine

function update_state_machine(event)

	if (CURR_STATE == CLIENT.ASTRONAUT.START) then
		if (event == DRINKS.AGGRO.COURAGE) then 
			CURR_STATE = CLIENT.ALIEN.OFFENDED
			CURR_CLIENT = characters.alien
			TEXT_FEED = "The alien should pop up and now she's offended."
		end

		if (event == DRINKS.AGGRO.RATIONAL) then 
			CURR_STATE = CLIENT.ALIEN.MARRIAGE
			CURR_CLIENT = characters.alien 
		end

		if (event == DRINKS.AGGRO.APATHY) then 
			CURR_STATE = ENDING.NOTHING 
		end

		if (event == DRINKS.CALM.COURAGE) then 
			CURR_STATE = CLIENT.ALIEN.MARRIAGE 
			CURR_CLIENT = characters.alien
		end

		if (event == DRINKS.CALM.RATIONAL) then 
			CURR_STATE = CLIENT.ALIEN.DINNER 
			CURR_CLIENT = characters.alien
		end

		if (event == DRINKS.CALM.APATHY) then 
			CURR_STATE = ENDING.NOTHING 
		end

	elseif (CURR_STATE == CLIENT.ALIEN.OFFENDED) then
		if (event == DRINKS.AGGRO.COURAGE) then 
			CURR_STATE = CLIENT.AI.ADVICE 
			CURR_CLIENT = characters.ai
		end

		if (event == DRINKS.AGGRO.RATIONAL) then 
			CURR_STATE = CLIENT.AI.ADVICE
			CURR_CLIENT = characters.ai
		end

		if (event == DRINKS.AGGRO.APATHY) then 
			CURR_STATE = CLIENT.AI.ADVICE
			CURR_CLIENT = characters.ai
		end

		if (event == DRINKS.CALM.COURAGE) then 
			CURR_STATE = CLIENT.AI.SAD
			CURR_CLIENT = characters.ai 
		end

		if (event == DRINKS.CALM.RATIONAL) then 
			CURR_STATE = CLIENT.AI.SAD
			CURR_CLIENT = characters.ai
		end

		if (event == DRINKS.CALM.APATHY) then 
			CURR_STATE = CLIENT.AI.ADVICE
			CURR_CLIENT = characters.ai
		end

    elseif (CURR_STATE == CLIENT.ALIEN.MARRIAGE) then
		if (event == DRINKS.AGGRO.COURAGE) then 
			CURR_STATE = ENDING.MARRIED 
		end

		if (event == DRINKS.AGGRO.RATIONAL) then 
			CURR_STATE = CLIENT.AI.ADVICE
			CURR_CLIENT = characters.ai
		end

		if (event == DRINKS.AGGRO.APATHY) then 
			CURR_STATE = CLIENT.AI.ADVICE
			CURR_CLIENT = characters.ai 
		end

		if (event == DRINKS.CALM.COURAGE) then 
			CURR_STATE = ENDING.MARRIED 
		end
		
		if (event == DRINKS.CALM.RATIONAL) then 
			CURR_STATE = CLIENT.AI.ADVICE 
			CURR_CLIENT = characters.ai
		end

		if (event == DRINKS.CALM.APATHY) then 
			CURR_STATE = CLIENT.AI.ADVICE
			CURR_CLIENT = characters.ai 
		end

    elseif (CURR_STATE == CLIENT.ALIEN.DINNER) then
		if (event == DRINKS.AGGRO.COURAGE) then 
			CURR_STATE = CLIENT.AI.ADVICE 
			CURR_CLIENT = characters.ai
		end

		if (event == DRINKS.AGGRO.RATIONAL) then 
			CURR_STATE = ENDING.BARTENDER_QUITS 
		end

		if (event == DRINKS.AGGRO.APATHY) then 
			CURR_STATE = CLIENT.AI.SAD
			CURR_CLIENT = characters.ai
		end

		if (event == DRINKS.CALM.COURAGE) then 
			CURR_STATE = CLIENT.AI.SAD
			CURR_CLIENT = characters.ai 
		end

		if (event == DRINKS.CALM.RATIONAL) then 
			CURR_STATE = CLIENT.AI.SAD
			CURR_CLIENT = characters.ai 
		end

		if (event == DRINKS.CALM.APATHY) then 
			CURR_STATE = CLIENT.AI.SAD
			CURR_CLIENT = characters.ai 
		end

    elseif (CURR_STATE == CLIENT.AI.ADVICE) then
		if (event == DRINKS.AGGRO.COURAGE) then 
			CURR_STATE = ENDING.GENOCIDE 
		end

		if (event == DRINKS.AGGRO.RATIONAL) then 
			CURR_STATE = ENDING.GENOCIDE 
		end

		if (event == DRINKS.AGGRO.APATHY) then 
			CURR_STATE = ENDING.CONFORMED 
		end

		if (event == DRINKS.CALM.COURAGE) then 
			CURR_STATE = ENDING.LGBTQ 
		end

		if (event == DRINKS.CALM.RATIONAL) then 
			CURR_STATE = ENDING.CONFORMED 
		end

		if (event == DRINKS.CALM.APATHY) then 
			CURR_STATE = ENDING.CONFORMED 
		end

    elseif (CURR_STATE == CLIENT.AI.SAD) then
		if (event == DRINKS.AGGRO.COURAGE) then 
			CURR_STATE = CLIENT.ASTRONAUT.BATTLE 
		end

		if (event == DRINKS.AGGRO.RATIONAL) then 
			CURR_STATE = ENDING.SABOTAGE 
		end

		if (event == DRINKS.AGGRO.APATHY) then 
			CURR_STATE = ENDING.CONFORMED 
		end

		if (event == DRINKS.CALM.COURAGE) then 
			CURR_STATE = ENDING.THREAT 
		end

		if (event == DRINKS.CALM.RATIONAL) then 
			CURR_STATE = ENDING.CONFORMED 
		end

		if (event == DRINKS.CALM.APATHY) then 
			CURR_STATE = ENDING.CONFORMED 
		end

    elseif (CURR_STATE == CLIENT.ASTRONAUT.BATTLE) then
		if (event == DRINKS.AGGRO.COURAGE) then 
			CURR_STATE = CLIENT.AI.BATTLE_AGGRO 
		end

		if (event == DRINKS.AGGRO.RATIONAL) then 
			CURR_STATE = CLIENT.AI.BATTLE_AGGRO 
		end

		if (event == DRINKS.AGGRO.APATHY) then 
			CURR_STATE = CLIENT.AI.BATTLE_AGGRO 
		end

		if (event == DRINKS.CALM.COURAGE) then 
			CURR_STATE = CLIENT.AI.BATTLE_CALM 
		end

		if (event == DRINKS.CALM.RATIONAL) then 
			CURR_STATE = CLIENT.AI.BATTLE_CALM 
		end

		if (event == DRINKS.CALM.APATHY) then 
			CURR_STATE = CLIENT.AI.BATTLE_CALM 
		end

    elseif (CURR_STATE == CLIENT.AI.BATTLE_AGGRO) then
		if (event == DRINKS.AGGRO.COURAGE) then 
			CURR_STATE = ENDING.BATTLE_AA 
		end

		if (event == DRINKS.AGGRO.RATIONAL) then 
			CURR_STATE = ENDING.BATTLE_AA
		end

		if (event == DRINKS.AGGRO.APATHY) then 
			CURR_STATE = ENDING.BATTLE_AA 
		end

		if (event == DRINKS.CALM.COURAGE) then 
			CURR_STATE = ENDING.BATTLE_AC 
		end

		if (event == DRINKS.CALM.RATIONAL) then 
			CURR_STATE = ENDING.BATTLE_AC 
		end

		if (event == DRINKS.CALM.APATHY) then 
			CURR_STATE = ENDING.BATTLE_AC 
		end

    elseif (CURR_STATE == CLIENT.AI.BATTLE_CALM) then
		if (event == DRINKS.AGGRO.COURAGE) then 
			CURR_STATE = ENDING.BATTLE_CA
		end

		if (event == DRINKS.AGGRO.RATIONAL) then 
			CURR_STATE = ENDING.BATTLE_CA 
		end

		if (event == DRINKS.AGGRO.APATHY) then 
			CURR_STATE = ENDING.BATTLE_CA 
		end

		if (event == DRINKS.CALM.COURAGE) then 
			CURR_STATE = ENDING.BATTLE_CC 
		end

		if (event == DRINKS.CALM.RATIONAL) then 
			CURR_STATE = ENDING.BATTLE_CC 
		end

		if (event == DRINKS.CALM.APATHY) then 
			CURR_STATE = ENDING.BATTLE_CC 
		end
    end
end

