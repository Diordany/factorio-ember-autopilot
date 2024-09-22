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
local m_controller = {}

local m_agents = require("__ember-autopilot__/modules/agents")
local m_primer = require("__ember-autopilot__/modules/primer")

function m_controller.on_left_select(p_data)
  if p_data.item ~= "ember-controller" then
    return
  end

  local player = game.players[p_data.player_index]

  if not player.character then
    m_debug.print_error(player, "Need a player character.")
    return
  end

  local mouseX = (p_data.area.left_top.x + p_data.area.right_bottom.x) / 2
  local mouseY = (p_data.area.left_top.y + p_data.area.right_bottom.y) / 2

  local mode = player.mod_settings["ember-movement-mode"].value

  m_primer[mode](player, { x = mouseX, y = mouseY })
end

function m_controller.on_left_shift_select(p_data)
  if p_data.item ~= "ember-controller" then
    return
  end

  local player = game.players[p_data.player_index]

  if m_agents.is_active(player.index) then
    m_agents.unbind(player.index)

    m_debug.print_verbose(player, "Agent stopped.")
  else
    m_debug.print_error(player, "No active agent.")
  end
end

function m_controller.on_right_select(p_data)
  if p_data.item ~= "ember-controller" then
    return
  end
end

function m_controller.on_right_shift_select(p_data)
  if p_data.item ~= "ember-controller" then
    return
  end
end

return m_controller
