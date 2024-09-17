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
local m_pilot = {}

local m_actions = require("__ember-autopilot__/modules/actions")
local m_agents = require("__ember-autopilot__/modules/agents")
local m_debug = require("__ember-autopilot__/modules/debug")
local m_gui = require("__ember-autopilot__/modules/gui")
local m_render = require("__ember-autopilot__/modules/render")
local m_search = require("__ember-autopilot__/modules/search")
local m_surface = require("__ember-autopilot__/modules/surface")

function m_pilot.catch_drops(p_data)
  local player = game.players[p_data.player_index]

  if p_data.entity.stack then
    if p_data.entity.stack.name == "ember-controller" then
      p_data.entity.destroy()
      m_debug.print(player, "The Ember controller vanished.")
    end
  end
end

function m_pilot.handle_controller(p_data)
  local player = game.players[p_data.player_index]

  if p_data.item == "ember-controller" then
    if p_data.name == defines.events.on_player_selected_area then
      if not player.character then
        m_debug.print_error(player, "Need a player character.")
        return
      end

      local mouseX = (p_data.area.left_top.x + p_data.area.right_bottom.x) / 2
      local mouseY = (p_data.area.left_top.y + p_data.area.right_bottom.y) / 2

      local mode = player.mod_settings["ember-movement-mode"].value

      if mode == "path-greedy" or mode == "path-ucs" or mode == "path-bfs" or mode == "path-dfs" then
        local params = {
          targetPos = m_surface.center_position { x = mouseX, y = mouseY },
          strategy = mode,
          customPath = true,
          blocked = false,
          pathReady = false,
          noPath = false,
          destReached = false
        }

        m_agents.bind(player.index, m_agents.programs.path_agent, params)
      elseif mode == "walk" then
        local params = {
          targetPos = m_surface.center_position { x = mouseX, y = mouseY },
          blocked = false,
          destReached = false
        }
        m_agents.bind(player.index, m_agents.programs.walking_agent, params)
      elseif mode == "path-built-in" then
        local params = {
          targetPos = m_surface.center_position { x = mouseX, y = mouseY },
          strategy = mode,
          customPath = false,
          blocked = false,
          pathReady = false,
          noPath = false,
          destReached = false
        }

        m_agents.bind(player.index, m_agents.programs.path_agent, params)
      elseif mode == "wander" then
        m_agents.bind(player.index, m_agents.programs.wander_agent, { blocked = false, destReached = false })
      end
    elseif p_data.name == defines.events.on_player_reverse_selected_area then
    elseif p_data.name == defines.events.on_player_alt_selected_area then
      if m_agents.is_active(player.index) then
        m_agents.unbind(player.index)

        m_debug.print_verbose(player, "Agent stopped.")
      else
        m_debug.print_error(player, "No active agent.")
      end
    elseif p_data.name == defines.events.on_player_alt_reverse_selected_area then
    end
  end
end

function m_pilot.init()
  script.on_event(defines.events.on_player_dropped_item, m_pilot.catch_drops)
  script.on_event(defines.events.on_player_alt_reverse_selected_area, m_pilot.handle_controller)
  script.on_event(defines.events.on_player_alt_selected_area, m_pilot.handle_controller)
  script.on_event(defines.events.on_player_reverse_selected_area, m_pilot.handle_controller)
  script.on_event(defines.events.on_player_selected_area, m_pilot.handle_controller)
  script.on_event(defines.events.on_player_created, m_pilot.new_player)
  script.on_event(defines.events.on_gui_click, m_pilot.on_gui_click)
  script.on_event(defines.events.on_player_joined_game, m_pilot.player_connected)
  script.on_event(defines.events.on_tick, m_pilot.pre_run)
  script.on_event(defines.events.on_script_path_request_finished, m_pilot.update_factorio_paths)
  script.on_event(defines.events.on_runtime_mod_setting_changed, m_pilot.update_settings)
end

function m_pilot.new_player(p_data)
  local player = game.players[p_data.player_index]

  m_gui.add_launcher(player)
end

function m_pilot.on_gui_click(p_data)
  if p_data.element.name == "ember_launcher" then
    local player = game.players[p_data.player_index]

    if player.can_insert { name = "ember-controller" } then
      player.insert { name = "ember-controller" }
      m_debug.print(player, "Ember controller given.")
    else
      m_debug.print_error(player, "No inventory space left for the Ember controller.")
    end
  end
end

function m_pilot.player_connected(p_data)
  local player = game.players[p_data.player_index]

  if not m_gui.has_launcher(player) then
    m_gui.add_launcher(player)
  end
end

function m_pilot.pre_run(p_data)
  for _, e_player in pairs(game.players) do
    if not m_gui.has_launcher(e_player) then
      m_gui.add_launcher(e_player)
    end
  end

  script.on_event(defines.events.on_tick, m_pilot.run)
end

function m_pilot.process_data(p_player, p_agent)
  local problem = p_agent.data.problem

  if problem then
    if not problem.done then
      if problem.type == "path" then
        if problem.strategy == "path-bfs" or problem.strategy == "path-dfs" then
          m_search.search_path_blind(p_player, p_agent, p_player.mod_settings["ember-nodes-per-tick"].value)
        elseif problem.strategy == "path-ucs" or problem.strategy == "path-greedy" then
          m_search.search_path_informed(p_player, p_agent, p_player.mod_settings["ember-nodes-per-tick"].value)
        end
      end

      problem.passes = problem.passes + 1
    end
  end
end

function m_pilot.run(p_data)
  local player
  local action

  m_render.clear()

  for iPlayer, agent in pairs(m_agents.activeAgents) do
    player = game.players[iPlayer]
    m_pilot.process_data(player, agent)
    action = agent.execute(player, agent.params)
    m_actions[action.type](player, agent, action.params)
    m_render.render_debug_layer(player, agent)
  end
end

function m_pilot.update_factorio_paths(p_data)
  -- Search the associated agent.
  for i_player, e_agent in pairs(m_agents.activeAgents) do
    -- If the search finished.
    if (p_data.id == e_agent.data.pathID) and (not p_data.try_again_later) then
      -- Set the path info.
      if p_data.path then
        e_agent.params.pathReady = true
        e_agent.data.path = p_data.path
        m_debug.print_verbose(game.players[i_player], "Pilot: Path found.")
      else
        e_agent.params.noPath = true
      end
    end
  end
end

function m_pilot.update_settings(p_data)
  local player = game.players[p_data.player_index]

  if p_data.setting == "ember-movement-mode" then
    if player.mod_settings[p_data.setting].value == "path-built-in" then
      m_debug.print_warning(player, "WARNING: This pathfinder routes through collidable entities!")
    elseif player.mod_settings[p_data.setting].value == "path-dfs" then
      m_debug.print_warning(player, "WARNING: Use the unrestricted version of Depth First Search with caution!")
    end
  end
end

return m_pilot
