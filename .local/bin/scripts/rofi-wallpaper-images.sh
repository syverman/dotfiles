#!/bin/bash

# WALLPAPERS PATH
terminal=kitty
wallDIR="/home/juancarlos/Imágenes/Walls/"
#SCRIPTSDIR="$HOME/.config/hypr/scripts"
#wallpaper_current="$HOME/.config/hypr/wallpaper_effects/.wallpaper_current"

# Directory for swaync
# iDIR="$HOME/.config/swaync/images"
# iDIRi="$HOME/.config/swaync/icons"

# swww transition config
FPS=60
TYPE="any"
DURATION=2
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION --transition-bezier $BEZIER"

# Check if package bc exists
if ! command -v bc &>/dev/null; then
    notify-send -i "$iDIR/error.png" "bc missing" "Install package bc first"
    exit 1
fi

# Variables
rofi_theme="$HOME/.config/rofi/wallpaper.rasi"
focused_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')

# Ensure focused_monitor is detected
if [[ -z "$focused_monitor" ]]; then
    notify-send -i "$iDIR/error.png" "E-R-R-O-R" "Could not detect focused monitor"
    exit 1
fi

# Monitor details
scale_factor=$(hyprctl monitors -j | jq -r --arg mon "$focused_monitor" '.[] | select(.name == $mon) | .scale')
monitor_height=$(hyprctl monitors -j | jq -r --arg mon "$focused_monitor" '.[] | select(.name == $mon) | .height')

icon_size=$(echo "scale=1; ($monitor_height * 3) / ($scale_factor * 150)" | bc)
adjusted_icon_size=$(echo "$icon_size" | awk '{if ($1 < 15) $1 = 20; if ($1 > 25) $1 = 25; print $1}')
rofi_override="element-icon{size:${adjusted_icon_size}%;}"

# Kill existing wallpaper daemons for image
kill_wallpaper_for_image() {
    swww kill 2>/dev/null
}

# Retrieve wallpapers (only images)
mapfile -d '' PICS < <(find -L "${wallDIR}" -type f \( \
    -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o \
    -iname "*.bmp" -o -iname "*.tiff" -o -iname "*.webp" \) -print0)

RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"
RANDOM_PIC_NAME=". random"

# Rofi command
rofi_command="rofi -i -show -dmenu -config $rofi_theme -theme-str $rofi_override"

# Sorting Wallpapers
menu() {
    IFS=$'\n' sorted_options=($(sort <<<"${PICS[*]}"))

    printf "%s\x00icon\x1f%s\n" "$RANDOM_PIC_NAME" "$RANDOM_PIC"

    for pic_path in "${sorted_options[@]}"; do
        pic_name=$(basename "$pic_path")
        if [[ "$pic_name" =~ \.gif$ ]]; then
            cache_gif_image="$HOME/.cache/gif_preview/${pic_name}.png"
            if [[ ! -f "$cache_gif_image" ]]; then
                mkdir -p "$HOME/.cache/gif_preview"
                magick "$pic_path[0]" -resize 1920x1080 "$cache_gif_image"
            fi
            printf "%s\x00icon\x1f%s\n" "$pic_name" "$cache_gif_image"
        else
            printf "%s\x00icon\x1f%s\n" "$(echo "$pic_name" | cut -d. -f1)" "$pic_path"
        fi
    done
}

# Apply Image Wallpaper
apply_image_wallpaper() {
    local image_path="$1"

    kill_wallpaper_for_image

    if ! pgrep -x "swww-daemon" >/dev/null; then
        echo "Starting swww-daemon..."
        swww-daemon --format xrgb &
    fi

    swww img -o "$focused_monitor" "$image_path" $SWWW_PARAMS

    # Run additional scripts
    # "$SCRIPTSDIR/WallustSwww.sh"
    # sleep 2
    # "$SCRIPTSDIR/Refresh.sh"
    sleep 1
}

# Main function
main() {
    choice=$(menu | $rofi_command)
    choice=$(echo "$choice" | xargs)
    RANDOM_PIC_NAME=$(echo "$RANDOM_PIC_NAME" | xargs)

    if [[ -z "$choice" ]]; then
        echo "No choice selected. Exiting."
        exit 0
    fi

    # Handle random selection correctly
    if [[ "$choice" == "$RANDOM_PIC_NAME" ]]; then
        choice=$(basename "$RANDOM_PIC")
    fi

    choice_basename=$(basename "$choice" | sed 's/\(.*\)\.[^.]*$/\1/')

    # Search for the selected file in the wallpapers directory, including subdirectories
    selected_file=$(find "$wallDIR" -iname "$choice_basename.*" -print -quit)

    if [[ -z "$selected_file" ]]; then
        echo "File not found. Selected choice: $choice"
        exit 1
    fi

    # Apply wallpaper
    apply_image_wallpaper "$selected_file"
}

# Check if rofi is already running
if pidof rofi >/dev/null; then
    pkill rofi
fi

main

exit 0

