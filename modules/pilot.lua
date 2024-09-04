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
local m_pilot = {}

local m_agents = require("__ember-autopilot__/modules/agents")
local m_movement = require("__ember-autopilot__/modules/movement")

function m_pilot.execute(p_player, p_agent, p_action)
  if p_action.type == "walk" then
    p_agent.params.blocked = not m_movement.move_to_target_pos(p_player, p_action.params)
  elseif p_action.type == "stop" then
    m_agents.unbind(p_player.index)
  end
end

function m_pilot.run(p_data)
  local player
  local action

  for iPlayer, agent in pairs(m_agents.activeAgents) do
    player = game.players[iPlayer]
    action = agent.execute(player, agent.params)
    m_pilot.execute(player, agent, action)
  end
end

function m_pilot.update_paths(p_data)
  -- Search the associated agent.
  for _, e_agent in pairs(m_agents.activeAgents) do
    -- If the search finished.
    if (p_data.id == e_agent.data.pathID) and (not p_data.try_again_later) then
      -- Set the path info.
      if p_data.path then
        e_agent.params.pathReady = true
        e_agent.data.path = p_data.path
      else
        e_agent.params.noPath = true
      end
    end
  end
end

function m_pilot.init()
  script.on_event(defines.events.on_tick, m_pilot.run)
  script.on_event(defines.events.on_script_path_request_finished, m_pilot.update_paths)
end

return m_pilot
