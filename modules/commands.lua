-- MIT License
--
-- Copyright (c) 2024 Diordany van Hemert
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
local m_commands = { specs = {} }

local m_agents = require("__ember-autopilot__/modules/agents")
local m_debug = require("__ember-autopilot__/modules/debug")
local m_parser = require("__ember-autopilot__/modules/parser")
local m_surface = require("__ember-autopilot__/modules/surface")

local g_cmdPrefix = "ember-"

function m_commands.init()
  for cmdName, cmdSpec in pairs(m_commands.specs) do
    commands.add_command(cmdName, cmdSpec.description, cmdSpec.callback)
  end
end

m_commands.specs[g_cmdPrefix .. "controller"] = {
  description = "Gives the player an Ember controller.",
  usage = "",
  callback = function(p_data)
    local player = game.players[p_data.player_index]

    if player.can_insert { name = "ember-controller" } then
      player.insert { name = "ember-controller" }
      m_debug.print(player, "Ember controller given.")
    else
      m_debug.print(player, "No inventory space left.")
    end
  end
}

m_commands.specs[g_cmdPrefix .. "path"] = {
  description = "Uses the built-in pathing algorithm to find and follow a path to the given position.",
  usage = "<x> <y>",
  callback = function(p_data)
    local player = game.players[p_data.player_index]

    -- Cancel if the player has no character.
    if not player.character then
      m_debug.print(player, "The Path Agent needs a character entity.")
      return
    end

    -- Cancel if no arguments were given.
    if not p_data.parameter then
      m_debug.print(player, "Usage: /" .. p_data.name .. " " .. m_commands.specs[p_data.name].usage)
      return
    end

    local args = m_parser.get_args(p_data.parameter)

    -- Cancel if not enough arguments were given.
    if #args < 2 then
      m_debug.print(player, "Usage: /" .. p_data.name .. " " .. m_commands.specs[p_data.name].usage)
      return
    end

    local target = { x = tonumber(args[1]), y = tonumber(args[2]) }

    -- Cancel if the target position is not valid.
    if (not target.x) or (not target.y) then
      m_debug.print(player, "Invalid position coordinate: (" .. args[1] .. ", " .. args[2] .. ")")
      return
    end

    local params = { targetPos = m_surface.center_position(target), blocked = false, pathReady = false, noPath = false }

    m_agents.bind(player.index, m_agents.programs.path_agent, params)
  end
}

m_commands.specs[g_cmdPrefix .. "stop"] = {
  description = "Unbinds any agent that is assigned to the player.",
  usage = "",
  callback = function(p_data)
    m_agents.unbind(p_data.player_index)
  end
}

m_commands.specs[g_cmdPrefix .. "walkpos"] = {
  description = "Walks over to the given position.",
  usage = "<x> <y>",
  callback = function(p_data)
    local player = game.players[p_data.player_index]

    -- Cancel if the player has no character.
    if not player.character then
      m_debug.print(player, "The Walking Agent needs a character entity.")
      return
    end

    -- Cancel if no arguments were given.
    if not p_data.parameter then
      m_debug.print(player, "Usage: /" .. p_data.name .. " " .. m_commands.specs[p_data.name].usage)
      return
    end

    local args = m_parser.get_args(p_data.parameter)

    -- Cancel if not enough arguments were given.
    if #args < 2 then
      m_debug.print(player, "Usage: /" .. p_data.name .. " " .. m_commands.specs[p_data.name].usage)
      return
    end

    local target = { x = tonumber(args[1]), y = tonumber(args[2]) }

    -- Cancel if the target position is not valid.
    if (not target.x) or (not target.y) then
      m_debug.print(player, "Invalid position coordinate: (" .. args[1] .. ", " .. args[2] .. ")")
      return
    end

    local params = { targetPos = m_surface.center_position(target), blocked = false }

    m_agents.bind(player.index, m_agents.programs.walking_agent, params)
  end
}

m_commands.specs[g_cmdPrefix .. "walkrel"] = {
  description = "Covers the given displacement by walking.",
  usage = "<x> <y>",
  callback = function(p_data)
    local player = game.players[p_data.player_index]

    -- Cancel if the player has no character.
    if not player.character then
      m_debug.print(player, "The Walking Agent needs a character entity.")
      return
    end

    -- Cancel if no arguments were given.
    if not p_data.parameter then
      m_debug.print(player, "Usage: /" .. p_data.name .. " " .. m_commands.specs[p_data.name].usage)
      return
    end

    local args = m_parser.get_args(p_data.parameter)

    -- Cancel if not enough arguments were given.
    if #args < 2 then
      m_debug.print(player, "Usage: /" .. p_data.name .. " " .. m_commands.specs[p_data.name].usage)
      return
    end

    local target = { x = tonumber(args[1]), y = tonumber(args[2]) }

    -- Cancel if the target position is not valid.
    if (not target.x) or (not target.y) then
      m_debug.print(player, "Invalid position coordinate: (" .. args[1] .. ", " .. args[2] .. ")")
      return
    end

    target.x = target.x + player.position.x
    target.y = target.y + player.position.y

    local params = { targetPos = m_surface.center_position(target), blocked = false }

    m_agents.bind(player.index, m_agents.programs.walking_agent, params)
  end
}

m_commands.specs[g_cmdPrefix .. "wander"] = {
  description = "Wander around aimlessly.",
  usage = "",
  callback = function(p_data)
    local player = game.players[p_data.player_index]

    -- Cancel if the player has no character.
    if not player.character then
      m_debug.print(player, "The Wander Agent needs a character entity.")
      return
    end

    m_agents.bind(player.index, m_agents.programs.wander_agent, { blocked = false })
  end
}

return m_commands
