local _, gbl = ...
gbl.wToolkit64 = gbl.MergeTable(gbl.FireHack, {})
local f = gbl.wToolkit64
local g = gbl.gapis

function f.Load()
end

function f.ObjectCreator(a)
	return g.ObjectIsVisible(a) and g.ObjectCreator(a)
end

function f.GameObjectIsAnimating(a)
	return g.ObjectIsVisible(a) and g.GameObjectIsAnimating(a)
end

gbl:AddUnlocker('wToolkit64', {
	test = function() return _G.wToolkit64 end,
	init = f.Load,
	prio = 2,
	functions = f
})
