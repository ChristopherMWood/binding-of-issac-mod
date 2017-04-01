local wondrousWares = RegisterMod("Wondrous Wares", 1)

local playSound
function playSound(position, soundEffect) 
    local sound_entity = Isaac.Spawn(EntityType.ENTITY_FLY, 0, 0, position, Vector(0,0), nil):ToNPC()
    sound_entity:PlaySound(soundEffect, 100, 0, false, 1)
    sound_entity:Remove()
end

local function IsEnemy(entity)
  if entity ~= nil and entity:IsActiveEnemy(false) and entity:CanShutDoors() then
      return true
  end
  return false
end

local function GetRandomEnemyInTheRoom() 
  local entities = Isaac.GetRoomEntities()
  local index = 1
  local possible = {}
  for i = 1, #entities do
		if IsProperEnemy(entities[i]) then
			possible[index] = entities[i]
      index = index + 1
		end
	end
  return possible[math.random(1, index)]
end

------------------------ Death Note ------------------------------
local deathNote = {
    ID = Isaac.GetItemIdByName("Death Note")
}

function wondrousWares:useDeathNote(itemId) {
    if itemId == deathNote.ID then
        enemyIndex = 0;
        enemies = {}

        for i, entity in pairs(Isaac.GetRoomEntities()) do
            if IsEnemy(entity) then
                enemies[enemyIndex] = entity
                enemyIndex = enemyIndex + 1
            end
        end

        if enemyIndex ~= 0 then
            enemy = enemies[math.random(0, enemyIndex - 1)]
            enemy.Kill()
            
            local player = Game():GetPlayer(0)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, Isaac.GetFreeNearPosition(player.Position, 60.0), Vector(0, 0), player)
        end
    end
}

function wondrousWares:deathNoteUpdate() {
    enemyIndex = 0;
    enemies = {}

    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if IsEnemy(entity) then
            enemies[enemyIndex] = entity
            enemyIndex = enemyIndex + 1
        end
    end

    if enemyIndex ~= 0 then
        enemy = enemies[math.random(0, enemyIndex - 1)]
        enemy.Kill()
        
        local player = Game():GetPlayer(0)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, Isaac.GetFreeNearPosition(player.Position, 60.0), Vector(0, 0), player)
    end
}


wondrousWares:AddCallback(ModCallbacks.MC_USE_ITEM, wondrousWares.useDeathNote, deathNote.ID)
wondrousWares:AddCallback(ModCallbacks.MC_NPC_UPDATE, wondrousWares.deathNoteUpdate)