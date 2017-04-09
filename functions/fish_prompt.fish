function fish_prompt

    set _last_status $status
    set -l _sep_colour 444

	if not set -q -g __prompt_sorin_functions_defined
		set -g __prompt_sorin_functions_defined
	end

    if set -q __fish_prompt_split
        set_color cyan
        printf ╓
    end

    switch $_last_status
        case 0
            set_color green
        case '*'
            set_color red
    end

    printf 'E%d'(set_color $_sep_colour)' : ' $_last_status

    # extra functions to call and insert in to the prompt
    __fish_breadcrumbs_print (set_color $_sep_colour)' : '

    # SSH
	if set -q SSH_TTY
        printf (set_color red)(whoami)(set_color white)'@'(set_color yellow)(hostname)' '
    end

    # root warning
    if [ $USER = 'root' ]
        printf (set_color red)"#"
    end

    # prompt_pwd
    set_color cyan
    printf (prompt_pwd) 

    # split-line prompt?
    if set -q __fish_prompt_split
        set_color cyan
        printf \n╙
    end

    # Main
	echo -n (set_color red)'❯'(set_color yellow)'❯'(set_color green)'❯ '
end
