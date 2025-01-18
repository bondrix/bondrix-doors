GlobalState.doors = {}

function BondrixDoors.RegisterDoors(doors)
    local currentDoors = GlobalState.doors
    for id, door in pairs(doors) do
        currentDoors[id] = door
    end

    GlobalState.doors = currentDoors
    print(json.encode(GlobalState.doors))
end
RegisterNetEvent('bondrix-doors:server:onDoorsRegister')
AddEventHandler('bondrix-doors:server:onDoorsRegister', function(doors)
    BondrixDoors.RegisterDoors(doors)
end)

function BondrixDoors.LockDoor(id)
    TriggerClientEvent('bondrix-doors:client:onDoorLock', -1, id)
end
RegisterNetEvent('bondrix-doors:server:onDoorLock')
AddEventHandler('bondrix-doors:server:onDoorLock', function(id)
    BondrixDoors.LockDoor(id)
end)

function BondrixDoors.UnlockDoor(id)
    TriggerClientEvent('bondrix-doors:client:onDoorUnlock', -1, id)
end
RegisterNetEvent('bondrix-doors:server:onDoorUnlock')
AddEventHandler('bondrix-doors:server:onDoorUnlock', function(id)
    BondrixDoors.UnlockDoor(id)
end)

AddEventHandler('playerJoining', function()
    for id, door in pairs(GlobalState.doors) do
        TriggerClientEvent('bondrix-doors:client:onDoorRegister', source, id, door)
    end
end)