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
local m_primer = {}

local m_agents = require("__ember-autopilot__/modules/agents")

function m_primer.path_bfs(p_player, p_target)
  local params = {
    targetPos = m_surface.center_position(p_target),
    strategy = "path_bfs",
    customPath = true,
    blocked = false,
    pathReady = false,
    noPath = false,
    destReached = false
  }

  m_agents.bind(p_player.index, m_agents.programs.path_agent, params)
end

function m_primer.path_built_in(p_player, p_target)
  local params = {
    targetPos = m_surface.center_position(p_target),
    strategy = "path_built_in",
    customPath = false,
    blocked = false,
    pathReady = false,
    noPath = false,
    destReached = false
  }

  m_agents.bind(p_player.index, m_agents.programs.path_agent, params)
end

function m_primer.path_dfs(p_player, p_target)
  local params = {
    targetPos = m_surface.center_position(p_target),
    strategy = "path_dfs",
    customPath = true,
    blocked = false,
    pathReady = false,
    noPath = false,
    destReached = false
  }

  m_agents.bind(p_player.index, m_agents.programs.path_agent, params)
end

function m_primer.path_greedy(p_player, p_target)
  local params = {
    targetPos = m_surface.center_position(p_target),
    strategy = "path_greedy",
    customPath = true,
    blocked = false,
    pathReady = false,
    noPath = false,
    destReached = false
  }

  m_agents.bind(p_player.index, m_agents.programs.path_agent, params)
end

function m_primer.path_ucs(p_player, p_target)
  local params = {
    targetPos = m_surface.center_position(p_target),
    strategy = "path_ucs",
    customPath = true,
    blocked = false,
    pathReady = false,
    noPath = false,
    destReached = false
  }

  m_agents.bind(p_player.index, m_agents.programs.path_agent, params)
end

function m_primer.walk(p_player, p_target)
  local params = {
    targetPos = m_surface.center_position(p_target),
    blocked = false,
    destReached = false
  }

  m_agents.bind(p_player.index, m_agents.programs.walking_agent, params)
end

function m_primer.wander(p_player, p_target)
  m_agents.bind(p_player.index, m_agents.programs.wander_agent, { blocked = false, destReached = false })
end

return m_primer
