#!/bin/bash
echo "LAUNCH VAGRANT INSTALL"
vagrant up

echo "UPDATING KUBE CONFIG"
cat "./sync/configRancher" > ~/.kube/config

echo "Set up is now ready ! You can use k9s tool for an easier use"