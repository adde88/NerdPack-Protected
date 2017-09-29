local _, gbl = ...
gbl.EWT = gbl.MergeTable(gbl.FireHack, {})
local NeP = _G.NeP
local f = gbl.EWT

function f.Load()
end

function f.Distance(a, b)
	if not _G.ObjectExists(a)
	or not _G.ObjectExists(b) then
		return 999
	end
	return _G.GetDistanceBetweenObjects(a,b)
end

function f.Infront(a, b)
	if not _G.ObjectExists(a)
	or not _G.ObjectExists(b) then
		return false
	end
	return _G.ObjectIsFacing(a,b)
end

function f.CastGround(spell, target)
	-- fallback to generic if we can cast it using macros
	if gbl.validGround[target] then
		return gbl.Generic.CastGround(spell, target)
	end
	if not _G.ObjectExists(target) then return end
	local rX, rY = math.random(), math.random()
	local oX, oY, oZ = _G.ObjectPosition(target)
	if oX then oX = oX + rX; oY = oY + rY end
	gbl.Generic.Cast(spell)
	if oX then _G.CastAtPosition(oX, oY, oZ) end
	_G.CancelPendingSpell()
end

function f.ObjectExists(Obj)
	return _G.ObjectExists(Obj)
end

function f.UnitCombatRange(a, b)
	if not _G.ObjectExists(a)
	or not _G.ObjectExists(b) then
		return 999
	end
	return f.Distance(a, b) - (_G.UnitCombatReach(a) + _G.UnitCombatReach(b))
end

function f.LineOfSight(a, b)
	if not _G.ObjectExists(a)
	or not _G.ObjectExists(b) then
		return false
	end
	-- skip if its a boss
	if NeP.BossID:Eval(a)
	or NeP.BossID:Eval(b) then
		return true
	end
	local ax, ay, az = _G.ObjectPosition(a)
	local bx, by, bz = _G.ObjectPosition(b)
	return not _G.TraceLine(ax, ay, az+2.25, bx, by, bz+2.25, _G.bit.bor(0x10, 0x100))
end

function f.OM_Maker()
	for i=1, _G.ObjectCount() do
		NeP.OM:Add(_G.ObjectWithIndex(i))
	end
end

gbl:AddUnlocker('EasyWoWToolBox', {
	test = function() return _G.EWT end,
	init = f.Load,
	prio = 2,
	functions = f,
})
