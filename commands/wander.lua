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
local m_agents = require("__ember-autopilot__/modules/agents")
local m_commands = require("__ember-autopilot__/modules/commands")
local m_debug = require("__ember-autopilot__/modules/debug")

m_commands.specs[m_commands.prefix .. "wander"] = {
  description = "Wander around aimlessly.",
  usage = "",
  callback = function(p_data)
    local player = game.players[p_data.player_index]

    m_debug.print_warning(player, "DEPRECATED: May be removed, replaced or may break in the future.")

    -- Cancel if the player has no character.
    if not player.character then
      m_debug.print_error(player, "The Wander Agent needs a character entity.")
      return
    end

    m_agents.bind(player.index, m_agents.programs.wander_agent, { blocked = false, destReached = false })
  end
}
