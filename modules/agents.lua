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
local m_agents = {activeAgents = {}, programs = {}}

local m_surface = require("__ember-autopilot__/modules/surface")

function m_agents.bind(p_iPlayer, p_program, p_params)
  m_agents.activeAgents[p_iPlayer] = {execute = p_program, params = p_params, data = {}}
end

function m_agents.get_data(p_iPlayer, p_label)
  return m_agents.activeAgents[p_iPlayer].data[p_label]
end

function m_agents.set_data(p_iPlayer, p_label, p_data)
  m_agents.activeAgents[p_iPlayer].data[p_label] = p_data
end

function m_agents.unbind(p_iPlayer)
  m_agents.activeAgents[p_iPlayer] = nil
end

function m_agents.programs.walking_agent(p_player, p_params)
  local target = m_agents.get_data(p_player.index, "targetPos")

  -- Stop if the agent is blocked by an obstacle.
  if p_params.blocked then
    p_player.print("Walking Agent: Path blocked.")
    return {type = "stop"}
  end

  -- Calculate the target position. This should only happen once for this agent.
  if not target then
    -- Adjust the target position so that the character is centered on the target square.
    target = m_surface.center_position(p_params.targetPos)
    m_agents.set_data(p_player.index, "targetPos")
  end

  -- Walk if the player is not yet at the target position. Stop otherwise.
  if (p_player.position.x ~= target.x) or (p_player.position.y ~= target.y) then
    return {type = "walk", params = {targetPos = target}}
  else
    p_player.print("Walking Agent: Destination reached.")
    return {type = "stop"}
  end
end

function m_agents.programs.wander_agent(p_player, p_params)
  local target = m_agents.get_data(p_player.index, "targetPos")

  if target then
    -- Stop pursuing the target position when blocked.
    if not p_params.blocked then
      -- Walk towards the target if the character is not at the position already.
      if (p_player.position.x ~= target.x) or (p_player.position.y ~= target.y) then
        return {type = "walk", params = {targetPos = target}}
      end
    end
  end

  target = m_surface.get_random_adjacent_position(p_player.position)

  -- Don't move if the target position is inaccessible.
  if m_surface.player_collision_trace(p_player, target, 2) then
    target = p_player.position
  end

  m_agents.set_data(p_player.index, "targetPos", target)
  return {type = "walk", params = {targetPos = target}}
end

return m_agents
