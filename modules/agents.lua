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
local m_agents = { activeAgents = {}, programs = {} }

local m_debug = require("__ember-autopilot__/modules/debug")
local m_surface = require("__ember-autopilot__/modules/surface")

function m_agents.bind(p_iPlayer, p_program, p_params)
  m_agents.activeAgents[p_iPlayer] = { execute = p_program, params = p_params, data = {} }
end

function m_agents.get_data(p_iPlayer, p_label)
  return m_agents.activeAgents[p_iPlayer].data[p_label]
end

function m_agents.set_data(p_iPlayer, p_label, p_data)
  m_agents.activeAgents[p_iPlayer].data[p_label] = p_data
end

function m_agents.get_first_element_data(p_iPlayer, p_label)
  if not m_agents.activeAgents[p_iPlayer].data[p_label] then
    return nil
  end

  if #m_agents.activeAgents[p_iPlayer].data[p_label] == 0 then
    return nil
  end

  return m_agents.activeAgents[p_iPlayer].data[p_label][1]
end

function m_agents.is_active(p_iPlayer)
  return m_agents.activeAgents[p_iPlayer] ~= nil
end

function m_agents.remove_first_element_data(p_iPlayer, p_label)
  table.remove(m_agents.activeAgents[p_iPlayer].data[p_label], 1)
end

function m_agents.unbind(p_iPlayer)
  m_agents.activeAgents[p_iPlayer] = nil
end

function m_agents.programs.path_agent(p_player, p_params)
  -- Stop if no path was found.
  if p_params.noPath then
    m_debug.print_error(p_player, "Path Agent: No path found.")
    return { type = "stop" }
  end

  -- Stop if blocked.
  if p_params.blocked then
    m_debug.print_error(p_player, "Path Agent: Path blocked.")
    return { type = "stop" }
  end

  -- Attempt to request a path if no search is active yet.
  if p_params.customPath then
    if not m_agents.get_data(p_player.index, "problem") then
      return {
        type = "request_path",
        params = {
          customPath = p_params.customPath,
          strategy = p_params.strategy,
          targetPos = p_params.targetPos
        }
      }
    end
  else
    local pathID = m_agents.get_data(p_player.index, "pathID")

    if not pathID then
      return { type = "request_path", params = { customPath = p_params.customPath, targetPos = p_params.targetPos } }
    end
  end

  -- Wait until the path is ready.
  if not p_params.pathReady then
    return { type = "idle" }
  end

  local target = m_agents.get_first_element_data(p_player.index, "path")

  -- Persue the current target position.
  if not p_params.destReached then
    if p_params.customPath then
      return { type = "walk", params = { targetPos = target } }
    else
      return { type = "walk", params = { targetPos = target.position } }
    end
  else
    -- Target reached, move on to the next target.
    m_agents.remove_first_element_data(p_player.index, "path")
    target = m_agents.get_first_element_data(p_player.index, "path")

    -- Stop if there are no targets left.
    if target then
      if p_params.customPath then
        return { type = "walk", params = { targetPos = target } }
      else
        return { type = "walk", params = { targetPos = target.position } }
      end
    else
      m_debug.print_verbose(p_player, "Path Agent: Destination reached.")

      return { type = "stop" }
    end
  end
end

function m_agents.programs.walking_agent(p_player, p_params)
  -- Stop if the agent is blocked by an obstacle.
  if p_params.blocked then
    m_debug.print_error(p_player, "Walking Agent: Path blocked.")
    return { type = "stop" }
  end

  -- Walk if the player is not yet at the target position. Stop otherwise.
  if not p_params.destReached then
    return { type = "walk", params = { targetPos = p_params.targetPos } }
  else
    m_debug.print_verbose(p_player, "Walking Agent: Destination reached.")

    return { type = "stop" }
  end
end

function m_agents.programs.wander_agent(p_player, p_params)
  local target = m_agents.get_data(p_player.index, "targetPos")

  if target then
    -- Stop pursuing the target position when blocked.
    if not p_params.blocked then
      -- Walk towards the target if the character is not at the position already.
      if not p_params.destReached then
        return { type = "walk", params = { targetPos = target } }
      end
    end
  end

  target = m_surface.get_random_adjacent_position(p_player.character.position)

  -- Don't move if the target position is inaccessible.
  if m_surface.player_collision_trace(p_player, nil, target, 2) then
    target = p_player.character.position
  end

  m_agents.set_data(p_player.index, "targetPos", target)
  return { type = "walk", params = { targetPos = target } }
end

return m_agents
