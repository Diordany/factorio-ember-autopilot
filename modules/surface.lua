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
local m_surface = {}

function m_surface.player_collision_at(p_player, p_position)
  local filter = {
    area = {
      left_top = {
        x = p_position.x + p_player.character.prototype.collision_box.left_top.x,
        y = p_position.y + p_player.character.prototype.collision_box.left_top.y
      },
      right_bottom = {
        x = p_position.x + p_player.character.prototype.collision_box.right_bottom.x,
        y = p_position.y + p_player.character.prototype.collision_box.right_bottom.y
      }
    },
    collision_mask = p_player.character.prototype.collision_mask
  }

  local entities = p_player.surface.find_entities_filtered(filter)

  -- No colliding entities found.
  if #entities == 0 then
    return false
  end

  -- Ignore the current player.
  if #entities == 1 then
    if entities[1].type == "character" then
      if entities[1].player then
        if entities[1].player.index == p_player.index then
          return false
        end
      end
    end
  end

  return true
end

return m_surface
