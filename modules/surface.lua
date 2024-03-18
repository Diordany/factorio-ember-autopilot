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
local m_surface = {
  dirOffset = {
    north = {x = 0, y = -1},
    northeast = {x = 1, y = -1},
    east = {x = 1, y = 0},
    southeast = {x = 1, y = 1},
    south = {x = 0, y = 1},
    southwest = {x = -1, y = 1},
    west = {x = -1, y = 0},
    northwest = {x = -1, y = -1}
  }
}

function m_surface.center_position(p_position)
  return {x = math.floor(p_position.x) + 0.5, y = math.floor(p_position.y) + 0.5}
end

function m_surface.get_random_adjacent_position(p_position)
  return {
    x = math.floor(p_position.x + math.random(-1, 1)) + 0.5,
    y = math.floor(p_position.y + math.random(-1, 1)) + 0.5
  }
end

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
  local tiles = p_player.surface.find_tiles_filtered(filter)

  -- Colliding tiles found.
  if #tiles > 0 then
    return true
  end

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

function m_surface.player_collision_next(p_player, p_direction)
  local speed = p_player.character.character_running_speed
  local nextPos = p_player.position

  local nextPos = {
    x = p_player.position.x + m_surface.dirOffset[p_direction].x * speed,
    y = p_player.position.y + m_surface.dirOffset[p_direction].y * speed
  }

  return m_surface.player_collision_at(p_player, nextPos)
end

function m_surface.player_collision_trace(p_player, p_position, p_steps)
  -- Test if there's a collision at the destination first
  if m_surface.player_collision_at(p_player, p_position) then
    return true
  end

  -- Make sure that the number of steps is an integer.
  p_steps = math.floor(p_steps)

  -- Stop the collision test if the number of steps is 1 or less.
  if p_steps <= 1 then
    return false
  end

  local offSet = {
    x = (p_position.x - p_player.position.x) / p_steps,
    y = (p_position.y - p_player.position.y) / p_steps
  }
  local pos = p_player.position

  -- Test the collision at every step. Return if colliding.
  for i = 1, p_steps, 1 do
    pos.x = pos.x + i * offSet.x
    pos.y = pos.y + i * offSet.y

    if m_surface.player_collision_at(p_player, pos) then
      return true
    end
  end
end

return m_surface
