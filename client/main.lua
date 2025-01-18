function BondrixDoors.RegisterDoor(id, door)
    AddDoorToSystem(id, door.model, door.position)
    DoorSystemSetDoorState(id, door.locked and 1 or 0)
end
RegisterNetEvent('bondrix-doors:client:onDoorRegister')
AddEventHandler('bondrix-doors:client:onDoorRegister', function(id, door)
    BondrixDoors.RegisterDoor(id, door)
end)

function BondrixDoors.LockDoor(id)
    GlobalState.doors[id].locked = true
    DoorSystemSetDoorState(id, 1)
end
RegisterNetEvent('bondrix-doors:client:onDoorLock')
AddEventHandler('bondrix-doors:client:onDoorLock', function(id)
    BondrixDoors.LockDoor(id)
end)

function BondrixDoors.UnlockDoor(id)
    GlobalState.doors[id].locked = false
    DoorSystemSetDoorState(id, 0)
end
RegisterNetEvent('bondrix-doors:client:onDoorUnlock')
AddEventHandler('bondrix-doors:client:onDoorUnlock', function(id)
    BondrixDoors.UnlockDoor(id)
end)

function BondrixDoors.GetClosestDoor()
    local models = {}
    for _, door in pairs(GlobalState.doors) do
        if not door.doors then
            models[#models + 1] = door.model
        else
            for _, door in pairs(door.doors) do
                models[#models + 1] = door.model
            end
        end
    end

    local door
    for _, model in ipairs(models) do
        door = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), BondrixDoors.Config.radius, model)
        if door ~= 0 then break end
    end
    if door == 0 then return end
    local positon = GetEntityCoords(door)

    local found, id = DoorSystemFindExistingDoor(positon.x, positon.y, positon.z, GetEntityModel(door))
    if not found then return end
    if not IsDoorRegisteredWithSystem(id) then return end

    return id
end

RegisterCommand('door', function()
    BondrixDoors = exports['bondrix-doors']:GetObject()
    local id = BondrixDoors.GetClosestDoor()
    if not id then return end

    if DoorSystemGetDoorState(id) == 1 then TriggerServerEvent('bondrix-doors:server:onDoorUnlock', id)
    else TriggerServerEvent('bondrix-doors:server:onDoorLock', id) end
end, false)
RegisterKeyMapping('door', 'Lock/Unlock Door', 'keyboard', 'o')