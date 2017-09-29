local _, gbl = ...
local NeP = _G.NeP
gbl.Generic = {}
local f = gbl.Generic
local g = gbl.gapis

function f.Load()
end

gbl.validGround = {
	["player"] = true,
	["cursor"] = true
}

function f.Cast(spell, target)
	print("Spell: ", spell, "Target: ", target)
	g.CastSpellByName(spell, target)
end

function f.CastGround(spell, target)
	if not gbl.validGround[target] then
		target = "cursor"
	end
	print("Spell: ", spell, "Target: ", target)
	f.Macro("/cast [@"..target.."]"..spell)
end

function f.Macro(text)
	print("Macro Text: ", text)
	g.RunMacroText(text)
end

function f.UseItem(name, target)
	print("Item: ", name, "Target: ", target)
	g.UseItemByName(name, target)
end

function f.UseInvItem(name)
	print("Item: ", name)
	g.UseInventoryItem(name)
end

function f.TargetUnit(target)
	print("Target Unit: ", target)
	g.TargetUnit(target)
end

function f.SpellStopCasting()
	print("Stop Casting")
	g.SpellStopCasting()
end

gbl:AddUnlocker('Generic', {
	test = function()
		pcall(_G.RunMacroText, '/run NeP.Unlocked = true')
		return NeP.Unlocked ~= nil
	end,
	init = f.Load,
	functions = f,
})
