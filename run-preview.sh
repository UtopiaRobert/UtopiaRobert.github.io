#!/usr/bin/env bash
set -e

HERE="$(cd "$(dirname "$0")" && pwd)"
HERO="$HERE/images/DSCF3891.JPG"

if [ ! -f "$HERO" ]; then
  echo "Looking for DSCF3891.JPG on this computer..."
  FOUND="$(
    find \
      /mnt/fieldstation/Archive \
      /home/robert/Boulder_Gardens \
      /home/robert/Downloads \
      -type f -iname 'DSCF3891.JPG' -print -quit 2>/dev/null || true
  )"

  if [ -n "$FOUND" ]; then
    cp -p "$FOUND" "$HERO"
    echo "Found and copied hero photo:"
    echo "  $FOUND"
  else
    echo
    echo "I could not automatically find DSCF3891.JPG."
    echo "The preview will still run, but the hero image will be blank."
    echo "Copy DSCF3891.JPG into:"
    echo "  $HERE/images/"
    echo
  fi
fi

PORT=5610

if ! pgrep -f "python3 -m http.server $PORT" >/dev/null 2>&1; then
  cd "$HERE"
  nohup python3 -m http.server "$PORT" > "$HERE/preview-server.log" 2>&1 &
  sleep 1
fi

URL="http://localhost:$PORT/"
xdg-open "$URL" >/dev/null 2>&1 &

echo
echo "Naturalist Journal homepage preview opened:"
echo "  $URL"
echo
echo "Nothing has been published to GitHub."
