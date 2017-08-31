local _, gbl = ...

local bools = {
 ['TRUE'] = true,
 ['FALSE'] = false,
 ['NIL'] = nil
}

--USAGE in CR:
--{"%target", CONDITION, TARGET}
NeP.Actions:Add('target', function(eval)
  eval.exe = function(eva)
    NeP.Protected.TargetUnit(eva.target)
    return true
  end
end)

--USAGE in CR:
--{"%SetHack(HACK, ENABLE)", CONDITION}
NeP.Actions:Add('sethack', function(eval)
  local hack, bool = strsplit(',', eval[1].args, 2)
  bool = bool and bool:upper() or 'NIL'
  eval.exe = function()
    if HackEnabled then
      HackEnabled(hack, bools[bool])
      return true
    end
  end
end)

--USAGE in CR:
--{"%SendKey(KEY)", CONDITION}
NeP.Actions:Add('target', function(eval)
  eval.exe = function(eva)
    if SendKey then
      SendKey(eva[1].args)
      return true
    end
  end
end)
