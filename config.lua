Config = {}

Config.HearDistance = 50.0
Config.MaxVolume =  3 / 4


Config.MarketDraw = 30.0
Config.MarketType = 10
Config.HelpPrompt = "Appuyer sur ~INPUT_PICKUP~ pour prendre votre place de dj"
Config.Marker = { w= 1.0, h= 1.0,l = 1.0 ,r = 204, g = 204, b = 0 , Rotate = true }


Config.jobCanPlaye                = {'bahama','goverment','casino' }
Config.openDJMenuButton           = 38 -- E
Config.openDJMenuCommend          = 'dj'

Config.Vehicles = {
	models = {
		{label = 'festival bus', model = 'pbus2' , price = 10},
	},
	Spawner = {x = 934.23254394531, y = 68.195655822754, z = 79.193206787109},
	InsideShop = {x = 955.45153808594, y = 155.03648376465, z = 80.830619812012},
	Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 255, g = 0, b = 0, rotate = true },
	SpawnPoints = {
		{ coords = { x = 930.67114257813, y = 82.665519714355, z = 73.825233459473 }, heading = 16.22, radius = 4.0 },
	}
}

Config.nightclubs = {
	-- nightclubBahamas = {
		-- dancefloor = {
			-- Pos = {x = -1387.0628662109, y=  -618.31188964844, z = 30.81955909729},
			-- Marker = { w= 25.0, h= 1.0,r = 204, g = 204, b = 0},
			-- HelpPrompt = "Appuyer sur ~INPUT_PICKUP~ pour afficher le menu de danse",
		-- },
		-- djbooth = {
			-- Pos = {x = -1384.628662109, y=  -627.31188964844, z = 30.81955909729}, 
			-- Marker = { w= 1.0, h= 0.5,r = 204, g = 204, b = 0},
			-- HelpPrompt = "Appuyer sur ~INPUT_PICKUP~ pour prendre votre place de dj",
		-- },
	-- },	
	-- nightclubUnicorn = {
		-- dancefloor = {
			-- Pos = {x = 110.13, y=  -1288.70, z = 28.85},
			-- Marker = { w= 25.0, h= 1.0,r = 204, g = 204, b = 0},
			-- HelpPrompt = "Appuyer sur ~INPUT_PICKUP~ pour afficher le menu de danse",
		-- }, 
		-- djbooth = {
			-- Pos = {x = 118.6188, y=  -1288.85, z = 28.81955909729}, 
			-- Marker = { w= 1.0, h= 0.5,r = 204, g = 204, b = 0},
			-- HelpPrompt = "Appuyer sur ~INPUT_PICKUP~ pour prendre votre place de dj",
		-- },
	-- },	
	nightclubunderground = {
		dancefloor = {
			x = -1592.275, y=  -3012.131, z = -78.00 , HearDistance = 20.0
		}, 
		djbooth = {
			x = -1603.98, y=  -3012.802, z = -77.79
		},
	},
}

Config.Songs = {

	{song = "http://dl1.samfuni.com/download.php?file=2020/00036/Barobax_Soosan_Khanoom%5B128%5D.mp3", label ="soosan khanoom"},

	
}