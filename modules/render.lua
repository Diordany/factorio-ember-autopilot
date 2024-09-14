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
local m_render = {}

function m_render.clear()
  rendering.clear("ember-autopilot")
end

function m_render.render_explored_positions(p_player, p_table)
  for v_x, e_yList in pairs(p_table) do
    if e_yList then
      for _, v_y in pairs(e_yList) do
        rendering.draw_circle {
          color = { r = 255, g = 255, b = 0 },
          radius = 0.1,
          width = 2,
          target = { x = v_x, y = v_y },
          surface = p_player.surface,
          players = { p_player },
          draw_on_ground = true
        }
      end
    end
  end
end

function m_render.render_goal_position(p_player, p_position)
  rendering.draw_circle {
    color = { r = 200, g = 0, b = 200 },
    radius = 0.5,
    width = 2,
    target = p_position,
    surface = p_player.surface,
    players = { p_player },
    draw_on_ground = true
  }
end

function m_render.render_initial_position(p_player, p_position)
  rendering.draw_circle {
    color = { r = 0, g = 0, b = 255 },
    radius = 0.5,
    width = 2,
    target = p_position,
    surface = p_player.surface,
    players = { p_player },
    draw_on_ground = true
  }
end

function m_render.render_open_path_branches(p_player, p_nodes)
  local node
  for _, e_node in pairs(p_nodes) do
    node = e_node

    while node.parent do
      rendering.draw_line {
        color = { r = 100, g = 0, b = 0 },
        width = 2,
        from = node.position,
        to = node.parent.position,
        surface = p_player.surface,
        players = { p_player },
        draw_on_ground = true
      }

      node = node.parent
    end
  end
end

function m_render.render_open_path_branches_table(p_player, p_table)
  for v_x, e_yList in pairs(p_table) do
    if e_yList then
      for v_y, e_priorityNode in pairs(e_yList) do
        node = e_priorityNode.value

        while node.parent do
          rendering.draw_line {
            color = { r = 100, g = 0, b = 0 },
            width = 2,
            from = node.position,
            to = node.parent.position,
            surface = p_player.surface,
            players = { p_player },
            draw_on_ground = true
          }

          node = node.parent
        end
      end
    end
  end
end

function m_render.render_open_path_nodes(p_player, p_nodes)
  for _, e_node in pairs(p_nodes) do
    rendering.draw_circle {
      color = { r = 255, g = 0, b = 0 },
      radius = 0.5,
      width = 2,
      target = e_node.position,
      surface = p_player.surface,
      players = { p_player },
      draw_on_ground = true
    }
  end
end

function m_render.render_open_path_nodes_table(p_player, p_table)
  for v_x, e_yList in pairs(p_table) do
    if e_yList then
      for v_y, _ in pairs(e_yList) do
        rendering.draw_circle {
          color = { r = 255, g = 0, b = 0 },
          radius = 0.5,
          width = 2,
          target = { x = v_x, y = v_y },
          surface = p_player.surface,
          players = { p_player },
          draw_on_ground = true
        }
      end
    end
  end
end

function m_render.render_path(p_player, p_path)
  local previousPos

  for _, e_position in pairs(p_path) do
    if previousPos then
      rendering.draw_line {
        color = { r = 0, g = 255, b = 0 },
        width = 2,
        from = previousPos,
        to = e_position,
        surface = p_player.surface,
        players = { p_player },
        draw_on_ground = true
      }
    end

    previousPos = e_position
  end
end

return m_render
