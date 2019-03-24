set -g  FISH_HOME   $HOME/.config/fish
set -gx fish_custom $FISH_HOME/extensions
set -gx LFIX    $HOME/.local

# Tell fish to use colons to separate elements when reporting the vars
mark_exportable CLASSPATH PKG_CONFIG_PATH GEM_PATH

# Default apps
set -gx TERM    xterm-256color
set -gx BROWSER chromium
set -gx EDITOR  vim

# System resource locators

# Erase LD/PATH contents so we can repopulate them 
set -e LD_LIBRARY_PATH
set -e PATH

conf.ldadd  /usr/lib{,x86{,_64}}-linux-gnu /usr/local/lib /usr/local/cuda/lib{32,64} $LFIX/lib 
conf.padd   $LFIX/bin $LFIX/games /{,s}bin /usr{,/local}/{,s}bin /usr{,/local}/games

# Other software
set -gx PYTHONPATH /usr/local/python
#set -gx QT_QPA_PLATFORMTHEME qt5ct
#
## Chromium/Debian extension support fix
set -x CHROMIUM_FLAGS "--enable-remote-extensions"
