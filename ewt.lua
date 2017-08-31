local _, gbl = ...

gbl.EWT = {}

function gbl.EWT.Load()
	gbl.FireHack.Load()
end

gbl:AddUnlocker('EasyWoWToolBox', {
	test = function() return EWT end,
	init = gbl.EWT.Load,
	prio = 2,
	functions = gbl.Generic,
	extended = gbl.FireHack,
	om = gbl.FireHack_OM
})
