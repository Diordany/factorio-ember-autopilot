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
  -- Adjust the target position so that the character is centered on the target square.
  local target = {x = math.floor(p_params.targetPos.x) + 0.5, y = math.floor(p_params.targetPos.y) + 0.5}

  -- Walk if the player is not yet at the target position. Stop otherwise.
  if (p_player.position.x ~= target.x) or (p_player.position.y ~= target.y) then
    return {type = "walk", params = {targetPos = target}}
  else
    return {type = "stop"}
  end
end

function m_agents.programs.wander_agent(p_player, p_params)
  local target = m_agents.get_data(p_player.index, "targetPos")

  if target then
    local prevPos = m_agents.get_data(p_player.index, "prevPos")

    -- Stop pursuing the target position when stuck.
    if not ((p_player.position.x == prevPos.x) and (p_player.position.y == prevPos.y)) then
      -- Walk towards the target if the character is not at the position already.
      if (p_player.position.x ~= target.x) or (p_player.position.y ~= target.y) then
        m_agents.set_data(p_player.index, "prevPos", p_player.position)
        return {type = "walk", params = {targetPos = target}}
      end
    end
  else
    -- Set the initial target to the current position if no target was specified yet.
    target = {x = p_player.position.x, y = p_player.position.y}
  end

  -- Pick an adjacent position as the new target.
  target.x = math.floor(target.x + math.random(-1, 1)) + 0.5
  target.y = math.floor(target.y + math.random(-1, 1)) + 0.5

  -- Don't move if the target position is occupied.
  if p_player.surface.entity_prototype_collides(p_player.character.prototype, target, false) then
    target = p_player.position
  end

  m_agents.set_data(p_player.index, "targetPos", target)

  m_agents.set_data(p_player.index, "prevPos", p_player.position)
  return {type = "walk", params = {targetPos = target}}
end

return m_agents
