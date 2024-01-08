-- Mappings

nnoremap(
  "<leader>fR",
  "<cmd>lua require('spectre').open_visual({select_word=true})<cr>",
  "Search and replace current word"
)
vnoremap(
  "<leader>fR",
  "<cmd>lua require('spectre').open_visual({select_word=false})<cr>",
  "Search and replace current word"
)
