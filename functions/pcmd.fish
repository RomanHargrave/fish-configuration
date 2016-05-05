function pcmd --description 'Get the full path to a process'
	for proc in /proc/$argv
        if [ -r $proc ]
            set -l cmdline (cat $proc/cmdline | tr '\0' ' ')
            echo (echo $proc | cut -d '/' -f3) (count $cmdline >/dev/null; and echo $cmdline; or echo "(none)")
        end
    end
end
