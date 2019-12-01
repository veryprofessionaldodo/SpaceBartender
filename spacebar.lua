-- title:  game title
-- author: game developer
-- desc:   short description
-- script: lua

IS_MENU = true

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
	astronaut="astronaut",
	nothing="nothing"
}

-- Creates drinks and pushes them to the drinks array.
function create_drinks()
	calm = {
		name = "Milky Way",
		type = drink_types.calm,
		color = 6,
		x = 28,
		y = 20,
		offset_y = 0,
		sprite = 2,
		dir = 1,
		anim_time = 30 + math.random(50),
		anim_counter = math.random(20),
		description = 'Natural nerve soother'
	}

	aggro = {
		name = "Molten Rage",
		type = drink_types.aggro,
		color = 7,
		x = 66,
		y = 20,
		offset_y = 0,
		sprite = 0,
		dir = 1,
		anim_time = 30 + math.random(50),
		anim_counter = math.random(20),
		description = 'Brewed by Lucifer himself'
	}  
	
	courage = {
		name = "Taurus",
		type = drink_types.courage,
		color = 9,
		x = 10,
		y = 56,
		offset_y = 0,
		sprite = 6,
		dir = 1,
		anim_time = 30 + math.random(50),
		anim_counter = math.random(20),
		description = 'Liquid courage'
	}
	
	apathy = {
		name = "Anesthesia",
	 	type = drink_types.apathy,
		color = 10,
		x = 47,
		y = 56,
		sprite = 4,
		dir = 1,
		offset_y = 0,
		anim_time = 30 + math.random(50),
		anim_counter = math.random(20),
		description = '...'
	}
	
	rational = {
		name = "Cerberus",
		type = drink_types.rational,
		color = 12,
		x = 85,
		y = 56,
		sprite = 8,
		offset_y = 0,
		anim_time = 30 + math.random(50),
		anim_counter = math.random(20),
		dir = 1,
		description = 'Brain juice'
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

function draw_drink_label(index)
	print(string.upper(drinks[index].name), 0, 0, drinks[index].color)
	print(drinks[index].description, 3, 5)
end

function draw_drinks()
    for i = 1, #drinks do 
        spr(drinks[i].sprite, drinks[i].x, drinks[i].y+drinks[i].offset_y,0,2,0,0,2,2)
        if selection_state.is_selecting then 
            if selection_state.curr_selection == i then 
				spr(64,drinks[i].x,drinks[i].y,0,2,0,0,2,2)
				draw_drink_label(i)	
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
	anim_id = 256 + 112 * bartender.anim_frame
	spr(anim_id, 120, 10, 0, 2, 0, 0, 5, 7)
end

function draw_specific_bartender(pos_x, pos_y)
	anim_id = 256 + 112 * bartender.anim_frame
	spr(anim_id, pos_x, pos_y, 0, 2, 0, 0, 5, 7)
end

function set_variables()
	ai_wave_counter = 0
	t = 0

	dialog_t = 0
	dialog_index = 0

	DIALOG_SPEED = 4
	DIALOG_LIMIT = 35

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
	
	TRANSITIONS = {
		ONE_NIGHT_STAND = 30, MARRIAGE_PROPOSAL = 31, DINNER_PROPOSAL = 32, IMMA_DO_IT = 33, ALIEN_IGNORES_ASS = 34, ALIEN_NO = 35,
		FATHER_DISAPPROVAL = 36, NAKED_ALIEN = 37, NICE_DINNER = 38, AI_DINNER_PROPOSAL = 39, AI_CONFORMANCE = 40, AI_GENOCIDE = 41,
		AI_THREATENS_ASS = 42, AI_CONFORMANCE_RELATIONSHIP = 43, AI_SABOTAGE = 44, BATTLE_TO_THE_DEATH = 45  
	}

	CURR_CLIENT = characters.astronaut
	CURR_STATE = CLIENT.ASTRONAUT.START
	TEXT_FEED = "Hey man, what's up?"--";Bartender: ---;I see... You seem like a good listener;Can I tell you something that's been on my mind?;Bartender: ---;Alright, great! So, here goes.;I was working today and I glimpsed at a passing ship;where I saw such a sweet lookin'  Alien… A real cutie!;Not gonna lie, I'm tempted to break protocol and relay a message;Tell her how I feel, you know?;It can get awful lonely up in space..."
	TEXT_FEED_OLD = TEXT_FEED
	TEXT_DELAY = 15
	CURR_SENTENCE = 1
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
	if character == characters.nothing then end
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

function draw_dialog(text)
	local dummy = 0
	for sentence in string.gmatch(text, "[^;]+") do
		dummy = dummy + 1
		if (dummy == CURR_SENTENCE) then draw_sentence(sentence) end
	end

	if (CURR_SENTENCE == dummy + 1) then 
		CURR_SENTENCE = 1 
		TEXT_FEED = ""
	end
end

function draw_sentence(text) 
	dialog_t = dialog_t + 1
	local x_pos = 120 - (DIALOG_LIMIT / 2) * 6
	local y_pos = 120

    if (dialog_t % DIALOG_SPEED == 0) then
        dialog_index = dialog_index + 1
	end

	if (dialog_index == #text + TEXT_DELAY) then
		CURR_SENTENCE = CURR_SENTENCE + 1
		dialog_index = 0
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
	if (IS_MENU) then 
		if btnp(4) or btnp(5) or btnp(6) or btnp(7) then 
			IS_MENU = false 
		end 
	end

	update_background()
	update_bartender()
	
	if selection_state.is_selecting then
		handle_input()
	end
	
	ai_wave_counter = ai_wave_counter + 1 
end

function draw_menu()
	draw_stars()
	print('SPACEBAR', 30, 30, 7, false, 4, false)
	print('Also try Terraria!', 30, 52, 15, false, 1, true)
	draw_specific_bartender(150, 46)
	print('Press any key to start...', 30, 130, 7, false, 1, true)
end

function draw()
	cls()
	
	if (IS_MENU) then
		draw_menu()
		return
	end

	draw_background()
	draw_bartender()
	draw_counter()

	if not selection_state.is_selecting then
		draw_character(CURR_CLIENT)
	end

	draw_dialog(TEXT_FEED)
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
			CURR_STATE = ONE_NIGHT_STAND
		end

		if (event == DRINKS.AGGRO.RATIONAL) then 
			CURR_STATE = CLIENT.ALIEN.MARRIAGE
			CURR_CLIENT = characters.alien
			TEXT_FEED = "A new customer approaches, mumbling something to herself. ;She clearly looks frustrated.;'Greetings', she says, quietly, but politely.;Something was troubling her.;Fortunately for her...;The bartender is trained to understand the customer's deepest desire"
		end

		if (event == DRINKS.AGGRO.APATHY) then 
			CURR_STATE = ENDING.NOTHING 
			CURR_CLIENT = characters.nothing
			TEXT_FEED = "The astronaut realized relationships are stupid.;And then literally nothing happened.;The end?"
		end

		if (event == DRINKS.CALM.COURAGE) then 
			CURR_STATE = CLIENT.ALIEN.MARRIAGE 
			CURR_CLIENT = characters.alien
			TEXT_FEED = "The astronaut realized relationships are stupid.;And then literally nothing happened.;The end?"
		end

		if (event == DRINKS.CALM.RATIONAL) then 
			CURR_STATE = CLIENT.ALIEN.DINNER 
			CURR_CLIENT = characters.alien
			TEXT_FEED = "'Oh, great, a human! You'll probably be able to answer me!;I'm going on a date with an Astronaut, and I'm a bit stumped...;What do you think I should wear?;The last thing I want is to make a fool of myself!';She sits in a bar stool.;'And serve me a drink, while you're at it;Consider it as a payment for the advice!''"
		end

		if (event == DRINKS.CALM.APATHY) then 
			CURR_STATE = ENDING.NOTHING 
			CURR_CLIENT = characters.nothing
			TEXT_FEED = "The astronaut realized relationships are stupid.;And then literally nothing happened.;The end?"
		end

	elseif (CURR_STATE == CLIENT.ALIEN.OFFENDED) then
		if (event == DRINKS.AGGRO.COURAGE) then 
			CURR_STATE = CLIENT.AI.ADVICE 
			CURR_CLIENT = characters.ai
			TEXT_FEED = "A mysterious form of energy drifts into the bar.;To the surprise of the bartender, it talked.;'Greetings, human.;My data tells me that Alien has been here recently.;You have aided her in a problem;My sensors tell me your solution was rather satisfactory.;I have determined that you would be able to advise me; in a dilemma of my own.;I have traveled with said Alien for exactly...;3 years, 5 months, 2 days and 12 hours.; During this time, I have gained some interest in discovering;what love is and why it matters so much to her.;Would you have any solution?'"
		end

		if (event == DRINKS.AGGRO.RATIONAL) then 
			CURR_STATE = CLIENT.AI.ADVICE
			CURR_CLIENT = characters.ai
			TEXT_FEED = "A mysterious form of energy drifts into the bar.;To the surprise of the bartender, it talked.;'Greetings, human.;My data tells me that Alien has been here recently.;You have aided her in a problem;My sensors tell me your solution was rather satisfactory.;I have determined that you would be able to advise me; in a dilemma of my own.;I have traveled with said Alien for exactly...;3 years, 5 months, 2 days and 12 hours.; During this time, I have gained some interest in discovering;what love is and why it matters so much to her.;Would you have any solution?'"
		end

		if (event == DRINKS.AGGRO.APATHY) then 
			CURR_STATE = CLIENT.AI.ADVICE
			CURR_CLIENT = characters.ai
			TEXT_FEED = "A mysterious form of energy drifts into the bar.;To the surprise of the bartender, it talked.;'Greetings, human.;My data tells me that Alien has been here recently.;You have aided her in a problem;My sensors tell me your solution was rather satisfactory.;I have determined that you would be able to advise me; in a dilemma of my own.;I have traveled with said Alien for exactly...;3 years, 5 months, 2 days and 12 hours.; During this time, I have gained some interest in discovering;what love is and why it matters so much to her.;Would you have any solution?'"
		end

		if (event == DRINKS.CALM.COURAGE) then
			CURR_STATE = CLIENT.AI.SAD
			CURR_CLIENT = characters.ai 
			TEXT_FEED = "A mysterious form of energy drifts into the bar.;To the surprise of the bartender, it talked.;'Greetings, human.;My data tells me that you are the best decision-maker in the galaxy.;You will certainly be able to give me the best path;that would solve my dilemma.;Alien has been frequently engaging with an Astronaut.;I'm worried that it will affect her performance.;Or even worse, that she would deem me less useful.;What should be my course of action?"
		end

		if (event == DRINKS.CALM.RATIONAL) then 
			CURR_STATE = CLIENT.AI.SAD
			CURR_CLIENT = characters.ai
			TEXT_FEED = "A mysterious form of energy drifts into the bar.;To the surprise of the bartender, it talked.;'Greetings, human.;My data tells me that you are the best decision-maker in the galaxy.;You will certainly be able to give me the best path;that would solve my dilemma.;Alien has been frequently engaging with an Astronaut.;I'm worried that it will affect her performance.;Or even worse, that she would deem me less useful.;What should be my course of action?"
		end

		if (event == DRINKS.CALM.APATHY) then 
			CURR_STATE = CLIENT.AI.ADVICE
			CURR_CLIENT = characters.ai
			TEXT_FEED = "A mysterious form of energy drifts into the bar.;To the surprise of the bartender, it talked.;'Greetings, human.;My data tells me that Alien has been here recently.;You have aided her in a problem;My sensors tell me your solution was rather satisfactory.;I have determined that you would be able to advise me; in a dilemma of my own.;I have traveled with said Alien for exactly...;3 years, 5 months, 2 days and 12 hours.; During this time, I have gained some interest in discovering;what love is and why it matters so much to her.;Would you have any solution?'"
		end

    elseif (CURR_STATE == CLIENT.ALIEN.MARRIAGE) then
		if (event == DRINKS.AGGRO.COURAGE) then 
			CURR_STATE = ENDING.MARRIED 
		end

		if (event == DRINKS.AGGRO.RATIONAL) then 
			CURR_STATE = CLIENT.AI.ADVICE
			CURR_CLIENT = characters.ai
			TEXT_FEED = "A mysterious form of energy drifts into the bar.;To the surprise of the bartender, it talked.;'Greetings, human.;My data tells me that Alien has been here recently.;You have aided her in a problem;My sensors tell me your solution was rather satisfactory.;I have determined that you would be able to advise me; in a dilemma of my own.;I have traveled with said Alien for exactly...;3 years, 5 months, 2 days and 12 hours.; During this time, I have gained some interest in discovering;what love is and why it matters so much to her.;Would you have any solution?'"
		end

		if (event == DRINKS.AGGRO.APATHY) then 
			CURR_STATE = CLIENT.AI.ADVICE
			CURR_CLIENT = characters.ai 
			TEXT_FEED = "A mysterious form of energy drifts into the bar.;To the surprise of the bartender, it talked.;'Greetings, human.;My data tells me that Alien has been here recently.;You have aided her in a problem;My sensors tell me your solution was rather satisfactory.;I have determined that you would be able to advise me; in a dilemma of my own.;I have traveled with said Alien for exactly...;3 years, 5 months, 2 days and 12 hours.; During this time, I have gained some interest in discovering;what love is and why it matters so much to her.;Would you have any solution?'"
		end

		if (event == DRINKS.CALM.COURAGE) then 
			CURR_STATE = ENDING.MARRIED 
		end
		
		if (event == DRINKS.CALM.RATIONAL) then 
			CURR_STATE = CLIENT.AI.ADVICE 
			CURR_CLIENT = characters.ai
			TEXT_FEED = "A mysterious form of energy drifts into the bar.;To the surprise of the bartender, it talked.;'Greetings, human.;My data tells me that Alien has been here recently.;You have aided her in a problem;My sensors tell me your solution was rather satisfactory.;I have determined that you would be able to advise me; in a dilemma of my own.;I have traveled with said Alien for exactly...;3 years, 5 months, 2 days and 12 hours.; During this time, I have gained some interest in discovering;what love is and why it matters so much to her.;Would you have any solution?'"
		end

		if (event == DRINKS.CALM.APATHY) then 
			CURR_STATE = CLIENT.AI.ADVICE
			CURR_CLIENT = characters.ai
			TEXT_FEED = "A mysterious form of energy drifts into the bar.;To the surprise of the bartender, it talked.;'Greetings, human.;My data tells me that Alien has been here recently.;You have aided her in a problem;My sensors tell me your solution was rather satisfactory.;I have determined that you would be able to advise me; in a dilemma of my own.;I have traveled with said Alien for exactly...;3 years, 5 months, 2 days and 12 hours.; During this time, I have gained some interest in discovering;what love is and why it matters so much to her.;Would you have any solution?'"
		end

    elseif (CURR_STATE == CLIENT.ALIEN.DINNER) then
		if (event == DRINKS.AGGRO.COURAGE) then 
			CURR_STATE = CLIENT.AI.ADVICE 
			CURR_CLIENT = characters.ai
			TEXT_FEED = "A mysterious form of energy drifts into the bar.;To the surprise of the bartender, it talked.;'Greetings, human.;My data tells me that Alien has been here recently.;You have aided her in a problem;My sensors tell me your solution was rather satisfactory.;I have determined that you would be able to advise me; in a dilemma of my own.;I have traveled with said Alien for exactly...;3 years, 5 months, 2 days and 12 hours.; During this time, I have gained some interest in discovering;what love is and why it matters so much to her.;Would you have any solution?'"
		end

		if (event == DRINKS.AGGRO.RATIONAL) then 
			CURR_STATE = ENDING.BARTENDER_QUITS 
			TEXT_FEED = "The alien shows up in revealing clothes. The bartender stops cleaning his glass for once. “Mmfamrmmfm”. The alien doesn’t understand a single word but is strangely attracted.They exit the bar together."
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
	elseif (CURR_STATE == ONE_NIGHT_STAND) then
		characters = characters.nothing
		TEXT_FEED = "test test test tsest test setst ets test"
		CURR_STATE = CLIENT.ALIEN.OFFENDED
	end
	elseif (CURR_STATE == MARRIAGE_PROPOSAL) then
	end
	elseif (CURR_STATE == DINNER_PROPOSAL) then
	end
	elseif (CURR_STATE == IMMA_DO_IT) then
	end
	elseif (CURR_STATE == ALIEN_IGNORES_ASS) then
	end
	elseif (CURR_STATE == ALIEN_NO) then
	end
	elseif (CURR_STATE == FATHER_DISAPPROVAL) then
	end
	elseif (CURR_STATE == NAKED_ALIEN) then
	end
	elseif (CURR_STATE == NICE_DINNER) then
	end
	elseif (CURR_STATE == AI_DINNER_PROPOSAL) then
	end
	elseif (CURR_STATE == AI_CONFORMANCE) then
	end
	elseif (CURR_STATE == AI_GENOCIDE) then
	end
	elseif (CURR_STATE == AI_THREATENS_ASS) then
	end
	elseif (CURR_STATE == AI_CONFORMANCE_RELATIONSHIP) then
	end
	elseif (CURR_STATE == AI_SABOTAGE) then
	end
	elseif (CURR_STATE == BATTLE_TO_THE_DEATH) then
	end
end

