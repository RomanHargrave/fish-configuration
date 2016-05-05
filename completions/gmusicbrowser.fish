#!/usr/bin/env fish

function __fish_gmusicbrowser_list_commands
    if not set -q __fish_gmusicbrowser_commands
        set -g __fish_gmusicbrowser_commands (gmusicbrowser -listcmd ^/dev/null | grep -P '^[^\s]+(?=\s+:)' | sed -r 's/\s+:\s/ : /')
    end
    printf '%s\n' $__fish_gmusicbrowser_commands
end

function __fish_gmusicbrowser_list_options
    if not set -q __fish_gmusicbrowser_options
        set -g __fish_gmusicbrowser_options (gmusicbrowser -help ^/dev/null | grep -P '^[-+][^\s]+' | sed -r 's/\s+:\s+/ : /')
    end
    printf '%s\n' $__fish_gmusicbrowser_options
end

function __fish_gmusicbrowser_complete
    complete -c gmusicbrowser $argv
end

function __fish_gmusicbrowser_option
    set option $argv[1]; set -e argv[1]
    __fish_gmusicbrowser_complete -o $option $argv
end

function __fish_gmusicbrowser_command
    set command $argv[1]; set -e argv[1]
    __fish_gmusicbrowser_option cmd -f -a $command $argv
end

for option in (__fish_gmusicbrowser_list_options)
    set option_preamble     (echo $option | cut -d : -f1)
    set option_name         (echo $option_preamble | cut -d , -f1 | grep -Po '(?<=[-+])[^\s]+')
    set option_description  (echo $option | cut -d : -f2- | sed -r 's/^\s+//;s/\s+$//')
    switch $option
        case '-*'
            # Handle the -X ARG, -ex arg arrangement
            if echo $option_preamble | grep -q ','
                # Has short and long version
                set option_name_long (echo $option_preamble | cut -d , -f2 | grep -Po '(?<=[-+])[^\s]+')
                __fish_gmusicbrowser_option "$option_name_long" -s "$option_name" --description "$option_description"
            else
                # Just long version
                __fish_gmusicbrowser_option "$option_name" --description "$option_description"
            end
        case '+*'
            __fish_gmusicbrowser_complete -a "+$option_name" --description "$option_description"
    end
end

for command in (__fish_gmusicbrowser_list_commands)
    set command_name        (echo $command | cut -d : -f1 | sed -r 's/^\s+//;s/\s+$//')
    set command_description (echo $command | cut -d : -f2- | sed -r 's/^\s+//;s/\s+$//')

    __fish_gmusicbrowser_command "$command_name" --description "$command_description"
end
