#!/bin/bash
SSH_KEY_TYPE="id_ed25519"
SSH_KEY_PATH="confs/$SSH_KEY_TYPE"

if [ ! -s $SSH_KEY_PATH ];then
    ssh-keygen -o -a 100 -t ed25519 -C "$HOSTNAME" -f "$SSH_KEY_PATH" <<< y
fi
