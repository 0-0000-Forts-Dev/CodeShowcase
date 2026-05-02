dofile("scripts/forts.lua")
function RegisterEvent(name, func)
	local pre = _G[name]
	if pre then
		_G[name] = function(...)
			pre(...)
			func(...)
		end
	else
		_G[name] = func
	end
end
dofile(path.."/projects/StructureBombPlacement/script.lua")
