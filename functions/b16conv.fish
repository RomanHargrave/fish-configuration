function b16conv
    set bcprog "ibase=16" 
    set bcprog $bcprog (printf '%s\n' $argv | tr 'a-z' 'A-Z')

    printf '%s\n' $bcprog | bc 
end

