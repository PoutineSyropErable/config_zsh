#!/usr/bin/env python

import os
import subprocess
import sys
import argparse
from typing import List

FsDirPathStr = str
FsFilePathStr = str


def get_project_root() -> FsDirPathStr:
    # Run fpr and capture only stdout, stderr will be printed directly to the terminal
    try:
        # Running the fpr command (use the full path)
        result = subprocess.run(["/home/francois/.config/nvim/scripts/find_project_root"], capture_output=True, text=True)

        # Capture the stdout and stderr
        project_root = result.stdout.strip()  # Remove leading/trailing whitespace

        # Check if the fpr command was successful
        if result.returncode == 1:
            print("Can't find project root, fpr defaulted to pwd", file=sys.stderr)
            project_root = os.getcwd()  # Default to current working directory
        elif result.returncode != 0:
            # If fpr returned an invalid exit code (exit 2 or 3)
            print(f"Error: fpr returned an invalid exit code ({result.returncode}), exiting.", file=sys.stderr)
            raise AssertionError("Shouldn't be here. C++ code failed")

        # Check if the output is a valid directory
        if not os.path.isdir(project_root):
            print(f"Project root ({project_root}) is not a valid directory, exiting.", file=sys.stderr)
            raise AssertionError("Shouldn't be here. Not valid dir")

        return project_root  # Return the valid path

    except Exception as e:
        print(f"An error occurred while running fpr: {e}", file=sys.stderr)
        os.abort()


def get_session_file(remote_session_name: str) -> FsFilePathStr:
    project_root = get_project_root()
    if not project_root:
        print("Couldn't get project root")
        sys.exit(1)

    # Set the session directory and session file path
    session_dir = os.path.join(project_root, ".nvim-session")

    # Create the session directory if it doesn't exist
    if not os.path.exists(session_dir):
        os.makedirs(session_dir)  # This creates the directory if it doesn't exist
        print(f"Created session directory: {session_dir}")

    session_file = os.path.join(session_dir, remote_session_name)

    return session_file


def open_nvim(remote_session_name: str, files: List[FsFilePathStr]):
    # Get the project root from the get_project_root function

    session_file = get_session_file(remote_session_name)

    # Prepare the command to run Neovim
    command = [
        "nvim",
        "--listen",
        f"/tmp/nvim_session_socket_{remote_session_name}",
        "--cmd",
        f"mksession! {session_file}",
        "--cmd",
        f"let g:session_name='{remote_session_name}'",
    ]

    if files:
        # If files are provided, add them to the command
        print(f"Neovim started with socket: /tmp/nvim_session_socket_{remote_session_name} on files: {', '.join(files)}")
        command.extend(files)
    else:
        # No files provided
        print(f"Neovim started with socket: /tmp/nvim_session_socket_{remote_session_name} with no files")

    # Run Neovim
    subprocess.run(command)

    return 0


if __name__ == "__main__":
    # Create the parser
    parser = argparse.ArgumentParser(
        description="Open Neovim with session management.", formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    # This will include default values in the help message)

    # Add the --name argument for specifying the session name
    parser.add_argument("--name", type=str, default="default", help="Name of the session (default: 'default')")

    # Add a positional argument for files (accepts multiple files)
    parser.add_argument("files", nargs="*", help="Files to open in Neovim.")

    # Parse arguments
    args = parser.parse_args()

    # If no arguments are passed, print the usage
    if len(sys.argv) == 1:
        print("No files provided. Opening Neovim with default session... And showing help message in case")
        parser.print_help()

    # Call the open_nvim function with parsed arguments
    ret = open_nvim(remote_session_name=args.name, files=args.files)
    exit(ret)
