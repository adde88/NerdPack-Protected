local _, gbl = ...
local NeP = _G.NeP
gbl.FireHack = gbl.MergeTable(gbl.Generic, {})
local f = gbl.FireHack
local g = gbl.gapis

function f.Load()
	g.ObjectCreator = _G.GetObjectDescriptorAccessor("CGUnitData::createdBy", _G.Type.GUID)
	g.GameObjectIsAnimating = _G.GetObjectFieldAccessor(0x1C4, _G.Type.Bool)
	-- FireHack b27 breaks InCombatLockdown, lets fix it
	_G.InCombatLockdown = function() return g.UnitAffectingCombat("player") end
end

function f.Distance(a, b)
	-- Make Sure the Unit Exists
	if not g.ObjectIsVisible(a)
	or not g.ObjectIsVisible(b) then
		return 999
	end
	return g.GetDistanceBetweenObjects(a,b)
end

function f.Infront(a, b)
	-- Make Sure the Unit Exists
	if not g.ObjectIsVisible(a)
	or not g.ObjectIsVisible(b) then
		return false
	end
	return g.ObjectIsFacing(a,b)
end

function f.ObjectExists(Obj)
	return g.ObjectIsVisible(Obj)
end

function f.CastGround(spell, target)
	-- fallback to generic if we can cast it using macros
	if gbl.validGround[target] then
		return gbl.Generic.CastGround(spell, target)
	end
	if not g.ObjectIsVisible(target) then return end
	local rX, rY = math.random(), math.random()
	local oX, oY, oZ = g.ObjectPosition(target)
	if oX then oX = oX + rX; oY = oY + rY end
	gbl.Generic.Cast(spell)
	if oX then g.ClickPosition(oX, oY, oZ) end
	g.CancelPendingSpell()
end

function f.UnitCombatRange(a, b)
	-- Make Sure the Unit Exists
	if not g.ObjectIsVisible(a)
	or not g.ObjectIsVisible(b) then
		return 999
	end
	return f.Distance(a, b) - (g.UnitCombatReach(a) + g.UnitCombatReach(b))
end

function f.ObjectCreator(a)
	return g.ObjectIsVisible(a) and g.ObjectCreator(a)
end

function f.GameObjectIsAnimating(a)
	return g.ObjectIsVisible(a) and g.GameObjectIsAnimating(a)
end

function f.LineOfSight(a, b)
	-- Make Sure the Unit Exists
	if not g.ObjectIsVisible(a)
	or not g.ObjectIsVisible(b) then
		return false
	end
	-- skip if its a boss
	if NeP.BossID:Eval(a)
	or NeP.BossID:Eval(b) then
		return true
	end
	-- contiunue
	local ax, ay, az = g.ObjectPosition(a)
	local bx, by, bz = g.ObjectPosition(b)
	return not g.TraceLine(ax, ay, az+2.25, bx, by, bz+2.25, g.bit.bor(0x10, 0x100))
end

function f.OM_Maker()
	for i=1, g.GetObjectCount() do
		local Obj = g.GetObjectWithIndex(i)
		NeP.OM:Add(Obj, g.ObjectIsType(Obj, g.ObjectTypes.GameObject))
	end
end

gbl:AddUnlocker('FireHack', {
	test = function() return _G.FireHack end,
	init = f.Load,
	prio = 1,
	functions = f,
})
