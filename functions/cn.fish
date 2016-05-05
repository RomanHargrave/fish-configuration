function cn --description "Rename files (named cn so as to avoid being close to rm)"
	if test (count $argv) = 2

		set -l path (realpath $argv[1])
		set -l dir (dirname $argv[1])
		set -l name (basename $argv[1])
		set -l new $argv[2]

		mv "$dir/$name" "$dir/$new"
		return $status

	else
		echo "Usage: rn <file> <new name>"
		return 1
	end

end
