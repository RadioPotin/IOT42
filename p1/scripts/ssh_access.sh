#!/bin/bash

HOST_PUBLIC_KEY=$(cat ${HOST_PUBLIC_KEY_FILE})
if ! grep -q "${HOST_PUBLIC_KEY}" .ssh/authorized_keys; then
    echo ${HOST_PUBLIC_KEY} >> .ssh/authorized_keys
fi
VM_PUBLIC_KEY=$(cat ${VM_PUBLIC_KEY_FILE})
if ! grep -q "${VM_PUBLIC_KEY}" .ssh/authorized_keys; then
    echo ${VM_PUBLIC_KEY} >> .ssh/authorized_keys
fi
if [ ! -f .ssh/id_rsa ]; then
    cp ${VM_PRIVATE_KEY_FILE} .ssh/id_ed25519
fi
if [ ! -f .ssh/id_rsa.pub ]; then
    cp ${VM_PUBLIC_KEY_FILE} .ssh/id_ed25519.pub
fi
chmod 700 .ssh
chmod 600 .ssh/id_ed25519
chmod 644 .ssh/id_ed25519.pub
chown -R vagrant:vagrant .ssh
