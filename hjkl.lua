-- mod-version:3
-- Copyright (c) 2023 Ashwin Godbole

local keymap = require "core.keymap"
local command = require "core.command"
local style = require "core.style"
local common = require "core.common"
local translate = require "core.doc.translate"
local doc = require "core.doc"
local docview = require "core.docview"
local core = require "core"

-- create a storage area to house the default 'EDIT' keymap
local edit_map = keymap.map
local edit_reverse_map = keymap.reverse_map

-- create a storage area to house the new 'HJKL' keymap
local hjkl_map = {}
local hjkl_reverse_map = {}

-- change keymap's 'map' and 'reverse_map' to refer to the hjkl map so that we can add bindings to it
keymap.map = hjkl_map
keymap.reverse_map = hjkl_reverse_map

-- add the relevant bindings to our 'keymap' reference (to the hjkl map)
keymap.add({
  ["left"] = { "doc:move-to-previous-char", "dialog:previous-entry" },
  ["right"] = { "doc:move-to-next-char", "dialog:next-entry"},
  ["up"] = { "command:select-previous", "doc:move-to-previous-line" },
  ["down"] = { "command:select-next", "doc:move-to-next-line" },
  ["h"] = { "doc:move-to-previous-char", "dialog:previous-entry" },
  ["j"] = { "command:select-next", "doc:move-to-next-line" },
  ["k"] = { "command:select-previous", "doc:move-to-previous-line" },
  ["l"] = { "doc:move-to-next-char", "dialog:next-entry"},

  ["ctrl+left"] = "doc:move-to-previous-word-start",
  ["ctrl+right"] = "doc:move-to-next-word-end",
  ["shift+h"] = "doc:move-to-previous-word-start",
  ["shift+l"] = "doc:move-to-next-word-end",
  ["b"] = "doc:move-to-previous-word-start",
  ["w"] = "doc:move-to-next-word-end",

  ["["] = "doc:move-to-previous-block-start",
  ["]"] = "doc:move-to-next-block-end",
  ["0"] = "doc:move-to-start-of-indentation",
  ["shift+4"] = "doc:move-to-end-of-line",
  ["ctrl+a"] = "doc:move-to-start-of-indentation",
  ["ctrl+e"] = "doc:move-to-end-of-line",
  
  ["ctrl+home"] = "doc:move-to-start-of-doc",
  ["ctrl+end"] = "doc:move-to-end-of-doc",
  ["pageup"] = "doc:move-to-previous-page",
  ["pagedown"] = "doc:move-to-next-page",

  ["shift+a"] = "hjkl:append-to-line",
  ["shift+d"] = "doc:delete-to-end-of-line",
  ["shift+f"] = "hjkl:delete-line",

  ["shift+k"] = "doc:select-to-previous-line",
  ["shift+j"] = "doc:select-to-next-line",  

  ["u"] = "doc:undo",
  ["r"] = "doc:redo",

  ["ctrl+s"] = "doc:save",
  ["i"] = "hjkl:toggle",
  ["alt+w"] = "hjkl:toggle",
})

-- restore the keymap's 'map' and 'reverse_map' to refer to the default map and the default reverse_map
keymap.map = edit_map
keymap.reverse_map = edit_reverse_map

-- create a command that can be called to toggle the hjkl bindings
command.add("core.docview!", {
  ["hjkl:toggle"] = function()
    if keymap.map == edit_map then
      core.log("MOTIONS")
      style.caret_width = common.round(style.font:get_size() * 0.75 * SCALE)
      keymap.map = hjkl_map
      keymap.reverse_map = hjkl_reverse_map
    else
      core.log("EDIT")
      style.caret_width = common.round(2 * SCALE)
      keymap.map = edit_map
      keymap.reverse_map = edit_reverse_map
    end
  end
})

-- Some keybindings cannot be represented by a single builtin lite-xl command
-- so we create a custom command that is composes existing ones to produce 
-- the desired behavior.
command.add("core.docview!", {
  ["hjkl:append-to-line"] = function()
    command.perform("doc:move-to-end-of-line")
    command.perform("hjkl:toggle")
  end,
  
  ["hjkl:delete-line"] = function()
    command.perform("doc:move-to-start-of-line")
    command.perform("doc:delete-to-end-of-line")
    command.perform("doc:delete")
  end
})

-- add the keybinding to enable switching (to the default 'EDIT' keymap)
keymap.add({
  ["alt+w"] = "hjkl:toggle",
  ["ctrl+e"] = "doc:move-to-end-of-line",
  ["ctrl+a"] = "doc:move-to-start-of-indentation",
})

local DocView = require "core.docview"
local old_on_text_input = DocView.on_text_input

-- Disable input while in MOTIONS mode
function DocView:on_text_input(...)
  if keymap.map == hjkl_map then
    return
  end
  return old_on_text_input(self, ...)
end
