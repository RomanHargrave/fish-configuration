function fish_prompt
   set -l _last_status $status
   set -l _sep_colour 444
   set -l _jc (count (jobs))

   if not set -q -g __prompt_sorin_functions_defined
      set -g __prompt_sorin_functions_defined
   end

   if set -q __fish_prompt_split
      set_color cyan
      printf ╓
   end

   # last command exit status
   set _human_status OK
	switch $_last_status
        case 0
            set_color green
        case '*'
            set _human_status (echo (errno $_last_status; or echo ?) | string split ' ')[1]
            set_color red
    end
    printf '%s/%d' $_human_status $_last_status

   # Print active jobs, nothing if 0 jobs
   set_color cyan
   test $_jc -gt 0; and printf ' %%%d' $_jc

   set_color $_sep_colour
   printf ' : '

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
