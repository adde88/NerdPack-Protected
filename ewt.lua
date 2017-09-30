local _, gbl = ...
gbl.EWT = gbl.MergeTable(gbl.FireHack, {})
local NeP = _G.NeP
local f = gbl.EWT
local g = gbl.gapis

function f.Load()
end

function f.Distance(a, b)
	if not g.ObjectExists(a)
	or not g.ObjectExists(b) then
		return 999
	end
	return g.GetDistanceBetweenObjects(a,b)
end

function f.Infront(a, b)
	if not g.ObjectExists(a)
	or not g.ObjectExists(b) then
		return false
	end
	return g.ObjectIsFacing(a,b)
end

function f.CastGround(spell, target)
	-- fallback to generic if we can cast it using macros
	if gbl.validGround[target] then
		return gbl.Generic.CastGround(spell, target)
	end
	if not g.ObjectExists(target) then return end
	local rX, rY = math.random(), math.random()
	local oX, oY, oZ = g.ObjectPosition(target)
	if oX then oX = oX + rX; oY = oY + rY end
	gbl.Generic.Cast(spell)
	if oX then g.CastAtPosition(oX, oY, oZ) end
	g.CancelPendingSpell()
end

function f.ObjectExists(Obj)
	return g.ObjectExists(Obj)
end

function f.UnitCombatRange(a, b)
	if not g.ObjectExists(a)
	or not g.ObjectExists(b) then
		return 999
	end
	return f.Distance(a, b) - (g.UnitCombatReach(a) + g.UnitCombatReach(b))
end

function f.LineOfSight(a, b)
	if not g.ObjectExists(a)
	or not g.ObjectExists(b) then
		return false
	end
	-- skip if its a boss
	if NeP.BossID:Eval(a)
	or NeP.BossID:Eval(b) then
		return true
	end
	local ax, ay, az = g.ObjectPosition(a)
	local bx, by, bz = g.ObjectPosition(b)
	return not g.TraceLine(ax, ay, az+2.25, bx, by, bz+2.25, g.bit.bor(0x10, 0x100))
end

function f.OM_Maker()
	for i=1, g.ObjectCount() do
		NeP.OM:Add(g.ObjectWithIndex(i))
	end
end

gbl:AddUnlocker('EasyWoWToolBox', {
	test = function() return _G.EWT end,
	init = f.Load,
	prio = 2,
	functions = f,
})
