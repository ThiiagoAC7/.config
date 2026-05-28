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

discordupdate() {
    URL="https://discord.com/api/download/stable?platform=linux&format=deb"
    FILE_NAME="/tmp/discord.deb"

    echo "Fetching the latest version from Discord servers..."
    curl -L "$URL" -o "$FILE_NAME"

    echo "Installing/Updating Discord..."
    sudo dpkg -i "$FILE_NAME"

    # 3. Cleanup
    echo "Removing the temporary installer..."
    rm "$FILE_NAME"

    echo "--- Discord is up to date! ---"
}

appimageinstall() {
    if [[ $# -ne 1 ]]; then
        echo "usage: appimageinstall <path-to-appimage>"
        return 1
    fi

    if [[ $EUID -ne 0 ]]; then
        sudo zsh -c "$(declare -f appimageinstall); appimageinstall ${(q)@}"
        return $?
    fi

    local appimage_path="$1"
    if [[ ! -f "$appimage_path" ]]; then
        echo "error: file not found: ${appimage_path}"
        return 1
    fi

    local filename
    filename=$(basename "$appimage_path")

    local app_name
    app_name="${filename%.[Aa][Pp][Pp][Ii][Mm][Aa][Gg][Ee]}"
    app_name="${app_name%-x86_64}"
    app_name="${app_name%-amd64}"
    app_name="${app_name%-x86}"
    app_name="${app_name%-i386}"
    app_name="${app_name%-aarch64}"
    app_name="${app_name%-arm64}"
    app_name=$(echo "$app_name" | tr '[:upper:]' '[:lower:]')

    local target_dir="/opt/${app_name}"
    local desktop_file="/usr/share/applications/${app_name}.desktop"

    echo "creating installation directory at ${target_dir}..."
    mkdir -p "$target_dir"

    echo "copying and setting permissions..."
    cp "$appimage_path" "${target_dir}/${app_name}.AppImage"
    chmod +x "${target_dir}/${app_name}.AppImage"

    echo "extracting icon from appimage..."
    cd "$target_dir" || return 1
    "./${app_name}.AppImage" --appimage-extract "*.png" > /dev/null 2>&1

    local found_icon
    found_icon=$(find squashfs-root -maxdepth 3 -name "*.png" | head -n 1)

    local icon_path
    if [[ -n "$found_icon" ]]; then
        mv "$found_icon" "${target_dir}/icon.png"
        icon_path="${target_dir}/icon.png"
    else
        echo "no icon found; using default system icon"
        icon_path="system-run"
    fi

    rm -rf squashfs-root

    echo "generating desktop menu entry..."
    cat > "$desktop_file" <<EOF
[Desktop Entry]
Name=${app_name}
Type=Application
Exec=${target_dir}/${app_name}.AppImage
Icon=${icon_path}
Terminal=false
Categories=Utility;
Comment=${app_name} AppImage
EOF

    echo "installation finished successfully"
}
