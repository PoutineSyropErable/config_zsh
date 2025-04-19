#!/usr/bin/env python

import subprocess
import sys
import argparse
import os
import glob
from typing import List

from open_remote_nvim import DEFAULT_RSM, FsFilePathStr, FsDirPathStr


def send_to_nvim(files: List[FsFilePathStr], remote_session_name: str = DEFAULT_RSM):
    # Specify the socket location for the Neovim session
    socket = f"/tmp/nvim_session_socket_{remote_session_name}"

    # If no files were provided (even after expanding wildcards), print an error
    if not files:
        print("No valid files provided. Please provide at least one file.", file=sys.stderr)
        return 1

    # Prepare the command to run Neovim
    command = ["nvim", "--server", socket, "--remote-send", f":e {files[0]}<CR>"]

    try:
        # Run the command to open the first file
        subprocess.run(command, check=True)
        print(f"Sent {files[0]} to Neovim instance at socket: {socket}")

        # For additional files, open them one by one
        for file in files[1:]:
            subprocess.run(["nvim", "--server", socket, "--remote-send", f":e {file}<CR>"], check=True)
            print(f"Sent {file} to Neovim instance at socket: {socket}")

    except subprocess.CalledProcessError as e:
        print(f"Error sending files to Neovim: {e}", file=sys.stderr)
        return 1

    return 0


def expand_files(files: List[str]) -> List[FsFilePathStr]:
    expanded_files = []
    for file in files:
        # If the file pattern contains wildcards, expand it
        expanded_files.extend(glob.glob(file))
    return expanded_files


if __name__ == "__main__":
    # Create the parser
    parser = argparse.ArgumentParser(description="Send files to a running Neovim instance.")

    # Add arguments for file and remote session name
    parser.add_argument("files", nargs="*", help="Files to send to Neovim. Supports wildcards (e.g., '*.txt').")
    parser.add_argument("--name", type=str, default=DEFAULT_RSM, help="The name of the Neovim session (default: 'default').")

    # Parse arguments
    args = parser.parse_args()

    # Expand file patterns if they contain wildcards
    files_to_send: List[FsFilePathStr] = expand_files(args.files)

    # If no files were given, show the help message and exit
    if not files_to_send:
        parser.print_help()
        sys.exit(1)

    # Call the send_to_nvim function with parsed arguments
    ret = send_to_nvim(remote_session_name=args.name, files=files_to_send)
    exit(ret)
