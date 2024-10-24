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
local m_debug = {}

function m_debug.print(p_player, p_message)
  p_player.print(p_message, { skip = defines.print_skip.never })
end

function m_debug.print_error(p_player, p_message)
  p_player.print(p_message, { skip = defines.print_skip.never, color = { r = 200, g = 0, b = 0 } })
end

function m_debug.print_verbose(p_player, p_message)
  if p_player.mod_settings["ember-verbose"].value then
    p_player.print(p_message, { skip = defines.print_skip.never, color = { r = 200, g = 0, b = 200 } })
  end
end

function m_debug.print_warning(p_player, p_message)
  p_player.print(p_message, { skip = defines.print_skip.never, color = { r = 255, g = 200, b = 0 } })
end

return m_debug
