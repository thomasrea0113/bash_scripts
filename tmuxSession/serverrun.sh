#!/bin/bash

if tmux has-session -t test &>/dev/null; then
	tmux kill-session -t test
fi

rm -f /tmp/sterr
mkfifo /tmp/sterr

tmux new-session -ds test sh -c './testTmux.sh 2>/tmp/sterr; tmux kill-session -t test'
tmux split-window -ht test.0 
tmux send-keys -t test.1 "s(){ tmux send-keys -t test.0 \"\$(echo \"\${@:1}\")\" ENTER; }" ENTER 'clear' ENTER
tmux split-window -t test.0 cat /tmp/sterr

tmux attach -t test.1
