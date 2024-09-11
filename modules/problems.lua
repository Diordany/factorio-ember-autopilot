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
local m_problems = {}

local m_agents = require("__ember-autopilot__/modules/agents")
local m_surface = require("__ember-autopilot__/modules/surface")

function m_problems.generate_path(p_goalNode)
  local node = p_goalNode

  local pathReverse = {}
  local path = {}

  while node do
    table.insert(pathReverse, node.position)
    node = node.parent
  end

  for i = #pathReverse, 1, -1 do
    table.insert(path, pathReverse[i])
  end

  return path
end

function m_problems.generate_path_problem(p_player, p_params)
  if m_surface.player_collision_at(p_player, p_params.targetPos) then
    m_agents.activeAgents[p_player.index].params.noPath = true
    return nil
  end

  local problem = {
    type = "path",
    strategy = p_params.strategy,
    goalState = p_params.targetPos,
    actions = m_surface[p_player.mod_settings["ember-movement-direction-set"].value],
    frontier = {},
    explored = {},
    done = false
  }

  local initPos = m_surface.center_position(p_player.position)

  if not m_surface.player_collision_trace(p_player, nil, initPos, 2) then
    if not (initPos.x == problem.goalState.x) or not (initPos.y == problem.goalState.y) then
      table.insert(problem.frontier, { position = initPos })
    else
      m_agents.activeAgents[p_player.index].data.path = { initPos }
      m_agents.activeAgents[p_player.index].params.pathReady = true
      problem.done = true
    end
  else
    initPos = m_surface.get_closest_accessible_neighbour(p_player, 2, m_surface.directions_8)

    if initPos then
      table.insert(problem.frontier, { position = initPos })
    end
  end

  problem.initState = initPos

  return problem
end

function m_problems.path_node_in_list(p_list, p_node)
  for _, e_node in pairs(p_list) do
    if (p_node.position.x == e_node.position.x) and (p_node.position.y == e_node.position.y) then
      return true
    end
  end

  return false
end

return m_problems
