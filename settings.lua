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
data:extend({
  {
    type = "bool-setting",
    name = "ember-verbose",
    order = "c",
    setting_type = "runtime-per-user",
    default_value = false
  },
  {
    type = "string-setting",
    name = "ember-movement-mode",
    order = "a",
    setting_type = "runtime-per-user",
    default_value = "walk",
    allowed_values = { "walk", "path-bfs", "path-built-in", "wander" }
  },
  {
    type = "string-setting",
    name = "ember-movement-direction-set",
    order = "b",
    setting_type = "runtime-per-user",
    default_value = "directions_4",
    allowed_values = { "directions_4", "directions_4_diagonal", "directions_8" }
  }
})
