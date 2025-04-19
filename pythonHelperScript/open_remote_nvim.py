#!/usr/bin/env python

import os
import subprocess
import sys
import argparse
from typing import List


from root_utils import FsDirPathStr, FsFilePathStr, get_session_file

DEFAULT_RSM = "default"  # Default session name


command = [
    "nvim",
    "--listen",
    f"/tmp/nvim_session_socket_{DEFAULT_RSM}",
    "--cmd",
    f"autocmd VimEnter * NvimPossessionLoadOrCreate '{DEFAULT_RSM}'",
]
# Will cause a problem where one lsp will not be properly attached.


def open_nvim(files: List[FsFilePathStr], remote_session_name: str = DEFAULT_RSM):
    # Get the project root from the get_project_root function

    session_file = get_session_file(remote_session_name)
    # Prepare the command to run Neovim

    if os.path.exists(session_file):
        # If session exists, load it
        print(f"Loading session from {session_file}")
        command = [
            "nvim",
            "--listen",
            f"/tmp/nvim_session_socket_{remote_session_name}",
            "--cmd",
            f"source {session_file}",  # Load the session
            "--cmd",
            f"let g:session_name='{remote_session_name}'",  # Set the session name
        ]
    else:
        # If session does not exist, create it
        print(f"Session not found. Creating new session at {session_file}")
        command = [
            "nvim",
            "--listen",
            f"/tmp/nvim_session_socket_{remote_session_name}",
            "--cmd",
            f"mksession! {session_file}",  # Create the new session
            "--cmd",
            f"let g:session_name='{remote_session_name}'",  # Set the session name
        ]

    if files:
        # If files are provided, add them to the command
        print(f"Neovim started with socket: /tmp/nvim_session_socket_{remote_session_name} on files: {', '.join(files)}")
        command.extend(files)
    else:
        # No files provided
        print(f"Neovim started with socket: /tmp/nvim_session_socket_{remote_session_name} with no files")

    # Run Neovim
    subprocess.run(command, check=True)

    return 0


if __name__ == "__main__":
    # Create the parser
    parser = argparse.ArgumentParser(
        description="Open Neovim with session management.", formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    # This will include default values in the help message)

    # Add the --name argument for specifying the session name
    parser.add_argument("--name", type=str, default=DEFAULT_RSM, help="Name of the session (default: 'default')")

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
