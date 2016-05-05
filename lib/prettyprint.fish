# Pretty print tools

# Width to use when tput is not available for whatever reason. With a 13pt font a 1920px-wide screen is ~239 columns without a scrollbar
set -q fish_pretty_print_default_width; or set -g fish_pretty_print_default_width 120

function prettyprint.strip_control -d 'Strip control characters, to prevent wc from counting them'
    sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g'
end

function prettyprint.get_term_width -d 'Get the terminal width'
    if which tput > /dev/null
        tput cols
    else
        echo $fish_pretty_print_default_width
    end
end

function prettyprint.print_list_cr -d 'Output argv separated by newlines'
    printf '%s\n' $argv
end

function prettyprint.tabulate
    if not count $argv > /dev/null
        read -az argv
    end

    set __maxlen    (prettyprint.print_list_cr $argv | prettyprint.strip_control | wc -L)
    set __cols      (math (prettyprint.get_term_width) / $__maxlen | xargs printf '%d')

    for n in (seq $__cols)
        printf '- '
    end | read __paste

    printf '%s\n' $argv | eval "paste -d '|' $__paste" | column -s '|' -t -n
end
