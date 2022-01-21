-- mod-version:2 -- lite-xl 2.0

-- Copyright (c) 2022 Ashwin Godbole
-- MIT LICENSE

local syntax = require "core.syntax"

syntax.add {
  files = { "%.sfl$", "%.sitefl$" },
  patterns = {
    { pattern = "\\.",                    type = "normal"   },
    { pattern = { "`", "`", "\\" },       type = "string"   },
    { pattern = "%-%-%-+",                type = "comment" },
    { pattern = { "%*", "[%*\n]", "\\" }, type = "keyword2" },
    { pattern = { "%/", "[%/\n]", "\\" }, type = "keyword2" },
    { pattern = { "%_", "[%_\n]", "\\" }, type = "keyword2" },
    { pattern = "#.-\n",                  type = "keyword"  },
    { pattern = "!?%[.-%]%(.-%)",         type = "operator" },
    { pattern = "@?%[.-%]%(.-%)",         type = "operator" },
  },
  symbols = { },
}
