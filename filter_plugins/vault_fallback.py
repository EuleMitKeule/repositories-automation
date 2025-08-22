import os
import re
from pathlib import Path

def vault_fallback(path: str):
    project_root = os.path.dirname(__file__)  # filter_plugins/
    project_root = os.path.abspath(os.path.join(project_root, ".."))  # go to project root

    match = re.match(r"^(.*?)(\.[^./\\]+)$", path)
    if match:
        plain = os.path.join(project_root, match.group(1) + match.group(2))
        vault = os.path.join(project_root, match.group(1) + ".vault" + match.group(2))
    else:
        plain = os.path.join(project_root, path)
        vault = os.path.join(project_root, path + ".vault")

    for candidate in [plain, vault]:
        if os.path.exists(candidate):
            return candidate

    raise FileNotFoundError(f"No decrypted or encrypted version of: {path} found in {project_root}.")

class FilterModule(object):
    def filters(self):
        return {
            'vault_fallback': vault_fallback
        }
