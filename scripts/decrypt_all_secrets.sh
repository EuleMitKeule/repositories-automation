#!/bin/bash
set -euo pipefail

echo "🔓 Decrypting all .vault files and removing encrypted versions..."

find ./secrets -type f -name "*.vault*" | while read -r enc_file; do
  dec_file="${enc_file/.vault/}"
  echo "🔓 $enc_file → $dec_file"
  ansible-vault decrypt --output "$dec_file" "$enc_file"
  rm -f "$enc_file"
done

echo "✅ All files decrypted and encrypted originals removed."
