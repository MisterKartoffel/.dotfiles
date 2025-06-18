# Log out of the Bitwarden vault, for safety
if command -v bw 2>/dev/null; then
    bw logout --quiet 2>/dev/null
fi
