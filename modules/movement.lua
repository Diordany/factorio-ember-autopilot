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
local m_movement = {}

function m_movement.move_to_target_pos(p_player, p_params)
  local speed = p_player.character.character_running_speed

  -- Calculate the displacement between the character and target position.
  local xDiff = p_params.targetPos.x - p_player.position.x
  local yDiff = p_params.targetPos.y - p_player.position.y

  -- Calculate the absolute values of the displacement.
  local xDiffAbs = math.abs(xDiff)
  local yDiffAbs = math.abs(yDiff)

  -- If the character does not overshoot the target by walking.
  if (xDiffAbs > speed) or (yDiffAbs > speed) then
    -- Used for specifying the agent's walking direction.
    local dirStr = ""

    -- If the displacement is larger in the x direction, and the character does not overshoot the target by walking.
    if xDiffAbs - yDiffAbs > speed then
      -- Go directly east if the displacement is positive, else go directly west.
      if xDiff > 0 then
        dirStr = "east"
      else
        dirStr = "west"
      end
    elseif yDiffAbs - xDiffAbs > speed then
      -- If the displacement is larger in the y direction, and the character does not overshoot the target by walking.

      -- Go directly south if the displacement is positive, else go directly north.
      if yDiff > 0 then
        dirStr = "south"
      else
        dirStr = "north"
      end
    else
      -- The x and y displacement is equal in magnitude, and the character does not overshoot the target by walking.

      -- Go south if the y displacement is positive, else go north.
      if yDiff > 0 then
        dirStr = dirStr .. "south"
      else
        dirStr = dirStr .. "north"
      end

      -- Go east if the x displacement is positive, else go west.
      if xDiff > 0 then
        dirStr = dirStr .. "east"
      else
        dirStr = dirStr .. "west"
      end
    end

    p_player.character.walking_state = {walking = true, direction = defines.direction[dirStr]}
  else
    -- The distance to the target is too small, so the character will overshoot it by walking. Teleport instead without
    -- triggering the teleportation events.
    p_player.teleport(p_params.targetPos, p_player.surface, false)
  end
end

return m_movement
