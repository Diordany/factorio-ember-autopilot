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
local m_actions = {}

local m_agents = require("__ember-autopilot__/modules/agents")
local m_movement = require("__ember-autopilot__/modules/movement")
local m_problems = require("__ember-autopilot__/modules/problems")

function m_actions.search_path(p_player, p_agent, p_params)
  if p_params.customPath then
    p_agent.data.problem = m_problems.generate_path_problem(p_player, p_params)

    m_debug.print_verbose(p_player, "Pilot: Path requested.")
  else
    local pathID = m_surface.request_factorio_path(p_player, p_params.targetPos)

    if pathID then
      m_debug.print_verbose(p_player, "Pilot: Factorio path requested.")

      p_agent.data.pathID = pathID
    end
  end
end

function m_actions.stop(p_player)
  m_agents.unbind(p_player.index)
end

function m_actions.walk(p_player, p_agent, p_params)
  p_agent.params.blocked = not m_movement.move_to_target_pos(p_player, p_params)
  p_agent.params.destReached = m_surface.player_is_at_position(p_player, p_params.targetPos)
end

return m_actions
