function fish-ssh-agent 
    set ssh_agent_script \
        'eval "$(ssh-agent ' $argv ')" 2>&1 >/dev/null; \
         echo "set -x SSH_AGENT_PID $SSH_AGENT_PID;";\
         echo "set -x SSH_AUTH_SOCK $SSH_AUTH_SOCK;";'

    echo $ssh_agent_script | bash -
end
