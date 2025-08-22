#!/bin/bash
./scripts/install_requirements.sh || exit 1
echo "🚀 Deploying all stacks..."
ansible-playbook site.yml
