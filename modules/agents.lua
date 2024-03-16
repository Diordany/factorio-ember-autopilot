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

function m_agents.unbind(p_iPlayer)
  m_agents.activeAgents[p_iPlayer] = nil
end

function m_agents.programs.walking_agent(p_player, p_params)
  -- Adjust the target position so that the character is centered on the target square.
  local target = {x = math.floor(p_params.targetPos.x) + 0.5, y = math.floor(p_params.targetPos.y) + 0.5}

  -- Walk if the player is not yet at the target position. Stop otherwise.
  if (p_player.character.position.x ~= target.x) or (p_player.character.position.y ~= target.y) then
    return {type = "walk", params = {targetPos = target}}
  else
    return {type = "stop"}
  end
end

function m_agents.programs.wander_agent(p_player, p_params)
  local target = m_agents.activeAgents[p_player.index].data.targetPos

  if target then
    if (p_player.character.position.x ~= target.x) or (p_player.character.position.y ~= target.y) then
      return {type = "walk", params = {targetPos = target}}
    end
  else
    target = {x = p_player.position.x, y = p_player.position.y}
  end

  target.x = math.floor(target.x + math.random(-1, 1)) + 0.5
  target.y = math.floor(target.y + math.random(-1, 1)) + 0.5

  if not p_player.surface.find_non_colliding_position(p_player.character.name, target, 0.5, 1, true) then
    target = p_player.character.position
  end

  m_agents.activeAgents[p_player.index].data.targetPos = target
  return {type = "walk", params = {targetPos = target}}
end

return m_agents
