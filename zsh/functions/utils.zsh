# Utility functions

function set_win_title() {
    echo -ne "\033]0; $(basename "$PWD") \007"
}

## cleans mem cache
memclean() {
  if sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"; then
    echo "Memory cache successfully cleaned."
  else
    echo "Failed to clean memory cache. Check permissions."
  fi
}

pdfzf() {
  RG_PREFIX='rga -t pdf -i -0 --files-with-matches'
  FZF_DEFAULT_COMMAND="$RG_PREFIX '' ." \
  fzf --ansi --read0 --phony -q "" \
      --bind "change:reload:$RG_PREFIX {q} ." \
      --preview 'rga -t pdf -i --pretty --context 5 {q} -- {}' \
      --preview-window 'right,60%,wrap' \
      --keep-right \
}
