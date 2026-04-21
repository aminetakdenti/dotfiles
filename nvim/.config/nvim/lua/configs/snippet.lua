local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("javascriptreact", {
  s("rnsc", {
    t({ "import { StyleSheet } from 'react-native';", "", "export const styles = StyleSheet.create({", "  " }),
    i(1, "container"),
    t({ "", "});" }),
  }),
})
