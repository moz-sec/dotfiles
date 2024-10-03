#!/usr/bin/env bash

set -eu

helpmsg() {
  echo "Usage: $0 [--help | -h]" 0>&2
  echo ""
}

link_to_homedir() {
  echo "backup old dotfiles..."
  if [ ! -d "$HOME/.dotbackup" ];then
    echo "$HOME/.dotbackup not found. Auto Make it"
    mkdir "$HOME/.dotbackup"
  fi

  local dotfiles_dir
  dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
  if [[ "$HOME" != "$dotfiles_dir" ]];then
    for hidden_file in "$dotfiles_dir"/.??*; do
      [[ $(basename "$hidden_file") == ".git" ]] && continue
      # Delete symbolic links if they exist.
      # If just a file exists, back it up.
      if [[ -L "$HOME/$(basename "$hidden_file")" ]];then
        rm -f "$HOME/$(basename "$hidden_file")"
      elif [[ -e "$HOME/$(basename "$hidden_file")" ]];then
        mv "$HOME/$(basename "$hidden_file")" "$HOME/.dotbackup"
      fi
      ln -snf "$hidden_file" "$HOME"
    done
  else
    echo "Install source and destination are the same, skipping..."
  fi
}

while [ $# -gt 0 ];do
  case ${1} in
    --debug|-d)
      set -uex
      ;;
    --help|-h)
      helpmsg
      exit 1
      ;;
    *)
      ;;
  esac
  shift
done

link_to_homedir

echo -e '\033[1;32mInstall completed!!!!\033[0;39m'
