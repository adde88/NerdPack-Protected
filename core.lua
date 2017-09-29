local n_name, gbl = ...
local NeP = _G.NeP

local noop = function() end
gbl.version = 2.0
gbl.unlocked = false
local unlockers = {}
gbl.gapis = {}

NeP.Listener:Add(n_name, "ADDON_ACTION_FORBIDDEN", function(...)
	local addon = ...
	if addon == n_name then
		_G.StaticPopup1:Hide()
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
	gbl.MergeTable(unlocker.functions, NeP.Protected)
end

local _loads = NeP.Protected.callbacks
function gbl.TryLoads()
	for i=1, #_loads do
		if _loads[i] and _loads[i]() then
			_loads[i] = nil
		end
	end
end

local lList = {
	--firehack
	'ObjectCreator',
	'GameObjectIsAnimating',
	'GetObjectDescriptorAccessor',
	'GetObjectFieldAccessor',
	'Type',
	'ObjectIsVisible',
	'GetDistanceBetweenObjects',
	'ObjectPosition',
	'ClickPosition',
	'ObjectIsFacing',
	'UnitCombatReach',
	'TraceLine',
	'GetObjectCount',
	'GetObjectWithIndex',
	'ObjectIsType',
	'ObjectTypes',
	'UnitAffectingCombat',
	'CancelPendingSpell',
	'bit',
	--EWT
	'ObjectExists',
	'CastAtPosition',
	'ObjectCount',
	'ObjectWithIndex',
	--generic
	'SpellStopCasting',
	'TargetUnit',
	'UseInventoryItem',
	'UseItemByName',
	'RunMacroText',
	'CastSpellByName'
}

function gbl.loadGlobals()
	for i=1, #lList do
		gbl.gapis[lList[i]] = _G[lList[i]]
	end
end

function gbl.FindUnlocker()
	for i=1, #unlockers do
		local unlocker = unlockers[i]
		if unlocker.test() then
			NeP.Unlocked = nil -- this is created by the generic unlocker (get rid of it)
			gbl:SetUnlocker(unlocker.name, unlocker)
			gbl.loadGlobals()
			gbl.TryLoads()
			return true
		end
	 end
end

function gbl.MergeTable(a,b)
    for name, func in pairs(a) do
        b[name] = func
    end
    return b
end

NeP.Interface:Add(n_name..' v:'..gbl.version, gbl.FindUnlocker)

-- Delay until everything is ready
NeP.Core:WhenInGame(function()
	_G.C_Timer.After(1, gbl.FindUnlocker)
end)
