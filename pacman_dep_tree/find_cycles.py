#!/usr/bin/env python3
import subprocess
from collections import defaultdict

def get_installed_packages():
    result = subprocess.run(['pacman', '-Qq'], capture_output=True, text=True, check=True)
    return result.stdout.strip().splitlines()

def get_dependencies(pkg):
    try:
        result = subprocess.run(['pactree', '-u', pkg], capture_output=True, text=True, check=True)
        lines = result.stdout.strip().splitlines()
        return [line.strip() for line in lines[1:]]  # skip self
    except subprocess.CalledProcessError:
        return []

def build_graph(packages):
    graph = defaultdict(list)
    for pkg in packages:
        graph[pkg] = get_dependencies(pkg)
    return graph

def find_cycles(graph):
    visited = set()
    stack = set()
    path = []
    cycles = []

    def dfs(node):
        if node in stack:
            start = path.index(node)
            cycles.append(path[start:] + [node])
            return
        if node in visited:
            return

        visited.add(node)
        stack.add(node)
        path.append(node)

        for dep in graph.get(node, []):
            dfs(dep)

        stack.remove(node)
        path.pop()

    for node in graph:
        if node not in visited:
            dfs(node)

    return cycles

def main():
    print("\U0001f50d Building dependency graph...")
    pkgs = get_installed_packages()
    graph = build_graph(pkgs)
    print("\U0001f501 Searching for dependency cycles...")
    cycles = find_cycles(graph)

    if not cycles:
        print("\u2705 No dependency cycles found.")
    else:
        print(f"\u26a0\ufe0f Found {len(cycles)} cycles:")
        for i, cycle in enumerate(cycles, 1):
            print(f"Cycle {i}: {' \u2192 '.join(cycle)}")

if __name__ == "__main__":
    main()

