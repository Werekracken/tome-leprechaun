local class = require"engine.class"
local ActorTalents = require "engine.interface.ActorTalents"
local ActorTemporaryEffects = require "engine.interface.ActorTemporaryEffects"
local Birther = require "engine.Birther"

class:bindHook("ToME:load", function(self, data)
	Birther:loadDefinition("/data-leprechaun/birth/halfling.lua")
    ActorTalents:loadDefinition("/data-leprechaun/talents/leprechaun.lua")
    ActorTemporaryEffects:loadDefinition("/data-leprechaun/timed_effects.lua")
end)

--[[
class:bindHook("Entity:loadList",
    function(self, data)
    if data.file == "/data/general/objects/special-artifacts.lua" then
        self:loadList("/data-leprechaun/general/special-artifacts.lua", data.no_default, data.res, data.mod, data.loaded)
    end
end)
]]
