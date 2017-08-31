local _, gbl = ...

NeP.DSL:Register("advanced", function()
	return HackEnabled ~= nil
end)

NeP.DSL:Register("ishackenabled", function(_, hack)
	return HackEnabled and HackEnabled(hack)
end)
