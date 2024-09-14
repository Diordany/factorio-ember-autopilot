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
local m_buffer = {}

function m_buffer.pairing_heap_add_child(p_tree, p_child)
  p_child.sibling = p_tree.child
  p_tree.child = p_child
  p_tree.child.parent = p_tree
end

function m_buffer.pairing_heap_insert(p_heap, p_element, p_key)
  local node = { key = p_key, value = p_element }

  p_heap.root = m_buffer.pairing_heap_merge(p_heap.root, node)

  return node
end

function m_buffer.pairing_heap_merge(p_treeA, p_treeB)
  if not p_treeA then
    return p_treeB
  end

  if not p_treeB then
    return p_treeA
  end

  if p_treeA.key < p_treeB.key then
    m_buffer.pairing_heap_add_child(p_treeA, p_treeB)

    return p_treeA
  else
    m_buffer.pairing_heap_add_child(p_treeB, p_treeA)

    return p_treeB
  end
end

function m_buffer.pairing_heap_pop(p_heap)
  local minElement = p_heap.root

  if minElement then
    local root = minElement.child
    local temp

    minElement.child = nil

    if root then
      root.parent = nil

      while root.sibling do
        if root.key < root.sibling.key then
          root.sibling.parent = root
          temp = root.sibling.sibling
          root.sibling.sibling = root.child
          root.child = root.sibling
          root.sibling = temp
        else
          root.sibling.parent = root.parent
          root.parent = root.sibling
          root.sibling = root.parent.child
          root.parent.child = root
          root = root.parent
        end

        if root.sibling then
          root.sibling.parent = root
          root = root.sibling
        else
          break
        end
      end

      while root.parent do
        if root.key < root.parent.key then
          root.parent.sibling = root.child
          root.child = root.parent
          root.parent = root.child.parent
          root.child.parent = root
        else
          root.sibling = root.parent.child
          root.parent.child = root
          root = root.parent
        end
      end
    end

    p_heap.root = root
  end

  return minElement
end

-- WARNING: Only use this if the new key is lower than the current one.
function m_buffer.pairing_heap_update(p_heap, p_node)
  if p_heap.root ~= p_node then
    if p_node == p_node.parent.child then
      p_node.parent.child = p_node.sibling
      p_node.parent = nil
    else
      local prev = p_node.parent.child

      while prev.sibling do
        if prev.sibling == p_node then
          break
        end

        prev = prev.sibling
      end

      p_node.parent = nil
      prev.sibling = p_node.sibling
      p_node.sibling = nil
    end
  end

  p_heap.root = m_buffer.pairing_heap_merge(p_heap.root, p_node)
end

return m_buffer
