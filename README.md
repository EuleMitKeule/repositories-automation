# Repository Automation with Ansible

This project automates the creation and management of GitHub repositories using Ansible. It provides a declarative approach to ensure GitHub repositories exist with the desired configuration, topics, and files.

## 🎯 Purpose

Automate GitHub repository management tasks including:
- Creating new repositories with specific configurations
- Updating existing repository settings
- Managing repository topics/tags
- Deploying standardized files (like LICENSE) to repositories
- Maintaining consistent repository settings across multiple projects

## 📋 Features

- **Repository Creation**: Automatically create GitHub repositories if they don't exist
- **Settings Management**: Configure repository settings like privacy, branch protection, merge options
- **Topic Management**: Set and update repository topics/tags
- **File Deployment**: Deploy template files (like LICENSE) to repositories
- **Vault Integration**: Secure handling of secrets using Ansible Vault
- **Batch Operations**: Manage multiple repositories at once

## 🏗️ Project Structure

```
├── ansible.cfg              # Ansible configuration
├── inventory.yml            # Inventory of repositories to manage
├── requirements.yml         # Ansible Galaxy collections
├── site.yml                # Main playbook
├── vault_password.txt       # Vault password file (gitignored)
├── group_vars/
│   └── all.yml             # Global variables
├── host_vars/              # Repository-specific variables
│   ├── example-custom-integration.yml
│   └── example-python-package.yml
├── roles/
│   ├── github_repository/          # Repository creation/management
│   ├── github_repository_tags/     # Topic/tag management
│   └── repository_files/           # File deployment
├── files/
│   └── all/
│       └── LICENSE.j2.md   # Template files to deploy
├── secrets/
│   ├── github.vault.yml    # Encrypted GitHub credentials
│   └── id_rsa.vault        # Encrypted SSH key
├── filter_plugins/
│   └── vault_fallback.py   # Custom filter for vault file handling
└── scripts/
    ├── install_requirements.sh
    ├── deploy_all.sh
    ├── encrypt_all_secrets.sh
    └── decrypt_all_secrets.sh
```

## 🚀 Quick Start

### Prerequisites

- Python 3.x
- Ansible
- GitHub Personal Access Token with repository permissions
- SSH key for Git operations (optional)

### Setup

1. **Install Ansible requirements:**
   ```bash
   ./scripts/install_requirements.sh
   ```

2. **Configure secrets:**
   - Create `secrets/github.yml` with your GitHub credentials:
     ```yaml
     github_username: "your-username"
     github_token: "your-personal-access-token"
     ```
   - Encrypt the secrets:
     ```bash
     ./scripts/encrypt_all_secrets.sh
     ```

3. **Define your repositories:**
   - Add repository entries to `inventory.yml`
   - Create corresponding host variable files in `host_vars/`

4. **Deploy:**
   ```bash
   ./scripts/deploy_all.sh
   ```

## 📝 Configuration

### Repository Definition

Each repository is defined as a host in `inventory.yml` and configured via host variables:

**inventory.yml:**
```yaml
all:
  hosts:
    my-awesome-project:
    another-repository:
```

**host_vars/my-awesome-project.yml:**
```yaml
repo_description: "An awesome project repository"
repo_private: false
repo_topics:
  - "python"
  - "automation"
  - "awesome"
```

### Repository Settings

Default repository settings are defined in `roles/github_repository/defaults/main.yml`:

- `repo_private`: Repository visibility (default: true)
- `repo_has_issues`: Enable issues (default: true)
- `repo_has_wiki`: Enable wiki (default: true)
- `repo_default_branch`: Default branch name (default: "master")
- `repo_delete_branch_on_merge`: Auto-delete branches after merge
- Security features (secret scanning, etc.)

### File Templates

Template files in `files/all/` are deployed to all repositories. Use Jinja2 templating:

```markdown
# MIT License

Copyright {{ ansible_date_time.year }} {{ license_copyright_holder }}
...
```

## 🔐 Security

### Vault Management

The project uses Ansible Vault for secure credential storage:

- **Encrypt secrets:** `./scripts/encrypt_all_secrets.sh`
- **Decrypt secrets:** `./scripts/decrypt_all_secrets.sh`
- **Vault password:** Store in `vault_password.txt` (ensure it's gitignored)

### Vault Fallback Filter

The custom `vault_fallback` filter automatically selects between encrypted (`.vault`) and plain versions of files:

```yaml
vars_files:
  - "{{ 'secrets/github.yml' | vault_fallback }}"
```

This loads `secrets/github.vault.yml` if it exists, otherwise `secrets/github.yml`.

## 🎮 Available Tasks

Run predefined tasks using VS Code or the command line:

- **📦 Install Ansible requirements** - Install required Ansible collections
- **🔓 Decrypt all secrets** - Decrypt vault files for editing
- **🔐 Encrypt all secrets** - Encrypt sensitive files
- **🚀 Deploy all stacks** - Run the complete deployment

## 🔧 Roles

### github_repository
Creates and configures GitHub repositories using the GitHub API.

### github_repository_tags
Manages repository topics/tags for better organization and discoverability.

### repository_files
Deploys template files from the `files/` directory to repositories via Git operations.

## 📊 Example Use Cases

1. **Open Source Project Management**: Maintain consistent settings across multiple OSS repositories
2. **Template Repository Creation**: Quickly spin up new projects with standard configurations
3. **Organization Standards**: Enforce repository settings and file standards across teams
4. **Bulk Updates**: Update settings or deploy files to multiple repositories simultaneously

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with your own repositories
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🔍 Troubleshooting

### Common Issues

1. **Authentication Errors**: Ensure your GitHub token has the necessary permissions
2. **Repository Not Found**: Check that the repository name in inventory matches the actual repository
3. **Vault Errors**: Verify vault password and encrypted file integrity
4. **SSH Key Issues**: Ensure SSH key is properly configured for Git operations

### Debug Mode

Run with verbose output:
```bash
ansible-playbook site.yml -vvv
```

## 📚 Additional Resources

- [Ansible Documentation](https://docs.ansible.com/)
- [GitHub API Documentation](https://docs.github.com/en/rest)
- [Ansible Vault Guide](https://docs.ansible.com/ansible/latest/user_guide/vault.html)
