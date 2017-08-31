local n_name, gbl = ...
local NeP = _G.NeP

local noop = function() end
gbl.version = 2.0
gbl.unlocked = false
local unlockers = {}

NeP.Listener:Add(n_name, "ADDON_ACTION_FORBIDDEN", function(...)
	local addon = ...
	if addon == n_name then
		StaticPopup1:Hide()
		NeP.Core:Print('Didn\'t find any unlocker, using facerool.',
		'\n-> Right click the |cffff0000MasterToggle|r and press |cffff0000'..n_name..' v:'..gbl.version..'|r to try again.')
	end
end)

function gbl.AddUnlocker(_, name, eval)
	table.insert(unlockers, {
		name = name,
		test = eval.test,
		functions = eval.functions or {},
		extended = eval.extended or {},
		om = eval.om;
		init = eval.init or noop,
		prio = eval.prio or 0
	})
	table.sort( unlockers, function(a,b) return a.prio > b.prio end )
end

function gbl.SetUnlocker(_, name, unlocker)
	NeP.Core:Print('|cffff0000Found:|r ' .. name)
	unlocker.init()
	for uname, func in pairs(unlocker.functions) do
		NeP.Protected[uname] = func
	end
	for uname, func in pairs(unlocker.extended) do
		NeP.Protected[uname] = func
	end
	if unlocker.om then
		NeP.Protected.OM_Maker = unlocker.om
		NeP.Protected.nPlates = nil --Remove the nameplaces OM portion
	end
end

local _loads = NeP.Protected.callbacks
function gbl.TryLoads()
	for i=1, #_loads do
		if _loads[i] and _loads[i]() then
			_loads[i] = nil
		end
	end
end

function gbl.FindUnlocker()
	for i=1, #unlockers do
		local unlocker = unlockers[i]
		if unlocker.test() then
			NeP.Unlocked = nil -- this is created by the generic unlocker (get rid of it)
			gbl:SetUnlocker(unlocker.name, unlocker)
			gbl.TryLoads()
			return true
		end
	 end
end

NeP.Interface:Add(n_name..' v:'..gbl.version, gbl.FindUnlocker)

-- Delay until everything is ready
NeP.Core:WhenInGame(function()
	C_Timer.After(1, gbl.FindUnlocker)
end)
