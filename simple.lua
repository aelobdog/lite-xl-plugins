-- mod-version:2 -- lite-xl 2.0

-- Copyright (c) 2022 Ashwin Godbole
-- MIT LICENSE

-- the "core" module
local core = require "core"

-- the "command" module will help us register commands for our plugin.
local command = require "core.command"

-- the "style" module will allow us to use default styling options
local style = require "core.style"

-- the "config" module will be used to store certain things like colors
-- and functions
local config = require "core.config"

-- the "keymap" module will allow us to set keybindings for our commands
local keymap = require "core.keymap"
-----------------------------------------------------------------------
-- colors are just three comma separated values (RGB) (range 0 - 255)
-- put inside of '{ }'. We will add our color to the config module.

config.text_color = {200, 140, 220}
-----------------------------------------------------------------------
-- Let's create a function to calculate the coordinates of our text.
-- While we're at it, let's add out function to the `config` module.
-- We'll take the message we want to display as the argument to the
-- function to determine the x and y coordinates of the text.

function config.get_text_coordinates(message)
   -- For this plugin, we want to display the text on the top right
   -- corner of the screen. For this, we need to know the editor's width
   -- and height.
   
   -- The current font's size can be obtained from the "style" module.
   -- The editor's dimensions can be obtained by
   --   1. WIDTH  : core.root_view.size.x
   --   2. HEIGHT : core.root_view.size.y

   local message_width = style.code_font:get_width(message.." ")
   local font_height = style.code_font:get_size()
   local x = core.root_view.size.x - message_width
   local y = font_height / 2

   return x, y
end
-----------------------------------------------------------------------
-- Let's now get to actually drawing the text inside the editor.
-- The first thing we'll do is override the `parent` draw function from
-- `core.root_view`. We'll call it `parent_draw` for the time being.

local parent_draw = core.root_view.draw

-- Now let's overload the original definition of `draw` in the
-- `core.root_view` module by redefining the function in the core module.

core.root_view.draw = function(...)
   -- We call the parent's function to keep the editor functional...
   -- obviously we must still draw all the other stuff !
   -- So we call the `parent_draw` function before doing anything else.
   parent_draw(...)

   -- we'll add an option to toggle the message on and off. let's use a
   -- boolean variable to keep track of whether we want to display the
   -- message or not. 
   if config.show_my_message then
      -- We'll be getting the message to display as input from the user
      -- later. We'll store that user input in `config.hw_message`.
      -- (NOTE: this variable does not come in-built in lite-xl;
      --        it is a variable that we will create later.)
      
      -- let's store the value of config.hw_message in a local variable
      -- `message` in case config.hw_message we set the message to
      -- "message not set yet!"
      local message
      
      if config.hw_message then
	 message = config.hw_message
      else
	 message = "Message not set yet !"
      end

      -- let's get the coordinates for our text
      local x, y = config.get_text_coordinates(message)

      -- let's finally draw the text to the window !
      -- the draw_text function from `renderer` is an important function
      -- as it is used to display any and all text inside of the editor
      -- window
      renderer.draw_text(style.code_font, message, x, y, config.text_color)
   end 
end
-----------------------------------------------------------------------
-- Let's allow the user to turn the message on and off
-- we'll write a function to flip our "show" boolean variable.

local function toggle_helloworld()
   config.show_my_message = not config.show_my_message
end
-----------------------------------------------------------------------
-- Finally, let's add the toggle function to the command list so that
-- we can call it from the C-S-p command panel. Let's add one command
-- to toggle the visibility of the message on and off and one to get
-- the user's message and then display it.

command.add(nil, {
   -- Toggle the visibility of the message
   ["simple:toggle"] = toggle_helloworld,

   -- Set and show the message
   -- This is the way to get user input through the command bar.
   -- `core.command_view:enter` takes 2 arguments:
   --    * the prompt to display before taking input
   --    * a function that takes the "input" as its argument
   -- (NOTE: here the variable we are reading input into is `text`)
   ["simple:setshow"] = function()
      core.command_view:enter("Test to display", function(text)
         config.hw_message = text
         config.show_my_message = true
      end)
   end
})
-----------------------------------------------------------------------
-- Just for fun, let's assign our commands their own keybindings.
-- Here, we assign the keybinding the same string(its name) as the one
-- that we set while creating the command
keymap.add {
   ["alt+s"] = "simple:setshow",
   ["alt+t"] = "simple:toggle",
}
