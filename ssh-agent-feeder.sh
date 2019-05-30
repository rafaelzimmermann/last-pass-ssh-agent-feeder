#!/usr/bin/env bash

set -e

source .config

lpass login $lastpass_username

if ! ps -p $SSH_AGENT_PID > /dev/null; then
    eval `ssh-agent -s`
fi
unique_ids=$(lpass ls --color=never $lastpass_sshgroup | sed -nr 's/^.*id:.([0-9]+).*$/\1/p')

for unique_id in $unique_ids; do
    private_key=$(lpass show --field="Private Key" $unique_id)
    SSH_ASKPASS_FOR=$unique_id DISPLAY=":0.0" SSH_ASKPASS="$PWD/ssh_askpass.sh" setsid ssh-add - <<< "${private_key}"
done
