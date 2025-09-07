#!/bin/bash

# Get clipboard text (works on Linux with xclip or wl-clipboard)
if command -v xclip &>/dev/null; then
  TEXT=$(xclip -selection clipboard -o)
elif command -v wl-paste &>/dev/null; then
  TEXT=$(wl-paste)
else
  echo "Error: No clipboard tool found (install xclip or wl-clipboard)"
  exit 1
fi

# URL-encode the text
ENCODED_TEXT=$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" "$TEXT")

# Open browser with the encoded URL
xdg-open "http://localhost:4200/tests?filter=$ENCODED_TEXT"

