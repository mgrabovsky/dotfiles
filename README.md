This repository aims to gather my most valuable and useful configuration files in one
place so that I can (relatively) easily transfer them between machines, and save my
productivity from suffering too much from the discomfort of default configs.

The config files are currently just somewhat haphazardly tossed together in here. In
the future, I'd like to have a section here for each one, and I'd like to comment
them thoroughly.

If something is unclear or unknown, try the amazing Vim `:help` if applicable,
otherwise hit the `man` pages, which are fantastic for most of these programs.

General inspirational sources:

-   <http://dotshare.it/>
-   <http://www.dotfiles.org/>
-   [lahwaacz/dotfiles](https://github.com/lahwaacz/dotfiles)
-   [deterenkelt/dotfiles](https://github.com/deterenkelt/dotfiles)
-   [eevee/rc](https://github.com/eevee/rc)

![](http://i.creativecommons.org/p/zero/1.0/80x15.png)

---

-   [Bash](#bash)
-   [tmux](#tmux)
-   [Git](#git)
-   [Vim](#vim)
    -   [Plugins](#plugins)
-   [Copyright](#copyright)

## Bash

Yes, I'm still using Bash instead of zsh, fish or whatever the latest fad is.

There are two files for setting up the bash environment:

-   `.bash_profile`
-   `.bashrc`

## tmux

`.tmux.conf`

## Git

`.gitconfig`

## Vim

Some inspiration:

-   [Vim Tips wiki](http://vim.wikia.com/wiki/Vim_Tips_Wiki)
-   <https://github.com/br0ziliy/vim-on-steroids>
-   <http://www.dotfiles.org/~mitry/.vimrc>

NeoVim has broken the old Vim conventions and uses XDG instead, see [`:help nvim-from-vim`](https://neovim.io/doc/user/nvim_from_vim.html) for more information.

### Plugins

Here is a list of plugins that I deem to be very useful when using Vim as your main
editor in everyday work.

-   **Essential**
    -   [NERD Tree](https://github.com/scrooloose/nerdtree) – tree explorer sidebar
    -   [vim-repeat](https://github.com/tpope/vim-repeat) – allows dot-repeating of
        plugin commands
    -   [vim-surround](https://github.com/tpope/vim-surround) – easy manipulation of
        surrounding characters
-   **Nice to have**
    -   [ack.vim](https://github.com/mileszs/ack.vim) – integration with ack
    -   [airline](https://github.com/bling/vim-airline) – improved statusline
    -   [Align](https://github.com/vim-scripts/Align) – align multiple lines
        according to a regex (see also: [Tabular](https://github.com/godlygeek/tabular))
    -   [vim-colorschemes](https://github.com/flazz/vim-colorschemes) – tons of
        pretty colorschemes
    -   [fugitive](https://github.com/tpope/vim-fugitive.git) – integration with Git

## Copyright

Written since 2015 by Matěj Kolouch Grabovský <matej at mgrabovsky eu>

To the extent possible under law, the author has dedicated all copyright and related
and neighboring rights to this software to the public domain worldwide. This software
is distributed without any warranty.

You should have received a copy of the CC0 Public Domain Dedication along with this
