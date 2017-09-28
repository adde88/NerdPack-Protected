local _, gbl = ...
gbl.wToolkit64 = setmetatable(gbl.FireHack, {})

function gbl.wToolkit64.Load()
end

function gbl.wToolkit64.ObjectCreator(a)
	return _G.ObjectIsVisible(a) and _G.ObjectCreator(a)
end

function gbl.wToolkit64.GameObjectIsAnimating(a)
	return _G.ObjectIsVisible(a) and _G.GameObjectIsAnimating(a)
end

gbl:AddUnlocker('wToolkit64', {
	test = function() return _G.wToolkit64 end,
	init = gbl.wToolkit64.Load,
	prio = 2,
	functions = gbl.Generic,
	extended = gbl.wToolkit64,
	om = gbl.FireHack_OM
})
