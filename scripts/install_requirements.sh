#!/bin/bash
echo "📦 Installing Ansible Galaxy requirements..."
ansible-galaxy collection install -r requirements.yml
