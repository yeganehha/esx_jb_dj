local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

--DO-NOT-EDIT-BELLOW-THIS-LINE--
-- Init ESX
ESX = nil
local PlayerData                = {}
local Vehicles                  = {}
local VehiclesPlate             = {}
local HasAlreadyEnteredMarker,LastZone = false,nil
local spawnedVehicles, isInShopMenu = {}, false


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while true do
		-- removes audio from vanilla unicorn
		SetStaticEmitterEnabled('LOS_SANTOS_VANILLA_UNICORN_01_STAGE', false)
		SetStaticEmitterEnabled('LOS_SANTOS_VANILLA_UNICORN_02_MAIN_ROOM', false)
		SetStaticEmitterEnabled('LOS_SANTOS_VANILLA_UNICORN_03_BACK_ROOM', false)
		Citizen.Wait(0)
	end
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

-- Fin init ESX

function exitmarkerdjbooth()
	ESX.UI.Menu.CloseAll()
end



function inarray( array , value )
	for k,v in ipairs(array) do
		if ( v == value ) then
			return k
		end
	end
	return nil
end

-- Enter / Exit marker events, and draw markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		local letSleep = true
		for k,v in pairs(Config.nightclubs) do
			if ( v ~= nil ) then
				local distance = GetDistanceBetweenCoords(coords, v.dancefloor.x, v.dancefloor.y, v.dancefloor.z, true)
				if distance < v.dancefloor.HearDistance then
					letSleep = false
					hearSound(k,v)
				else
					SendNUIMessage({setvolume = 0.0, dancefloor = k})
				end
			end
		end
		if letSleep then
			Citizen.Wait(1000)
		else
			Citizen.Wait(500)
		end
	end
end)
-- Enter / Exit marker events, and draw markers
Citizen.CreateThread(function()
	local letSleep = true
	while true do
		Citizen.Wait(0)
		if PlayerData.job and ( inarray(Config.jobCanPlaye , PlayerData.job.name ) ~= nil )  then
			letSleep = true
			local coords = GetEntityCoords(PlayerPedId())
			for k,v in pairs(Config.nightclubs) do
				if ( v ~= nil ) then
					local distance = GetDistanceBetweenCoords(coords, v.djbooth.x, v.djbooth.y, v.djbooth.z, true)
					if distance < Config.MarketDraw then
						letSleep = false
--						DrawMarker(Config.MarketType, v.djbooth.x, v.djbooth.y, v.djbooth.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.w, Config.Marker.l, Config.Marker.h, Config.Marker.r, Config.Marker.g, Config.Marker.b, 100, false, false, 2, Config.Marker.Rotate, nil, nil, false)
						if distance <= 4.0 and not HasAlreadyEnteredMarker and LastZone ~= k and not IsPedInAnyVehicle(PlayerPedId(), true) then
							ESX.ShowHelpNotification(Config.HelpPrompt)
							HasAlreadyEnteredMarker = true
							LastZone = k
						elseif distance > 4.0 and HasAlreadyEnteredMarker and LastZone == k then
							HasAlreadyEnteredMarker = false
							LastZone = nil
							exitmarkerdjbooth()
						end
					end
				end
			end
			local distance = GetDistanceBetweenCoords(coords, Config.Vehicles.Spawner.x, Config.Vehicles.Spawner.y, Config.Vehicles.Spawner.z, true)
			if distance < Config.MarketDraw then
				letSleep = false
				DrawMarker(Config.Vehicles.Marker.type, Config.Vehicles.Spawner.x, Config.Vehicles.Spawner.y, Config.Vehicles.Spawner.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Vehicles.Marker.x, Config.Vehicles.Marker.y, Config.Vehicles.Marker.z, Config.Vehicles.Marker.r, Config.Vehicles.Marker.g, Config.Vehicles.Marker.b, 100, false, false, 2, Config.Vehicles.Marker.rotate, nil, nil, false)
				if distance <= 4.0 then
					ESX.ShowHelpNotification(Config.HelpPrompt)
					if IsControlJustReleased(0, Config.openDJMenuButton ) then
						OpenVehicleSpawnerMenu()
					end
				elseif distance > 4.0 then
--					exitmarkerdjbooth()
				end
			end
		end
		if letSleep then
			Citizen.Wait(500)
		else
			Citizen.Wait(0)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local letSleep = true
		if #Vehicles > 0  then
			letSleep = false
			for k,v in pairs (Vehicles) do
				if DoesEntityExist(v) then
					local prop = ESX.Game.GetVehicleProperties(v)
					local coords = GetEntityCoords(v)
					Config.nightclubs[prop.plate] = {
						dancefloor = {
							x = coords.x, y=  coords.y , z = coords.z , HearDistance = Config.HearDistance
						},
						djbooth = {
							x = coords.x, y= ( coords.y  ) , z = ( coords.z + 2 )
						}
					}
					TriggerServerEvent('esx_erfan_jb_dj:spawnVehicle', Config.nightclubs)
				else
					table.remove(Vehicles,k)
					TriggerEvent('esx_erfan_jb_dj:setmusicforeveryone', "stop", "", VehiclesPlate[k])
					Config.nightclubs[ VehiclesPlate[k] ] = nil
					table.remove(VehiclesPlate,k)
					TriggerServerEvent('esx_erfan_jb_dj:spawnVehicle', Config.nightclubs)
				end
			end
		end
		if letSleep then
			Citizen.Wait(500)
		else
			Citizen.Wait(200)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustReleased(0, Config.openDJMenuButton ) and HasAlreadyEnteredMarker then
			OpenDjMenu(LastZone)
		end
	end
end)

function hearSound(k,v)
	local ped = GetPlayerPed(-1)
	local coords      = GetEntityCoords(ped)
	local distance = GetDistanceBetweenCoords(coords, v.dancefloor.x, v.dancefloor.y, v.dancefloor.z, true)
	local number =distance/v.dancefloor.HearDistance
	local volume = round(( (1-number) * Config.MaxVolume ), 2)
	SendNUIMessage({setvolume = volume, dancefloor = k})
end


function OpenDjMenu(dancefloor)
	local elements = {}
	table.insert(elements, {label = 'Play', value = 'play_music'})
	table.insert(elements, {label = 'Pause', value = 'pause_music'})
	table.insert(elements, {label = 'Stop', value = 'stop_music'})
	table.insert(elements, {label = 'enter url', value = 'enter_url_music'})
--	table.insert(elements, {label = 'upload music', value = 'upload_music'})
	for k,v in pairs (Config.Songs) do
		table.insert(elements, {label = v.label, value = v.song})
	end
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'menuperso_gpsrapide',
		{
			title    = 'Playlist - ' .. dancefloor ,
			align    = 'top-left',
			elements = elements,
		},
		function(data2, menu2)
			if data2.current.value == "pause_music" then
				TriggerServerEvent('esx_erfan_jb_dj:setcommand', "pause", "", dancefloor)
			elseif data2.current.value == "play_music" then
				TriggerServerEvent('esx_erfan_jb_dj:setcommand', "play", "", dancefloor)
			elseif data2.current.value == "stop_music" then
				TriggerServerEvent('esx_erfan_jb_dj:setcommand', "stop", "", dancefloor)
			elseif data2.current.value == "enter_url_music" then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'url_music', {
					title = 'enter url'
				}, function(data3, menu3)
					if data3.value == nil or data3.value == '' then
						ESX.ShowNotification('please enter url')
					else
						TriggerServerEvent('esx_erfan_jb_dj:setcommand', "playsong", data3.value, dancefloor)
					end
				end, function(data, menu)
					menu.close()
				end)
			elseif data2.current.value == "upload_music" then
				SendNUIMessage({musiccommand = "upload_music"})
			else
				TriggerServerEvent('esx_erfan_jb_dj:setcommand', "playsong", data2.current.value, dancefloor)
			end
		end,
		function(data2, menu2)
			menu2.close()
		end
	)
end

RegisterNetEvent('esx_erfan_jb_dj:setmusicforeveryone')
AddEventHandler('esx_erfan_jb_dj:setmusicforeveryone', function(command, songname, dancefloor)
	-- print(dancefloor)
	SendNUIMessage({musiccommand = command, songname = songname, dancefloor = dancefloor})
end)

RegisterNetEvent('esx_erfan_jb_dj:spawnVehicle')
AddEventHandler('esx_erfan_jb_dj:spawnVehicle', function(vehicle)
	Config.nightclubs = vehicle
end)

function round(num, dec)
  local mult = 10^(dec or 0)
  return math.floor(num * mult + 0.5) / mult
end

function dump(o, nb)
  if nb == nil then
    nb = 0
  end
   if type(o) == 'table' then
      local s = ''
      for i = 1, nb + 1, 1 do
        s = s .. "    "
      end
      s = '{\n'
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
          for i = 1, nb, 1 do
            s = s .. "    "
          end
         s = s .. '['..k..'] = ' .. dump(v, nb + 1) .. ',\n'
      end
      for i = 1, nb, 1 do
        s = s .. "    "
      end
      return s .. '}'
   else
      return tostring(o)
   end
end








function OpenVehicleSpawnerMenu()
	local playerCoords = GetEntityCoords(PlayerPedId())
	local elements = {
		{label = 'Get Vehicle', action = 'garage'},
		{label = 'Store Vehicle', action = 'store_garage'},
		{label = 'Buy Vehicle', action = 'buy_vehicle'}
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle', {
		title    = 'vehicles menu',
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		if data.current.action == 'buy_vehicle' then
			local shopCoords = Config.Vehicles.InsideShop
			local shopElements = {}

			local authorizedVehicles = Config.Vehicles.models

			if #authorizedVehicles > 0 then
				for k,vehicle in ipairs(authorizedVehicles) do
					table.insert(shopElements, {
						label = ('%s - <span style="color:green;">%s</span>'):format(vehicle.label, ESX.Math.GroupDigits(vehicle.price)),
						name  = vehicle.label,
						model = vehicle.model,
						price = vehicle.price
					})
				end
			else
				return
			end

			OpenShopMenu(shopElements, playerCoords, shopCoords)
		elseif data.current.action == 'garage' then
			local garage = {}

			ESX.TriggerServerCallback('esx_erfan_vehicleshop:retrieveJobVehicles', function(jobVehicles)
				if #jobVehicles > 0 then
					for k,v in ipairs(jobVehicles) do
						local props = json.decode(v.vehicle)
						local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(props.model))
						local label = ('%s - <span style="color:darkgoldenrod;">%s</span>: '):format(vehicleName, props.plate)

						if v.stored then
							label = label .. ('<span style="color:green;">%s</span>'):format('stored')
						else
							label = label .. ('<span style="color:darkred;">%s</span>'):format('out side')
						end

						table.insert(garage, {
							label = label,
							stored = v.stored,
							model = props.model,
							vehicleProps = props
						})
					end

					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_garage', {
						title    = 'Get Vehicle',
						align    = 'top-right',
						elements = garage
					}, function(data2, menu2)
						if data2.current.stored then
							local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint('Vehicles')

							if foundSpawn then
								menu2.close()

								local vector = vector3(spawnPoint.coords.x , spawnPoint.coords.y , spawnPoint.coords.z )
								ESX.Game.SpawnVehicle(data2.current.model, vector , spawnPoint.heading, function(vehicle)
									ESX.Game.SetVehicleProperties(vehicle, data2.current.vehicleProps)

									TriggerServerEvent('esx_erfan_vehicleshop:setJobVehicleState', data2.current.vehicleProps.plate, false)
									local prop = ESX.Game.GetVehicleProperties(vehicle)
									if not Config.nightclubs[prop.plate] then
										local coords = GetEntityCoords(vehicle)
										Config.nightclubs[prop.plate] = {
											dancefloor = {
												x = coords.x, y=  coords.y , z = coords.z , HearDistance = Config.HearDistance
											},
											djbooth = {
												x = coords.x, y=  ( coords.y  ), z = ( coords.z + 2 )
											}
										}
										table.insert(Vehicles,vehicle)
										table.insert(VehiclesPlate,prop.plate)
									end
									TriggerServerEvent('esx_erfan_jb_dj:spawnVehicle', Config.nightclubs)
									ESX.ShowNotification('Vehicle released')
								end)
							end
						else
							ESX.ShowNotification('Vehicle not available')
						end
					end, function(data2, menu2)
						menu2.close()
					end)

				else
					ESX.ShowNotification('garage empty')
				end
			end, 'car')

		elseif data.current.action == 'store_garage' then
			StoreNearbyVehicle(playerCoords)
		end

	end, function(data, menu)
		menu.close()
	end)

end


function StoreNearbyVehicle(playerCoords)
	local vehicles, vehiclePlates = ESX.Game.GetVehiclesInArea(playerCoords, 30.0), {}
	print(json.encode(vehicles))
	if #vehicles > 0 then
		for k,v in ipairs(vehicles) do

			-- Make sure the vehicle we're saving is empty, or else it wont be deleted
			if GetVehicleNumberOfPassengers(v) == 0 and IsVehicleSeatFree(v, -1) then
				table.insert(vehiclePlates, {
					vehicle = v,
					plate = ESX.Math.Trim(GetVehicleNumberPlateText(v))
				})
			end
		end
	else
		ESX.ShowNotification('garage store nearby')
		return
	end

	ESX.TriggerServerCallback('esx_erfan_jb_dj:storeNearbyVehicle', function(storeSuccess, foundNum)
		if storeSuccess then
			local vehicleId = vehiclePlates[foundNum]
			local attempts = 0
			ESX.Game.DeleteVehicle(vehicleId.vehicle)

			-- Workaround for vehicle not deleting when other players are near it.
			while DoesEntityExist(vehicleId.vehicle) do
				Citizen.Wait(500)
				attempts = attempts + 1

				-- Give up
				if attempts > 30 then
					break
				end

				vehicles = ESX.Game.GetVehiclesInArea(playerCoords, 30.0)
				if #vehicles > 0 then
					for k,v in ipairs(vehicles) do
						if ESX.Math.Trim(GetVehicleNumberPlateText(v)) == vehicleId.plate then
							ESX.Game.DeleteVehicle(v)
							break
						end
					end
				end
			end

			ESX.ShowNotification('garage has stored')
		else
			ESX.ShowNotification('garage has not stored')
		end
	end, vehiclePlates)
end


local charset = {}

-- qwertyuiopasdfghjklzxcvbnm1234567890
--for i = 48,  57 do table.insert(charset, string.char(i)) end
for i = 65,  90 do table.insert(charset, string.char(i)) end
for i = 97, 122 do table.insert(charset, string.char(i)) end

function stringrandom(length)
	math.randomseed(GetGameTimer())

	if length > 0 then
		return stringrandom(length - 1) .. charset[math.random(1, #charset)]
	else
		return ""
	end
end

function OpenShopMenu(elements, restoreCoords, shopCoords)
	local playerPed = PlayerPedId()
	isInShopMenu = true

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
		title    = 'buy vehicle',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		local newPlate = 'FES'..stringrandom(4)
		local vehicle  = GetVehiclePedIsIn(playerPed, false)
		local props    = ESX.Game.GetVehicleProperties(vehicle)
		props.plate    = newPlate
		ESX.TriggerServerCallback('esx_erfan_jb_dj:buyJobVehicle', function (bought)
			if bought then
				ESX.ShowNotification('you buy ' .. data.current.name ..' and pay $' .. ESX.Math.GroupDigits(data.current.price))

				isInShopMenu = false
				ESX.UI.Menu.CloseAll()

				DeleteSpawnedVehicles()
				FreezeEntityPosition(playerPed, false)
				SetEntityVisible(playerPed, true)

				ESX.Game.Teleport(playerPed, restoreCoords)
			else
				ESX.ShowNotification('you don\'t have enough money ')
			end
		end, props)
	end, function(data, menu)
		isInShopMenu = false
		ESX.UI.Menu.CloseAll()

		DeleteSpawnedVehicles()
		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)

		ESX.Game.Teleport(playerPed, restoreCoords)
	end, function(data, menu)
		DeleteSpawnedVehicles()

		WaitForVehicleToLoad(data.current.model)
		ESX.Game.SpawnLocalVehicle(data.current.model, shopCoords, 0.0, function(vehicle)
			table.insert(spawnedVehicles, vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
		end)
	end)

	WaitForVehicleToLoad(elements[1].model)
	ESX.Game.SpawnLocalVehicle(elements[1].model, shopCoords, 0.0, function(vehicle)
		table.insert(spawnedVehicles, vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)
	end)
end
function DeleteSpawnedVehicles()
	while #spawnedVehicles > 0 do
		local vehicle = spawnedVehicles[1]
		ESX.Game.DeleteVehicle(vehicle)
		table.remove(spawnedVehicles, 1)
	end
end
function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(0)

			DisableControlAction(0, Keys['TOP'], true)
			DisableControlAction(0, Keys['DOWN'], true)
			DisableControlAction(0, Keys['LEFT'], true)
			DisableControlAction(0, Keys['RIGHT'], true)
			DisableControlAction(0, 176, true) -- ENTER key
			DisableControlAction(0, Keys['BACKSPACE'], true)

			drawLoadingText('vehicleshop awaiting model', 255, 255, 255, 255)
		end
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isInShopMenu then
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		else
			Citizen.Wait(500)
		end
	end
end)


function GetAvailableVehicleSpawnPoint( part)
	local spawnPoints = Config.Vehicles.SpawnPoints
	local found, foundSpawnPoint = false, nil

	for i=1, #spawnPoints, 1 do
		local vetor = vector3(spawnPoints[i].coords.x , spawnPoints[i].coords.y , spawnPoints[i].coords.z )
		if ESX.Game.IsSpawnPointClear(vetor, spawnPoints[i].radius) then
			found, foundSpawnPoint = true, spawnPoints[i]
			break
		end
	end

	if found then
		return true, foundSpawnPoint
	else
		ESX.ShowNotification('jaye khali baraye mashin nist!')
		return false
	end
end