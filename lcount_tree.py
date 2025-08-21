#!/usr/bin/env python3
import os


def count_lines(file_path):
    try:
        with open(file_path, "r", errors="ignore") as f:
            return sum(1 for _ in f)
    except:
        return 0


def scan_dir(path, visited=set()):
    tree = {}
    total = 0
    real_path = os.path.realpath(path)
    if real_path in visited:
        return tree, 0  # avoid infinite recursion
    visited.add(real_path)

    for entry in os.scandir(path):
        if entry.name.startswith("."):
            continue  # skip hidden files/folders
        full_path = entry.path
        try:
            if entry.is_dir(follow_symlinks=False):
                sub_tree, sub_total = scan_dir(full_path, visited)
                tree[entry.name] = {"type": "dir", "tree": sub_tree, "total": sub_total}
                total += sub_total
            elif entry.is_file(follow_symlinks=False):
                n = count_lines(full_path)
                tree[entry.name] = {"type": "file", "lines": n}
                total += n
        except OSError:
            continue  # skip unreadable dirs/files
    return tree, total


def print_tree(tree, indent=0):
    for name, info in sorted(tree.items(), key=lambda x: (-x[1].get("total", x[1].get("lines", 0)), x[0])):
        if info["type"] == "file":
            print("  " * indent + f"{info['lines']} {name}")
        else:
            print("  " * indent + f"{info['total']} {name}/")
            print_tree(info["tree"], indent + 1)


if __name__ == "__main__":
    root = "."
    tree, total = scan_dir(root)
    print_tree(tree)
    print(f"{total} TOTAL")
