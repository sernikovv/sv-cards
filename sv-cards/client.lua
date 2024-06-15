ESX = exports.es_extended.getSharedObject()
ox_target = exports.ox_target
-- Kup info
local ped = 'a_m_m_og_boss_01'

Citizen.CreateThread(function()
    RequestModel(ped)
    while not HasModelLoaded(ped) or not HasCollisionForModelLoaded(ped) do
    Wait(1)
end

    typo = CreatePed(28, ped, 277.0372, -1746.403, 28.56611, 6.02, true, true)
    SetEntityAsMissionEntity(typo, true, true)
    SetEntityInvincible(typo, true)
    SetBlockingOfNonTemporaryEvents(typo, true)
    FreezeEntityPosition(typo, true)
end)

ox_target:addBoxZone({
    coords = vec3(276.89, -1746.2, 29.45),
    size = vec3(1.2, 1, 1),
    rotation = 100,
    drawSprite = true,
    options = {
        {
            name = 'box',
            event = 'ox_target:debug',
	    onSelect = function()
		kupInfo()
	    end,
            icon = 'fas fa-credit-card',
            label = 'Kup informacje',
        }
    }
})

function kupInfo()
    ESX.TriggerServerCallback('sv-cards:stacgo', function(hasitem)
        if hasitem then
            ESX.ShowNotification('Kupiłeś info')
            TriggerServerEvent('sv-cards:removeitem', 'money', 3500)
            TriggerServerEvent('sv-cards:additem', 'danekarta', 1)
            TriggerServerEvent('sv-cards:additem', 'pustakarta', 1)
        else
            ESX.ShowNotification('Nie stać cię')
        end
    end)
end

-- Tworzenie karty
ox_target:addBoxZone({
    coords = vec3(1209.2, -3115.12, 5.54),
    size = vec3(0.5, 0.5, 1),
    rotation = 0,
    drawSprite = true,
    options = {
        {
            name = 'box',
            event = 'ox_target:debug',
	    onSelect = function()
		laptok()
	    end,
            icon = 'fas fa-credit-card',
            label = 'Uruchom laptopa',
        }
    }
})

function laptok()
    ESX.TriggerServerCallback('sv-cards:itemylaptok', function(hasitem)
        if hasitem then
            ESX.ShowNotification('Uruchamianie laptopa')
            local success = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 0.5}, 'easy'}, {'1', '2', '3', '4', '5'})

            if success then
                print('success')
                if lib.progressCircle({
                    duration = 3500,
                    label = 'Uruchamianie laptopa',
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        car = true,
                        movement = true,
                        mouse = false,
                        combat = true,
                    },
                }) 
                then 
                    --print('Do stuff when complete')
                    TriggerEvent("utk_fingerprint:Start", 4, 6, 2, function(outcome, reason)
                        if outcome == true then
                            --print("Succeed")
                            TriggerServerEvent('sv-cards:removeitem', 'pustakarta', 1)
                            TriggerServerEvent('sv-cards:removeitem', 'danekarta', 1)
                            TriggerServerEvent('sv-cards:additem', 'fakekarta', 1)
                        elseif outcome == false then
                            --print("Failed. Reason: "..reason)
                        end
                    end)
                else 
                    ESX.ShowNotification('Przerwano')
                end
            else
                print("successn't")
            end
        else
            ESX.ShowNotification('Nie masz wszystkich wymaganych przedmiotów')
        end
    end)
end

--Wymienianie karty na kase

local dajbrudne = false --Czy z bankomatu ma być dawana brudna kasa

local bankomaty = {
    -870868698,
    -1126237515,
    -1364697528,
    506770882
}

ox_target:addModel(bankomaty, {
    {
        name = 'bankomaty',
	onSelect = function()
	    bankomaty()
	end,
        icon = 'fas fa-credit-card',
        label = 'Użyj karty kredytowej',
	items = 'fakekarta',
    }
})

function bankomaty()
   if lib.progressCircle({
        duration = 2000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            movement = true,
            mouse = false,
            combat = true,
            },
        anim = {
            dict = 'anim@amb@prop_human_atm@interior@male@enter',
            clip = 'enter'
        },
    }) 
    then 
        TriggerServerEvent('sv-cards:removeitem', 'fakekarta', 1)
        if dajbrudne == true then
            TriggerServerEvent('sv-cards:additem', 'black_money', math.random(1000,5000))
        elseif dajbrudne == false then
            TriggerServerEvent('sv-cards:additem', 'money', math.random(1000,5000))
        end
    end
end
