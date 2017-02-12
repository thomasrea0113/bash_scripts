#!/bin/bash

required="00"

dir=$(pwd)
logloc="/tmp/"
funct="s"

while getopts ":t:c:s:l:f:" opt; do
	case $opt in
		t)
			sname=$OPTARG
			required=$(echo $required | sed s/./1/1)
			;;
		c)
			dir="$OPTARG"
			if ! [[ $dir == *"/" ]]; then
				dir=$dir"/"
			fi		
			;;
		s)
			script=$OPTARG
			required=$(echo $required | sed s/./1/2)
			;;
		l)
			logloc="$OPTARG"
			if ! [[ $logloc == *"/" ]]; then
				logloc=$logloc"/"
			fi		
			;;
		f)
			funct=$OPTARG
			;;
		\?)
			echo "Invalid option: -$OPTARG." >&2
			exit 1
			;;
		:)
			echo "Option -$OPTARG requires an argument." >&2
			;;
	esac
done

if [ $required != "11" ]; then
	echo "Options -t and -s is required."
	exit 1
fi


if tmux has-session -t test &>/dev/null; then
	tmux kill-session -t test
fi

fifo="/tmp/$sname""_stderr"
stdinlog=$logloc$sname"_stdin.log"
stdoutlog=$logloc$sname"_stdout.log"
stderrlog=$logloc$sname"_stderr.log"

rm -f $fifo
mkfifo $fifo
trap "rm -f $fifo" EXIT

rm -f $stdinlog
rm -f $stdoutlog
rm -f $stderrlog

tmux new-session -ds $sname -c $dir bash -c "$script 2> >(tee $stderrlog >$fifo) | tee $stdoutlog; tmux kill-session -t $sname"
tmux split-window -ht $sname.0
tmux send-keys -t $sname.1 "$funct(){ tmux send-keys -t $sname.0 \"\$(echo \"\${@:1}\" | tee -a $stdinlog)\" ENTER; }" ENTER 'clear' ENTER
tmux split-window -t $sname.0 cat $fifo

sleep 1

tmux attach -t $sname.1
