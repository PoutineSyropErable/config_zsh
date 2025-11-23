#!/usr/bin/env python3
import os
import mimetypes

# -------------------------
# CONFIG: what to count
# -------------------------

# Extensions considered programming files
PROGRAMMING_EXT = {
    ".c",
    ".h",
    ".cpp",
    ".hpp",
    ".cc",
    ".hh",
    ".rs",
    ".py",
    ".js",
    ".ts",
    ".java",
    ".go",
    ".lua",
    ".sh",
    ".rb",
    ".php",
    ".s",
    ".asm",
    ".toml",
    ".json",
}

# Always ignore these
IGNORE_EXT = {".idx", ".iso", ".o", ".bin", ".log"}

# Always ignore these *specific file names*
IGNORE_FILES = {"compile_commands.json"}

# -------------------------
# Helpers
# -------------------------


def is_binary(path):
    """Return True if file appears binary."""
    try:
        with open(path, "rb") as f:
            chunk = f.read(8000)
            if b"\0" in chunk:
                return True
    except:
        return True
    return False


def is_programming_file(path):
    """Decide if file should be counted."""
    _, ext = os.path.splitext(path)

    # Hard exclusion
    if ext.lower() in IGNORE_EXT:
        return False

    # Whitelisted programming extensions
    if ext.lower() in PROGRAMMING_EXT:
        return True

    # Fallback to MIME type
    mime, _ = mimetypes.guess_type(path)
    if mime is None:
        return False

    # Text files that could contain code
    if mime.startswith("text/"):
        return True

    return False


def count_lines(file_path):
    try:
        with open(file_path, "r", errors="ignore") as f:
            return sum(1 for _ in f)
    except:
        return 0


# -------------------------
# Directory scanning
# -------------------------


def scan_dir(path, visited):
    tree = {}
    total = 0
    real_path = os.path.realpath(path)

    if real_path in visited:
        return tree, 0
    visited.add(real_path)

    for entry in os.scandir(path):
        if entry.name.startswith("."):
            continue

        full_path = entry.path

        try:
            if entry.is_dir(follow_symlinks=False):
                sub_tree, sub_total = scan_dir(full_path, visited)
                tree[entry.name] = {"type": "dir", "tree": sub_tree, "total": sub_total}
                total += sub_total

            elif entry.is_file(follow_symlinks=False):
                if not is_programming_file(full_path):
                    continue

                # Ignore specific filenames
                if entry.name in IGNORE_FILES:
                    continue

                if is_binary(full_path):
                    continue

                n = count_lines(full_path)
                tree[entry.name] = {"type": "file", "lines": n}
                total += n

        except OSError:
            continue

    return tree, total


# -------------------------
# Printing
# -------------------------


def print_tree(tree, indent=0):
    for name, info in sorted(tree.items(), key=lambda x: (-x[1].get("total", x[1].get("lines", 0)), x[0])):

        if info["type"] == "file":
            print("  " * indent + f"{info['lines']} {name}")
        else:
            print("  " * indent + f"{info['total']} {name}/")
            print_tree(info["tree"], indent + 1)


# -------------------------
# Main
# -------------------------

if __name__ == "__main__":
    root = "."
    tree, total = scan_dir(root, visited=set())
    print_tree(tree)
    print(f"{total} TOTAL")
