local _, gbl                    = ...
local _G = _G
local NeP = _G.NeP

_G.InCombatLockdown = function() return UnitAffectingCombat("player") end

gbl.FireHack = {}

function gbl.FireHack.Load()
end

function gbl.FireHack.Distance(a, b)
	if not _G.ObjectIsVisible(a) or not _G.ObjectIsVisible(b) then return 999 end
	return _G.GetDistanceBetweenObjects(a,b)
end

function gbl.FireHack.Infront(a, b)
	if not _G.ObjectIsVisible(a) or not _G.ObjectIsVisible(b) then return false end
	return _G.ObjectIsFacing(a,b)
end

function gbl.FireHack.CastGround(spell, target)
	-- fallback to generic if we can cast it using macros
	if gbl.validGround[target] then
		return gbl.Generic.CastGround(spell, target)
	end
	if not _G.ObjectIsVisible(target) then return end
	local rX, rY = math.random(), math.random()
	local oX, oY, oZ = _G.ObjectPosition(target)
	if oX then oX = oX + rX; oY = oY + rY end
	gbl.Generic.Cast(spell)
	if oX then _G.ClickPosition(oX, oY, oZ) end
	_G.CancelPendingSpell()
end

function gbl.FireHack.UnitCombatRange(a, b)
	if not _G.ObjectIsVisible(a) or not _G.ObjectIsVisible(b) then return 999 end
	return gbl.FireHack.Distance(a, b) - (_G.UnitCombatReach(a) + _G.UnitCombatReach(b))
end

function gbl.FireHack.LineOfSight(a, b)
	if not _G.ObjectIsVisible(a) or not _G.ObjectIsVisible(b) then return false end
	-- skip if its a boss
	if NeP.BossID:Eval(a) or NeP.BossID:Eval(b) then return true end
	local ax, ay, az = _G.ObjectPosition(a)
	local bx, by, bz = _G.ObjectPosition(b)
	return not _G.TraceLine(ax, ay, az+2.25, bx, by, bz+2.25, _G.bit.bor(0x10, 0x100))
end

function gbl.FireHack_OM()
	for i=1, _G.GetObjectCount() do
		local Obj = _G.GetObjectWithIndex(i)
		NeP.OM:Add(Obj, _G.ObjectIsType(Obj, _G.ObjectTypes.GameObject))
	end
end

gbl:AddUnlocker('FireHack', {
	test = function() return _G.FireHack end,
	init = gbl.FireHack.Load,
	prio = 1,
	functions = gbl.Generic,
	extended = gbl.FireHack,
	om = gbl.FireHack_OM
})
