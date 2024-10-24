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
local m_config = require("__ember-autopilot__/modules/config")
local m_controller = require("__ember-autopilot__/modules/controller")
local m_debug = require("__ember-autopilot__/modules/debug")
local m_events = require("__ember-autopilot__/modules/events")
local m_gui = require("__ember-autopilot__/modules/gui")
local m_render = require("__ember-autopilot__/modules/render")
local m_search = require("__ember-autopilot__/modules/search")

function m_pilot.catch_drops(p_data)
  local player = game.players[p_data.player_index]

  if p_data.entity.stack then
    if p_data.entity.stack.name == "ember-controller" then
      p_data.entity.destroy()
      m_debug.print(player, "The Ember controller vanished.")
    end
  end
end

function m_pilot.init()
  m_events.register("on_player_selected_area", m_controller.on_left_select)
  m_events.register("on_player_alt_selected_area", m_controller.on_left_shift_select)
  m_events.register("on_player_reverse_selected_area", m_controller.on_right_select)
  m_events.register("on_player_alt_reverse_selected_area", m_controller.on_right_shift_select)

  m_events.register("on_player_dropped_item", m_pilot.catch_drops)
  m_events.register("on_player_created", m_pilot.new_player)
  m_events.register("on_gui_click", m_pilot.on_gui_click)
  m_events.register("on_player_joined_game", m_pilot.player_connected)
  m_events.register("on_tick", m_pilot.pre_run)
  m_events.register("on_script_path_request_finished", m_search.update_factorio_paths)
  m_events.register("on_runtime_mod_setting_changed", m_config.update)
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

  m_events.register("on_tick", m_pilot.run)
end

function m_pilot.process_data(p_player, p_agent)
  local problem = p_agent.data.problem

  if problem then
    if not problem.done then
      if problem.type == "path" then
        if problem.strategy == "path_bfs" or problem.strategy == "path_dfs" then
          m_search.search_path_blind(p_player, p_agent, p_player.mod_settings["ember-nodes-per-tick"].value)
        elseif problem.strategy == "path_ucs" or problem.strategy == "path_greedy" or problem.strategy == "path_astar" then
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

return m_pilot
