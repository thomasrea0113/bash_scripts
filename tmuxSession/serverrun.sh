#!/bin/bash

if tmux has-session -t test &>/dev/null; then
	tmux kill-session -t test
fi

rm -f /tmp/sterr
mkfifo /tmp/sterr

rm -f /tmp/stin.log
touch /tmp/stin.log

rm -f /tmp/stout.log
touch /tmp/stout.log

rm -f /tmp/sterr.log
touch /tmp/sterr.log

tmux new-session -ds test bash -c './testTmux.sh 2> >(tee /tmp/sterr.log >/tmp/sterr) | tee /tmp/stout.log; tmux kill-session -t test'
tmux split-window -ht test.0 
tmux send-keys -t test.1 "s(){ tmux send-keys -t test.0 \"\$(echo \"\${@:1}\" | tee -a /tmp/stin.log)\" ENTER; }" ENTER 'clear' ENTER
tmux split-window -t test.0 cat /tmp/sterr

tmux attach -t test.1
