# Repository Files Role

This role automatically syncs files and templates from the `files/` directory to GitHub repositories based on Ansible's variable precedence rules.

## How it works

The role processes files in the `files/` directory using the following precedence (highest to lowest):

1. `files/{{ inventory_hostname }}/path/to/file` - Host-specific files
2. `files/all/path/to/file` - Files that apply to all hosts

For each repository (host), the role:
1. Clones the repository to a temporary directory
2. Finds all files in the `files/` directory structure
3. For each file, determines which version to use based on precedence
4. Processes templates (`.j2` files) using Ansible's template engine or copies regular files
5. Commits all changes in a single commit
6. Pushes the changes back to the repository
7. Cleans up the temporary directory

## Template Support

Files containing `j2` in their filename are processed as Jinja2 templates. The role will:
- Process the template using Ansible's `template` module
- Remove the `j2` component from the final filename
- Make all Ansible variables available to the template

**Supported template naming patterns:**
- `filename.j2` → `filename` (e.g., `LICENSE.j2` → `LICENSE`)
- `filename.j2.ext` → `filename.ext` (e.g., `LICENSE.j2.md` → `LICENSE.md`)
- `j2.filename.ext` → `filename.ext` (e.g., `j2.LICENSE.md` → `LICENSE.md`)

All patterns produce the same result - the `j2` component is stripped from the final filename.

## Required Variables

The role expects the following variables to be defined for each host:

- `github_repo_ssh_url`: SSH URL of the GitHub repository
- `github_default_branch`: Default branch name (defaults to 'main')

## Required Secrets

You need to ensure that:

1. SSH key authentication is set up for accessing GitHub repositories
2. The SSH key has write access to the repositories
3. Git configuration is properly set up (the role sets user.name and user.email automatically)

## File Structure Example

```
files/
├── all/
│   ├── .github/
│   │   └── FUNDING.yml
│   ├── LICENSE.j2.md           # Template processed with current year → LICENSE.md
│   └── README.md
└── example-python-package/
    ├── .github/
    │   └── FUNDING.yml         # This will override the one in all/
    └── j2.LICENSE.md           # Host-specific license template → LICENSE.md
```

## Customization

You can customize the following variables:

- `repo_files_commit_message`: Commit message (default: "chore: automatic update via ansible")
- `repo_files_base_path`: Base path for files (default: "{{ playbook_dir }}/files")
- `repo_temp_dir`: Temporary directory for cloning (default: "/tmp/ansible-repo-{{ inventory_hostname }}")

## Template Variables

Templates have access to all Ansible variables. Common variables used in templates:

- `license_copyright_holder`: Copyright holder name for LICENSE templates (configure in `group_vars/all.yml`)
- `ansible_date_time.year`: Current year (automatically available)
