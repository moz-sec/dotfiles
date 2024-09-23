# dotfiles

[![Check](https://github.com/moz-sec/dotfiles/actions/workflows/check.yaml/badge.svg?event=push)](https://github.com/moz-sec/dotfiles/actions/workflows/check.yaml)

This repository contains configuration files.

## Setup

```bash
git clone git@github.com:moz-sec/dotfiles.git
cd dotfiles
./install.sh
```

<!-- You can also retrieve setup.sh from the Internet and run it as is, as follows. -->

<!-- ```bash
curl -o - https://raw.githubusercontent.com/moz-sec/dotfiles/main/install.sh | bash
``` -->

## Configuration File

```bash
$ tree -a -I ".git|.gitignore|.github|README.md|install.sh"
.
├── .bash_profile
├── .bashrc
├── .git-completion.bash
├── .git-prompt.sh
├── .gitconfig
└── .vimrc

1 directory, 6 files
```

### Bash

- [.bash_profile](https://github.com/moz-sec/dotfiles/blob/main/.bash_profile)
- [.bashrc](https://github.com/moz-sec/dotfiles/blob/main/.bashrc)

### Git

- [.gitconfig](https://github.com/moz-sec/dotfiles/blob/main/.gitconfig)
- [.git-prompt.sh](https://github.com/moz-sec/dotfiles/blob/main/.git-prompt.sh)
- [.git-completion.bash](https://github.com/moz-sec/dotfiles/blob/main/.git-completion.bash).

## Author

[@moz-sec](https://github.com/moz-sec)
