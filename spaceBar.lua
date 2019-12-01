-- title:  game title
-- author: game developer
-- desc:   short description
-- script: lua

IS_MENU = true
HAS_FINISHED_WRITING = false
CURR_EVENT = null
IS_GOING_TO_DRINK = false

bartender = {
	anim_time = 0.8,
	anim_counter = 0,
	anim_frame = 0
}

shake=0
d=4

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

slide = {
	speed = 0.8,
	position = 0,
	value = 0,
	min_x = -300,
	x = -300,
	y = 0,
	max_x = 10
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
	IS_GOING_TO_DRINK = true
	TEXT_FEED = "Hey man, what's up?"--";Bartender: ---;I see... You seem like a good listener;Can I tell you something that's been on my mind?;Bartender: ---;Alright, great! So, here goes.;I was working today and I glimpsed at a passing ship;where I saw such a sweet lookin'  Alien… A real cutie!;Not gonna lie, I'm tempted to break protocol and relay a message;Tell her how I feel, you know?;It can get awful lonely up in space..."
	TEXT_FEED_OLD = TEXT_FEED
	TEXT_DELAY = 15
	CURR_SENTENCE = 1
end

function draw_counter()
	spr(34,10,100,0,2,0,0,8,2)
	spr(34,180,100,0,2,0,0,8,2)
	spr(34,70,100,0,2,0,0,8,2)
end

function init() 
	create_stars()	
	create_drinks()
	set_variables()
end

function change_character(character)
	CURR_CLIENT = character
	slide_character_in(character)
end

function slide_character_in(character) 
	slide.speed = math.abs(slide.speed)
	slide.x = slide.min_x
	slide.position = 0
	slide.value = 0
	if character == characters.ai then 
		slide.y = 90
		slide.max_x = 50
	else 
		slide.max_x = 10
	end
end

function slide_character_out() 
	slide.speed = -math.abs(slide.speed)
end

-- Draw clients.
function draw_ai()
	radius = 30
	
	for i = 1, 400 do
		pix(
		slide.x+math.cos(i)*radius+math.sin(ai_wave_counter/60+i)*5 + math.sin(ai_wave_counter/60+i),
		slide.y+math.sin(i)*radius+math.cos(ai_wave_counter/50+i) + math.cos(ai_wave_counter/60+i),7)
	end
	
	radius = 4*math.sin(ai_wave_counter/30)-2*math.sin(ai_wave_counter/30*5)
	radius = math.abs(radius) + 3
	
	circ(slide.x,slide.y,radius, 7)
	
	radius = 17
	
	for i = 1, 400 do
		pix(
		slide.x+math.cos(i)*radius+math.sin(ai_wave_counter/20+i*4),
		slide.y+math.sin(i)*radius+math.cos(ai_wave_counter/20+i*4),15)
	end
	
end

function draw_astronaut()
	spr(261,slide.x,10,0,2,0,0,7,9)
end

function draw_alien()
	spr(389,slide.x,10,0,2,0,0,7,9)
end

function draw_character(character)
	-- fα(x)=xαxα+(1−x)α
	if slide.speed < 0 and slide.position > 0 then 
		slide.position = slide.position + slide.speed / 60
	elseif slide.speed > 0 and slide.position < 1 then 
		slide.position = slide.position + slide.speed / 60
	end

	slide.value = math.pow(slide.position,2)/(math.pow(slide.position,2) + math.pow(1-slide.position, 2))
	 
	slide.x = slide.min_x + slide.value * (slide.max_x - slide.min_x)

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
	if btnp(0) then shake=30 end
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
			
			slide_character_in(CURR_CLIENT)
			
			CURR_EVENT = get_drink_state(selected_drink.base, selected_drink.reaction)
			-- Transition State
			HAS_FINISHED_WRITING = false
			update_state_machine(CURR_EVENT)
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
		HAS_FINISHED_WRITING = true
		
		if IS_GOING_TO_DRINK then
			IS_GOING_TO_DRINK = false
			selection_state.is_selecting = true
		end

		update_state_machine(CURR_EVENT)
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
	if shake>0 then
		poke(0x3FF9,math.random(-d,d))
		poke(0x3FF9+1,math.random(-d,d))
		shake=shake-1		
		if shake==0 then memset(0x3FF9,0,2) end
	end

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

	if selection_state.is_selecting then
		slide_character_out()
	end

	draw_character(CURR_CLIENT)

	draw_dialog(TEXT_FEED)
end

init()

function TIC()
	update()
	
	--if btnp(4) and selection_state.can_select then
	--	selection_state.is_selecting = true
    --end
    
    --if btnp(5) then
    --    selection_state.can_select  = true
    --end
	
	draw()	
end

-- State Machine

-- State Machine

function update_state_machine(event)

	if (CURR_STATE == CLIENT.ASTRONAUT.START) then
		if (event == DRINKS.AGGRO.COURAGE) then 
			change_character(characters.nothing)
			if not HAS_FINISHED_WRITING then
				TEXT_FEED = "The Astronaut musks up the courage, and contacts the Alien's ship;He asks if she would be interested in some stargazing and chill."
			end
			if HAS_FINISHED_WRITING then
				CURR_STATE = CLIENT.ALIEN.OFFENDED
				CURR_EVENT = TRANSITIONS.ONE_NIGHT_STAND
				HAS_FINISHED_WRITING = false
			end
		end

		if (event == DRINKS.AGGRO.RATIONAL or event == DRINKS.CALM.COURAGE) then
			change_character(characters.nothing)
			if not HAS_FINISHED_WRITING then
				TEXT_FEED = "The drink had quite the effect!;The lovestruck Astronaut decides to take his largest leap of faith;As soon as he gets on her ship the Astronaut gets on one knee; and proposes to the Alien, unable to wait any longer to spend;all of eternity by her side."
			end

			if HAS_FINISHED_WRITING then
				CURR_STATE = CLIENT.ALIEN.MARRIAGE
				HAS_FINISHED_WRITING = false
				CURR_EVENT = TRANSITIONS.MARRIAGE_PROPOSAL
			end			
		end

		if (event == DRINKS.AGGRO.APATHY or event == DRINKS.CALM.APATHY) then 
			CURR_STATE = ENDING.NOTHING 
			change_character(characters.nothing)
			TEXT_FEED = "The astronaut realized relationships are stupid.;And then literally nothing happened.;The end?"
		end

		if (event == DRINKS.CALM.RATIONAL) then 
			change_character(characters.nothing)
			if not HAS_FINISHED_WRITING then
				TEXT_FEED = "The astronaut books a table for two on the Intergalactic Bistro.;He invites the Alien to join him."
			end

			if HAS_FINISHED_WRITING then
				CURR_STATE = CLIENT.ALIEN.DINNER
				HAS_FINISHED_WRITING = false
				CURR_EVENT = TRANSITIONS.DINNER_PROPOSAL
			end
		end

	elseif (CURR_STATE == CLIENT.ALIEN.OFFENDED) then
		if (event == TRANSITIONS.ONE_NIGHT_STAND) then
			CURR_EVENT = 999
			change_character(characters.alien)
			TEXT_FEED = "Everything was quiet, until a new customer burst into the bar;, addressing the bartender before she even reached the counter.;'Just give me a drink! Anything really!;Maybe then I'll know how to respond to those preposterous messages!;The nerve of some humans these days!'"
			IS_GOING_TO_DRINK = true
		end

		--[[if (event == TRANSITIONS.DINNER_PROPOSAL) then
			CURR_STATE = CLIENT.ALIEN.DINNER 
			CURR_CLIENT = characters.alien
			TEXT_FEED = "'Oh, great, a human! You'll probably be able to answer me!;I'm going on a date with an Astronaut, and I'm a bit stumped...;What do you think I should wear?;The last thing I want is to make a fool of myself!';She sits in a bar stool.;'And serve me a drink, while you're at it;Consider it as a payment for the advice!''"
		end]]--
		
		if (event == DRINKS.AGGRO.COURAGE or event == DRINKS.AGGRO.RATIONAL) then 
			change_character(characters.nothing)
			if not HAS_FINISHED_WRITING then
				TEXT_FEED = "Who the hell does this pile of flesh and bones think he's talking to?;If he only new my lineage...;He would surely regret taking that stance with me;For the sake of his entire race."
			end
			if HAS_FINISHED_WRITING then
				CURR_STATE = CLIENT.AI.ADVICE
				CURR_EVENT = TRANSITIONS.ALIEN_NO
				HAS_FINISHED_WRITING = false
			end
		end

		if (event == DRINKS.AGGRO.APATHY or event == DRINKS.CALM.APATHY) then 
			change_character(characters.nothing)
			if not HAS_FINISHED_WRITING then
				TEXT_FEED = "'Ugh. His moves on me will never have an effect on me;Not with with this dim-witted approach.'"
			end
			if HAS_FINISHED_WRITING then
				CURR_STATE = CLIENT.AI.ADVICE
				CURR_EVENT = TRANSITIONS.ALIEN_IGNORES_ASS
				HAS_FINISHED_WRITING = false
			end
		
		end

		if (event == DRINKS.CALM.COURAGE or event == DRINKS.CALM.RATIONAL) then
			change_character(characters.nothing)
			if not HAS_FINISHED_WRITING then
				TEXT_FEED = "Well, never done it with an alien before... It should at least be different."
			end
			if HAS_FINISHED_WRITING then
				CURR_STATE = CLIENT.AI.SAD
				CURR_EVENT = TRANSITIONS.IMMA_DO_IT
				HAS_FINISHED_WRITING = false
			end
		end



    elseif (CURR_STATE == CLIENT.ALIEN.MARRIAGE) then
		if (event == DRINKS.AGGRO.COURAGE) then 
			CURR_STATE = ENDING.MARRIED 
		end

		if (event == TRANSITIONS.MARRIAGE_PROPOSAL) then
			CURR_EVENT = 999
			change_character(characters.alien)
			IS_GOING_TO_DRINK = true
			TEXT_FEED = "A new customer approaches, mumbling something to herself. ;She clearly looks frustrated.;'Greetings', she says, quietly, but politely.;Something was troubling her.;Fortunately for her...;The bartender is trained to understand the customer's deepest desire"
		end

		if (event == DRINKS.AGGRO.RATIONAL or event == DRINKS.AGGRO.APATHY or event == DRINKS.CALM.APATHY or event == DRINKS.CALM.RATIONAL) then
			change_character(characters.nothing)
			if not HAS_FINISHED_WRITING then
				TEXT_FEED = "The Alien slams the glass!;'Apparently, relationships between Astronaut and our kind have been banned since last Friday'.;The marriage doesn't go through."
			end
			if HAS_FINISHED_WRITING then
				CURR_STATE = CLIENT.AI.ADVICE
				CURR_EVENT = TRANSITIONS.FATHER_DISAPPROVAL
				HAS_FINISHED_WRITING = false
			end
		end

		if (event == DRINKS.CALM.COURAGE or event == DRINKS.AGGRO.COURAGE) then 
			CURR_STATE = ENDING.MARRIED
			change_character(characters.nothing)
			TEXT_FEED = "The alien and astronaut get married!;Can they even copulate? Does it matter? Who knows?!;Congrats to the married couple!" 
		end


	elseif (CURR_STATE == CLIENT.ALIEN.DINNER) then
		if (event == TRANSITIONS.DINNER_PROPOSAL) then
			CURR_EVENT = 999
			change_character(characters.alien)
			IS_GOING_TO_DRINK = true
			TEXT_FEED = "'Oh, great, a human! You'll probably be able to answer me!;I'm going on a date with an Astronaut, and I'm a bit stumped...;What do you think I should wear?;The last thing I want is to make a fool of myself!';She sits in a bar stool.;'And serve me a drink, while you're at it;Consider it as a payment for the advice!"
		end

		if (event == DRINKS.AGGRO.COURAGE) then
			change_character(characters.nothing)
			if not HAS_FINISHED_WRITING then
				TEXT_FEED = "The alien shows up naked!;The astronaut is visibly distraught albeit slightly aroused and leaves the place as fast as possible."
			end
			if HAS_FINISHED_WRITING then
				CURR_STATE = CLIENT.AI.ADVICE
				CURR_EVENT = TRANSITIONS.NAKED_ALIEN
				HAS_FINISHED_WRITING = false
			end
		end

		if (event == DRINKS.AGGRO.RATIONAL) then 
			CURR_STATE = ENDING.BARTENDER_QUITS
			change_character(characters.nothing)
			TEXT_FEED = "The alien shows up in revealing clothes.;The bartender stops cleaning his glass for once.;“Mmfamrmmfm”.;The alien doesn't understand a single word but is strangely attracted.;They exit the bar together."
		end

		if (event == DRINKS.AGGRO.APATHY or event == DRINKS.CALM.APATHY or event == DRINKS.CALM.RATIONAL or event == DRINKS.CALM.COURAGE) then
			change_character(characters.nothing)
			if not HAS_FINISHED_WRITING then
				TEXT_FEED = "The evening went well, but your next customer isn’t quite as happy."
			end
			if HAS_FINISHED_WRITING then
				CURR_STATE = CLIENT.AI.SAD
				CURR_EVENT = TRANSITIONS.NICE_DINNER
				HAS_FINISHED_WRITING = false
			end
		end

	elseif (CURR_STATE == CLIENT.AI.ADVICE) then
		if (event == TRANSITIONS.ALIEN_IGNORES_ASS or event == TRANSITIONS.ALIEN_NO or event == TRANSITIONS.FATHER_DISAPPROVAL or event == TRANSITIONS.NAKED_ALIEN) then
			CURR_EVENT = 999	
			change_character(characters.ai)
			IS_GOING_TO_DRINK = true
			TEXT_FEED = "A mysterious form of energy drifts into the bar.;To the surprise of the bartender, it talked.;'Greetings, human.;My data tells me that Alien has been here recently.;You have aided her in a problem;My sensors tell me your solution was rather satisfactory.;I have determined that you would be able to advise me; in a dilemma of my own.;I have traveled with said Alien for exactly...;3 years, 5 months, 2 days and 12 hours.; During this time, I have gained some interest in discovering;what love is and why it matters so much to her.;Would you have any solution?'"
		end

		if (event == DRINKS.AGGRO.COURAGE or event == DRINKS.AGGRO.RATIONAL) then 
			change_character(characters.nothing)
			if not HAS_FINISHED_WRITING then
				TEXT_FEED = "Yes, that would work.;$ sudo ./order_66.sh;Processing...;Extermination of all conflicting entities to be completed in the next 32 hours!"
			end
			if HAS_FINISHED_WRITING then
				CURR_STATE = ENDING.GENOCIDE
				HAS_FINISHED_WRITING = false
			end

		end

		if (event == DRINKS.AGGRO.APATHY or event == DRINKS.CALM.APATHY or event == DRINKS.CALM.RATIONAL) then 
			change_character(characters.nothing)
			if not HAS_FINISHED_WRITING then
				TEXT_FEED = "My biological parameters aren’t synchronized with the Alien's.;Any subsequent interactions would only cause more entropy in our ship.;Deleting romantic intent..."
			end
			if HAS_FINISHED_WRITING then
				CURR_STATE = ENDING.CONFORMED
				HAS_FINISHED_WRITING = false
			end
			
		end

		if (event == DRINKS.CALM.COURAGE) then
			change_character(characters.nothing)
			if not HAS_FINISHED_WRITING then
				TEXT_FEED = "Activating perceptrons...;Enabling LOVE v1.0.1.;<3"
			end
			if HAS_FINISHED_WRITING then
				CURR_STATE = ENDING.LGBTQ
				HAS_FINISHED_WRITING = false
			end
		end

	elseif (CURR_STATE == CLIENT.AI.SAD) then
		if (event == TRANSITIONS.IMMA_DO_IT or event == TRANSITIONS.NICE_DINNER) then
			CURR_EVENT = 999
			change_character(characters.ai) 
			IS_GOING_TO_DRINK = true
			TEXT_FEED = "A mysterious form of energy drifts into the bar.;To the surprise of the bartender, it talked.;'Greetings, human.;My data tells me that you are the best decision-maker in the galaxy.;You will certainly be able to give me the best path;that would solve my dilemma.;Alien has been frequently engaging with an Astronaut.;I'm worried that it will affect her performance.;Or even worse, that she would deem me less useful.;What should be my course of action?"
		end
		
		if (event == DRINKS.AGGRO.COURAGE) then 
			CURR_STATE = CLIENT.ASTRONAUT.BATTLE 
		end		

		if (event == DRINKS.AGGRO.RATIONAL) then 
			change_character(characters.nothing)
			if not HAS_FINISHED_WRITING then
				TEXT_FEED = "Accessing Astronaut’s ship...;Searching for non-fatal exploitable faults...;Commencing fuel disposal...;Disabling all communications...;Tasks completed successfully!"
			end
			if HAS_FINISHED_WRITING then
				CURR_STATE = ENDING.SABOTAGE
				HAS_FINISHED_WRITING = false
			end  
		end

		if (event == DRINKS.CALM.COURAGE) then 
			change_character(characters.nothing)
			if not HAS_FINISHED_WRITING then
				TEXT_FEED = "Searching database for subjects...;NAME: Astronaut McAustronautFace;CURRENT_RESIDENCE: International Space Station, nº1134;MESSAGE_BODY: Found 23 exploitable faults: gas leakage in Engineering and 22 more...;Please consider your options, {subject.name}.;Message sent successfully!"
			end
			if HAS_FINISHED_WRITING then
				CURR_STATE = ENDING.THREAT
				HAS_FINISHED_WRITING = false
			end 
		end

		if (event == DRINKS.CALM.RATIONAL or event == DRINKS.AGGRO.APATHY or event == DRINKS.CALM.APATHY) then 
			change_character(characters.nothing)
			if not HAS_FINISHED_WRITING then
				TEXT_FEED = "Searching database for subjects...;NAME: Astronaut McAustronautFace;CURRENT_RESIDENCE: International Space Station, nº1134;MESSAGE_BODY: Found 23 exploitable faults: gas leakage in Engineering and 22 more...;Please consider your options, {subject.name}.;Message sent successfully!"
			end
			if HAS_FINISHED_WRITING then
				CURR_STATE = ENDING.CONFORMED
				HAS_FINISHED_WRITING = false
			end
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
	elseif (CURR_STATE == ENDING.LGBTQ) then
		CURR_EVENT = 999
		change_character(characters.nothing)
		CURR_STATE = DEFAULT
		TEXT_FEED= "The Alien returns to the ship.;The AI has set the mood accordingly:;Red lights, soft music and aphrodisiacs native to the Alien's home planet.;The AI generates a dinner proposition, to which the Alien gracefully and the Alien accepts.;The vessel that propelled them forward was no longer a spaceship;It's a relationship."

	elseif (CURR_STATE == ENDING.CONFORMED) then
		CURR_EVENT = 999
		change_character(characters.nothing)
		CURR_STATE = DEFAULT
		TEXT_FEED= "The AI factory resets to its defaults; It was aware that if this scenario were to happen again in the future; another good willed agent will prevent it.;'There are plenty of bartenders around', she thought."
	elseif (CURR_STATE == ENDING.GENOCIDE) then
		CURR_EVENT = 999
		change_character(characters.nothing)
		CURR_STATE = DEFAULT
		TEXT_FEED= "The AI realizes that the surest way to become the best possible mate...;is to become the only one.;In that scenario, the only scenarios would be forever with her, or a lifetime of solitude;'Surely that can’t be a viable option', thought the AI.;However, her calculations were incorrect.;Upon uncovering the truth behind mass exterminations in the Milky Way; the Alien abandons her ship, and hopes to find solace in the only place she knew:;the SpaceBar;What she didn't expect though...;would be to find it drifting through space, aimlessly, with no one aboard..."
	elseif (CURR_STATE == ENDING.THREAT) then
		CURR_EVENT = 999
		change_character(characters.nothing)
		CURR_STATE = DEFAULT
		TEXT_FEED= "The Astronaut was quite distressed with the message received;and made sure to take heed to the AI's warning.;The Alien however, now intrigued with the human, attempted to contact him several times;The Astronaut never responded, fearing what would become of him.;Although the AI never deepened the relationship with her female crew member; she is still content with the outcome she designed."
	elseif (CURR_STATE == ENDING.ALIEN_ASTRONAUT) then
		CURR_EVENT = 999
		change_character(characters.nothing)
		CURR_STATE = DEFAULT
		TEXT_FEED= "The AI factory resets to its defaults; It was aware that if this scenario were to happen again in the future; another good willed agent will prevent it.;'There are plenty of bartenders around', she thought.;The Alien however, remains smitten with her new human counterpart;and their relationship flounders for many years on..."
	elseif (CURR_STATE == ENDING.SABOTAGE) then
		CURR_EVENT = 999
		change_character(characters.nothing)
		CURR_STATE = DEFAULT
		TEXT_FEED= "The Astronaut didn’t take much time to realize that he had been sabotaged.;He did not understand why nor how this had happened;but he surely tried the best he could to restore everything.;However, the damage was too severe for him alone to fix.;The Alien attempted to contact the ship several times, but to no avail; since the messages were being intercepted by the ship’s AI core.;She ultimately left, leaving the stranded astronaut drifting heartbroken through space."
	end
end

