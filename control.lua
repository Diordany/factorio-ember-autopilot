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
local m_commands = require("__ember-autopilot__/modules/commands")
local m_pilot = require("__ember-autopilot__/modules/pilot")

m_commands.register(require("__ember-autopilot__/commands/controller"))
m_commands.register(require("__ember-autopilot__/commands/path"))
m_commands.register(require("__ember-autopilot__/commands/proto"))
m_commands.register(require("__ember-autopilot__/commands/stop"))
m_commands.register(require("__ember-autopilot__/commands/walkpos"))
m_commands.register(require("__ember-autopilot__/commands/walkrel"))
m_commands.register(require("__ember-autopilot__/commands/wander"))

m_pilot.init()
