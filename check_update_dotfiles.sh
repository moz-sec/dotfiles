#!/usr/bin/env bash

dotfiles_home="$HOME/dotfiles"

status_output=$(git -C "${dotfiles_home}" status --porcelain)

if test -n "$status_output" ||
  ! git -C "${dotfiles_home}" diff --exit-code --stat --cached origin/main >/dev/null; then
  echo -e "\033[1;34m=== DOTFILES IS DIRTY ===\033[1;39m"
  echo -e "\033[1;33mThe dotfiles have been changed.\033[1;39m"
  echo -e "\033[1;33mPlease update them with the following command.\033[1;39m"
  echo "  $ cd ${dotfiles_home}"
  echo "  $ git add ."
  echo "  $ git commit -m \"update dotfiles\""
  echo "  $ git push origin main"
  echo -e "\033[1;34m=== GIT STATUS OUTPUT ===\033[1;39m"
  while IFS= read -r line; do
    status_code="${line:0:2}"
    file_name="${line:3}"
    case "$status_code" in
    " M" | "M ") # Modified
      echo -en "\033[1;33mModified:\033[0m "
      ;;
    "A ") # Added
      echo -en "\033[1;32mAdded:\033[0m "
      ;;
    " D" | "D ") # Deleted
      echo -en "\033[1;31mDeleted:\033[0m "
      ;;
    *) # Other
      echo -en "\033[1;37m$status_code\033[0m "
      ;;
    esac
    echo "$file_name"
  done <<<"$status_output"
  echo -e "\033[1;34m=========================\033[1;39m"
fi
