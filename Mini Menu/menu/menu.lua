# Feel free to change ANYTHING in here btw.

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("example menu title")
_menuPool:Add(mainMenu)

-- Used in "FirstMenu"
bool = false

function FirstItem(menu) 
    local click = NativeUI.CreateItem("Go on duty as a Civilian!", "Once you have pressed it, head to the section Get Your Guns and select your loadout!")
    menu:AddItem(click)
    menu.OnItemSelect = function(sender, item, index)
        -- check if what changed is from this menu
        if item == click then
            SetEntityHealth(PlayerPedId(), 200)
            notify("~g~Successfully Went on duty! Go to the section Get your Guns and select your loadout!")
        end
    end
end


-- this menu is a checkbox item
function SecondItem(menu)
   local checkbox = NativeUI.CreateCheckboxItem("Don't Click me!", bool, "Is it true or False?")
   menu:AddItem(checkbox)
   menu.OnCheckboxChange = function (sender, item, checked_)
      -- check if what changed is from this menu
      if item == checkbox then
        bool = checked_
        --[[ Outputs what the checkbox state is ]]
        notify(tostring(bool))
      end
   end
end


function ThirdItem(menu) 
    local click = NativeUI.CreateItem("Heal Your Player!", "Get back up to Max Health!")
    menu:AddItem(click)
    menu.OnItemSelect = function(sender, item, index)
        if item == click then
            SetEntityHealth(PlayerPedId(), 200)
            notify("~g~Successfully Healed.")
        end
    end
end


-- Used in "FourthItem"
weapons = {
    "weapon_flashlight",
    "weapon_combatpistol",
    "weapon_bat"
}
function FourthItem(menu)
    local gunsList = NativeUI.CreateListItem("Get Your Guns!", weapons, 1)
    menu:AddItem(gunsList)
    menu.OnListSelect = function(sender, item, index)  
        if item == gunsList then
            local selectedGun = item:IndexToItem(index)
            giveWeapon(selectedGun)
            notify("~g~Successfully spawned in a "..selectedGun)
        end
    end
end


-- used in "FifthItem"
seats = {-1,0,1,2}
function FifthItem(menu) 
   local submenu = _menuPool:AddSubMenu(menu, "~b~MFSRP Sub Menu") 
   local carItem = NativeUI.CreateItem("Spawn the basic car in!", "Spawn car in through our Sub Menu!")
   carItem.Activated = function(sender, item)
        if item == carItem then
            spawnCar("camry18")
            notify("~g~Successfully Spawned a Camry 2018!")
        end
   end
   local seat = NativeUI.CreateSliderItem("Change your Car Seat!", seats, 1)
    submenu.OnSliderChange = function(sender, item, index)
        if item == seat then
            vehSeat = item:IndexToItem(index)
            local pedsCar = GetVehiclePedIsIn(GetPlayerPed(-1),false)
            SetPedIntoVehicle(PlayerPedId(), pedsCar, vehSeat)
        end
    end
   submenu:AddItem(carItem)
   submenu:AddItem(seat)
end


FirstItem(mainMenu)
SecondItem(mainMenu)
ThirdItem(mainMenu)
FourthItem(mainMenu)
FifthItem(mainMenu)
_menuPool:RefreshIndex()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
        --[[ The "e" button will activate the menu ]]
        if IsControlJustPressed(1, 167) then
            mainMenu:Visible(not mainMenu:Visible())
        end
    end
end)


--[[ COPY BELOW ]]

function notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, true)
end

function giveWeapon(hash)
    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(hash), 999, false, false)
end

function spawnCar(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(50)
    end

    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), false))
    local vehicle = CreateVehicle(car, x + 2, y + 2, z + 1, GetEntityHeading(PlayerPedId()), true, false)
    SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
    
    SetEntityAsNoLongerNeeded(vehicle)
    SetModelAsNoLongerNeeded(vehicleName)
    
    --[[ SetEntityAsMissionEntity(vehicle, true, true) ]]
end