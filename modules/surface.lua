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
  directions_4 = { "north", "east", "south", "west" },
  directions_4_diagonal = { "northeast", "southeast", "southwest", "northwest" },
  directions_8 = { "north", "northeast", "east", "southeast", "south", "southwest", "west", "northwest" },
  dirOffset = {
    north = { x = 0, y = -1 },
    northeast = { x = 1, y = -1 },
    east = { x = 1, y = 0 },
    southeast = { x = 1, y = 1 },
    south = { x = 0, y = 1 },
    southwest = { x = -1, y = 1 },
    west = { x = -1, y = 0 },
    northwest = { x = -1, y = -1 }
  }
}

function m_surface.center_position(p_position)
  return { x = math.floor(p_position.x) + 0.5, y = math.floor(p_position.y) + 0.5 }
end

function m_surface.get_accessible_neighbours(p_player, p_position, p_directions)
  local neighbours = m_surface.get_neighbours(p_position, p_directions)
  local accessible = {}
  local offset

  for _, e_neighbour in pairs(neighbours) do
    if not m_surface.player_collision_trace(p_player, p_position, e_neighbour, 2) then
      table.insert(accessible, e_neighbour)
    end
  end

  return accessible
end

function m_surface.get_closest_accessible_neighbour(p_player, p_steps, p_actions)
  local neighbours = m_surface.get_neighbours(p_player.position, p_actions)
  local neighbour
  local distance

  for i_neighbour, e_neighbour in pairs(neighbours) do
    if not distance then
      if not m_surface.player_collision_trace(p_player, nil, e_neighbour, p_steps) then
        neighbour = e_neighbour
        distance = m_surface.get_distance(p_player.position, e_neighbour)
      end
    else
      local newDistance = m_surface.get_distance(p_player.position, e_neighbour)

      if newDistance < distance then
        neighbour = e_neighbour
        distance = newDistance
      end
    end
  end

  return neighbour
end

function m_surface.get_distance(p_posA, p_posB)
  return math.sqrt((p_posB.x - p_posA.x) ^ 2 + (p_posB.y - p_posA.y) ^ 2)
end

function m_surface.get_neighbours(p_position, p_directions)
  local centerPos = m_surface.center_position(p_position)

  local neighbours = {}
  local offset

  for _, k_direction in pairs(p_directions) do
    offset = m_surface.dirOffset[k_direction]

    table.insert(neighbours, { x = centerPos.x + offset.x, y = centerPos.y + offset.y })
  end

  return neighbours
end

function m_surface.get_random_adjacent_position(p_position)
  return {
    x = math.floor(p_position.x + math.random(-1, 1)) + 0.5,
    y = math.floor(p_position.y + math.random(-1, 1)) + 0.5
  }
end

function m_surface.get_reverse_vector(p_magnitude, p_directionCode)
  local unit = m_surface.dirOffset[string.lower(game.direction_to_string(p_directionCode))]

  return { x = -p_magnitude * unit.x, y = -p_magnitude * unit.y }
end

function m_surface.get_underlying_belt(p_player)
  local belts = p_player.surface.find_entities_filtered { position = p_player.position, type = { "transport-belt", "splitter" } }

  if #belts == 1 then
    return belts[1]
  else
    return nil
  end
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

function m_surface.player_collision_trace(p_player, p_start, p_target, p_steps)
  -- Test if there's a collision at the destination first
  if m_surface.player_collision_at(p_player, p_target) then
    return true
  end

  -- Make sure that the number of steps is an integer.
  p_steps = math.floor(p_steps)

  -- Stop the collision test if the number of steps is 1 or less.
  if p_steps <= 1 then
    return false
  end

  local start = p_start or p_player.position

  local offSet = {
    x = (p_target.x - start.x) / p_steps,
    y = (p_target.y - start.y) / p_steps
  }

  local pos = { x = start.x, y = start.y }

  -- Test the collision at every step. Return if colliding.
  for i = 1, p_steps, 1 do
    pos.x = pos.x + i * offSet.x
    pos.y = pos.y + i * offSet.y

    if m_surface.player_collision_at(p_player, pos) then
      return true
    end
  end
end

function m_surface.player_is_at_position(p_player, p_position)
  return (p_player.position.x == p_position.x) and (p_player.position.y == p_position.y)
end

function m_surface.position_in_list(p_list, p_position)
  for _, e_position in pairs(p_list) do
    if (p_position.x == e_position.x) and (p_position.y == e_position.y) then
      return true
    end
  end

  return false
end

function m_surface.request_factorio_path(p_player, p_target)
  if not p_player.force.is_pathfinder_busy() then
    return p_player.surface.request_path {
      bounding_box = p_player.character.bounding_box,
      collision_mask = p_player.character.prototype.collision_mask,
      start = p_player.position,
      goal = p_target,
      force = p_player.force,
      radius = 0
    }
  else
    return nil
  end
end

return m_surface
