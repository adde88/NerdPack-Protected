local _, gbl                    = ...

gbl.FireHack = {}

function gbl.FireHack.Load()
	gbl.Generic.Load()
end

function gbl.FireHack.Distance(a, b)
	if not ObjectIsVisible(a) or not ObjectIsVisible(b) then return 999 end
	return GetDistanceBetweenObjects(a,b)
end

function gbl.FireHack.Infront(a, b)
	if not ObjectIsVisible(a) or not ObjectIsVisible(b) then return false end
	return ObjectIsFacing(a,b)
end

function gbl.FireHack.CastGround(spell, target)
	-- fallback to generic if we can cast it using macros
	if gbl.validGround[target] then
		return gbl.Generic.CastGround(spell, target)
	end
	if not ObjectIsVisible(target) then return end
	local rX, rY = math.random(), math.random()
	local oX, oY, oZ = ObjectPosition(target)
	if oX then oX = oX + rX; oY = oY + rY end
	gbl.Generic.Cast(spell)
	if oX then CastAtPosition(oX, oY, oZ) end
	CancelPendingSpell()
end

function gbl.FireHack.UnitCombatRange(a, b)
	if not ObjectIsVisible(a) or not ObjectIsVisible(b) then return 999 end
	return gbl.FireHack.Distance(a, b) - (UnitCombatReach(a) + UnitCombatReach(b))
end

function gbl.FireHack.LineOfSight(a, b)
	if not ObjectIsVisible(a) or not ObjectIsVisible(b) then return false end
	-- skip if its a boss
	if NeP.BossID:Eval(a) or NeP.BossID:Eval(b) then return true end
	local ax, ay, az = ObjectPosition(a)
	local bx, by, bz = ObjectPosition(b)
	return not TraceLine(ax, ay, az+2.25, bx, by, bz+2.25, bit.bor(0x10, 0x100))
end

function gbl.FireHack_OM()
	for i=1, GetObjectCount() do
		NeP.OM:Add(GetObjectWithIndex(i))
	end
end

gbl:AddUnlocker('FireHack', {
	test = function() return FireHack end,
	init = gbl.FireHack.Load,
	prio = 1,
	functions = gbl.Generic,
	extended = gbl.FireHack,
	om = gbl.FireHack_OM
})
