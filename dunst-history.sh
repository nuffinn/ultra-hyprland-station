#!/bin/bash
# Display dunst notification history in rofi

THEME="$HOME/.config/rofi/notification-history.rasi"

# Get full history as JSON
json=$(dunstctl history)

# Build display list (excluding system notifications)
# Format: index|appname|summary (truncated for display)
mapfile -t entries < <(echo "$json" | jq -r '
    .data[0] | to_entries[] |
    select(.value.appname.data != "volume" and .value.appname.data != "brightness" and .value.appname.data != "mic") |
    "\(.key)|\(.value.appname.data)|\(.value.summary.data)"
' 2>/dev/null)

if [ ${#entries[@]} -eq 0 ]; then
    rofi -dmenu -p " Notifications" -mesg "No notifications in history" -theme "$THEME" < /dev/null
    exit 0
fi

# Create display list
display=""
for entry in "${entries[@]}"; do
    idx=$(echo "$entry" | cut -d'|' -f1)
    app=$(echo "$entry" | cut -d'|' -f2)
    summary=$(echo "$entry" | cut -d'|' -f3-)
    display+="$idx [$app]  $summary"$'\n'
done

# Show list and get selection
selected=$(echo -n "$display" | rofi -dmenu -i -p " Notifications" -no-custom -theme "$THEME")

if [ -n "$selected" ]; then
    # Extract index from selection
    idx=$(echo "$selected" | awk '{print $1}')

    # Get full notification details
    full=$(echo "$json" | jq -r --argjson i "$idx" '
        .data[0][$i] |
        "App: \(.appname.data)\nSummary: \(.summary.data)\n\nBody:\n\(.body.data // "No body")"
    ' 2>/dev/null)

    # Display full content using dunstify
    dunstify -t 0 -a "notification-history" -u normal \
        "$(echo "$json" | jq -r --argjson i "$idx" '.data[0][$i] | "[\(.appname.data)] \(.summary.data)"')" \
        "$(echo "$json" | jq -r --argjson i "$idx" '.data[0][$i] | .body.data // "No body"')"
fi
