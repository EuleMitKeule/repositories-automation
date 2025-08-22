#!/bin/bash
set -euo pipefail

echo "🔐 Encrypting all non-.vault files and removing plaintext versions..."

find ./secrets -type f ! -name "*.vault*" | while read -r dec_file; do
  dir="$(dirname "$dec_file")"
  base="$(basename "$dec_file")"

  if [[ "$base" == *.* ]]; then
    # Insert .vault before extension
    name="${base%.*}"
    ext="${base##*.}"
    enc_file="$dir/${name}.vault.${ext}"
  else
    # No extension, just add .vault
    enc_file="$dec_file.vault"
  fi

  echo "🔐 $dec_file → $enc_file"
  ansible-vault encrypt --output "$enc_file" "$dec_file"
  rm -f "$dec_file"
done

echo "✅ All files encrypted and plaintext versions removed."
