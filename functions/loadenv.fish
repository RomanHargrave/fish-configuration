function loadenv
    for file in $argv
        for line in (cat $file | grep -P '^(export\s)?[^#\s]+=.*$')
            set var_name (echo $line | cut -d= -f1)
            set var_value (echo $line | cut -d= -f2-)
            set -gx $var_name $var_value 
        end
    end
end

