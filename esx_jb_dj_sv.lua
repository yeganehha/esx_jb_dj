-- start INIT ESX
ESX              = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
-- end INIT ESX


RegisterServerEvent('esx_erfan_jb_dj:setcommand')
AddEventHandler('esx_erfan_jb_dj:setcommand', function(command, songname, dancefloor)
	TriggerClientEvent('esx_erfan_jb_dj:setmusicforeveryone', -1, command, songname, dancefloor)
end)


RegisterServerEvent('esx_erfan_jb_dj:spawnVehicle')
AddEventHandler('esx_erfan_jb_dj:spawnVehicle', function(vehicle)
	TriggerClientEvent('esx_erfan_jb_dj:spawnVehicle', -1, vehicle)
end)




ESX.RegisterServerCallback('esx_erfan_jb_dj:buyJobVehicle', function(source, cb, vehicleProps)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = getPriceFromHash(vehicleProps.model)

	-- vehicle model not found
	if price == nil then
		print(('esx_erfan_jb_dj: %s attempted to exploit the shop! (invalid vehicle model)'):format(xPlayer.identifier))
		cb(false)
	else
		if xPlayer.getMoney() >= price then
			xPlayer.removeMoney(price)

			MySQL.Async.execute('INSERT INTO owned_vehicles (owner, vehicle, plate, type, job, `stored`) VALUES (@owner, @vehicle, @plate, @type, @job, @stored)', {
				['@owner'] = xPlayer.identifier,
				['@vehicle'] = json.encode(vehicleProps),
				['@plate'] = vehicleProps.plate,
				['@type'] = 'car',
				['@job'] = xPlayer.job.name,
				['@stored'] = true
			}, function (rowsChanged)
				cb(true)
			end)
		else
			cb(false)
		end
	end
end)

function getPriceFromHash(hashKey)
	local vehicles = Config.Vehicles.models

	for k,v in ipairs(vehicles) do
		if GetHashKey(v.model) == hashKey then
			return v.price
		end
	end
	return nil
end


ESX.RegisterServerCallback('esx_erfan_jb_dj:storeNearbyVehicle', function(source, cb, nearbyVehicles)
	local xPlayer = ESX.GetPlayerFromId(source)
	local foundPlate, foundNum

	for k,v in ipairs(nearbyVehicles) do
		print( v.plate)
		local result = MySQL.Sync.fetchAll('SELECT plate FROM owned_vehicles WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = v.plate,
			['@job'] = xPlayer.job.name
		})

		if result[1] then
			foundPlate, foundNum = result[1].plate, k
			break
		end
	end

	if not foundPlate then
		cb(false)
	else
		MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = foundPlate,
			['@job'] = xPlayer.job.name
		}, function (rowsChanged)
			if rowsChanged == 0 then
				print(('esx_erfan_jb_dj: %s has exploited the garage!'):format(xPlayer.identifier))
				cb(false)
			else
				cb(true, foundNum)
			end
		end)
	end

end)

