#!/usr/bin/env bash

wallpapers_folder="$HOME/Pictures/wallpapers"

current_wallpaper=$(readlink "$wallpapers_folder/.current_wallpaper" 2> /dev/null)
current_wallpaper_name="$(basename "$current_wallpaper")"

wallpaper_list=${($(ls "$wallpapers_folder"))[@]/".current_wallpaper"}
wallpaper_count=${#wallpaper_list[@]}

while true; do
    wallpaper_name="${wallpaper_list[RANDOM % wallpaper_count]}"

    if [[ "$wallpaper_name" != "$current_wallpaper_name" ]]; then
        break
    fi
done

ln -sf "$wallpapers_folder/$wallpaper_name" "$wallpaper_path/wallpaper"
wall-change "$wallpaper_path/wallpaper" &
