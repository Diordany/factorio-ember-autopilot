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
local m_search = {}

m_debug = require("__ember-autopilot__/modules/debug")
m_problems = require("__ember-autopilot__/modules/problems")
m_surface = require("__ember-autopilot__/modules/surface")

function m_search.search_path_bfs(p_player, p_agent, p_workCount)
  for i = 1, p_workCount, 1 do
    if #p_agent.data.problem.frontier == 0 then
      p_agent.data.problem.done = true
      p_agent.params.noPath = true
      return
    end

    local node = table.remove(p_agent.data.problem.frontier, 1)

    table.insert(p_agent.data.problem.explored, { x = node.position.x, y = node.position.y })

    local child

    for _, e_neighbour in pairs(m_surface.get_accessible_neighbours(p_player, node.position)) do
      child = { parent = node, position = { x = e_neighbour.x, y = e_neighbour.y } }

      if not m_surface.position_in_list(p_agent.data.problem.explored, e_neighbour) then
        if not m_problems.path_node_in_list(p_agent.data.problem.frontier, child) then
          if (e_neighbour.x == p_agent.data.problem.goalState.x) and (e_neighbour.y == p_agent.data.problem.goalState.y) then
            p_agent.data.path = m_problems.generate_path(child)
            p_agent.data.problem.done = true
            p_agent.params.pathReady = true
            return
          end

          table.insert(p_agent.data.problem.frontier, child)
        end
      end
    end
  end
end

return m_search
