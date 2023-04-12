-- mod-version:3
-- Copyright (c) 2022 Ashwin Godbole

local syntax = require "core.syntax"

syntax.add {
  files = { "%.wr$", "%.wrang$" },
  patterns = {
    { pattern = "\\.",                    type = "normal"   },
    { pattern = { "`", "`", "\\" },       type = "string"   },
    { pattern = "%-%-%-+",                type = "comment"  },
    { pattern = { "%*", "[%*\n]", "\\" }, type = "keyword2" },
    { pattern = { "%/", "[%/\n]", "\\" }, type = "keyword2" },
    { pattern = { "%_", "[%_\n]", "\\" }, type = "keyword2" },
    { pattern = "#[1-6].-\n",             type = "keyword"  },
    { pattern = "!?%[.-%]%(.-%)",         type = "operator" },
    { pattern = "@?%[.-%]%(.-%)",         type = "operator" },
    { pattern = "^+",                     type = "literal"   },
  },
  symbols = { },
}
