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
local cmd_path = {
  name = "path",
  description = "Uses the built-in pathing algorithm to find and follow a path to the given position.",
  usage = "<x> <y>",
}

local m_agents = require("__ember-autopilot__/modules/agents")
local m_parser = require("__ember-autopilot__/modules/parser")

cmd_path.callback = function(p_data)
  local player = game.players[p_data.player_index]

  m_debug.print_warning(player, "DEPRECATED: May be removed, replaced or may break in the future.")

  -- Cancel if the player has no character.
  if not player.character then
    m_debug.print_error(player, "The Path Agent needs a character entity.")
    return
  end

  -- Cancel if no arguments were given.
  if not p_data.parameter then
    m_debug.print_error(player, "Usage: /" .. p_data.name .. " " .. cmd_path.usage)
    return
  end

  local args = m_parser.get_args(p_data.parameter)

  -- Cancel if not enough arguments were given.
  if #args < 2 then
    m_debug.print_error(player, "Usage: /" .. p_data.name .. " " .. cmd_path.usage)
    return
  end

  local target = { x = tonumber(args[1]), y = tonumber(args[2]) }

  -- Cancel if the target position is not valid.
  if (not target.x) or (not target.y) then
    m_debug.print_error(player, "Invalid position coordinate: (" .. args[1] .. ", " .. args[2] .. ")")
    return
  end

  local params = {
    targetPos = m_surface.center_position(target),
    blocked = false,
    pathReady = false,
    noPath = false,
    destReached = false
  }

  m_agents.bind(player.index, m_agents.programs.path_agent, params)
end

return cmd_path
