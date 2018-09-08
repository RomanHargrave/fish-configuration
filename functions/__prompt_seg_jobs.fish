function __prompt_seg_jobs
	set -l _jc (count (jobs))
test $_jc -gt 0; and echo $_jc
end
