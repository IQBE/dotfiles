#!/usr/bin/env python3

#########################################################################
#                   ╔═══════════════════════════════╗                   #
#                   ║ formatNames.py - FORMAT FILES ║                   #
#                   ╚═══════════════════════════════╝                   #
#   This script is used to format strings to my preferred format        #
#                                                                       #
#   The format for files is as follows:                                 #
#   - The first character of the file name is lowercase                 #
#   - The first character of every word in the file name is uppercase   #
#   - All spaces and underscores are removed                            #
#   - The file extension is left as is                                  #
#                                                                       #
#   The format for directories is as follows:                           #
#   - The first character of the directory is uppercase                 #
#   - The first character of every word in the dir name is uppercase    #
#   - All spaces and underscores are removed                            #
#                                                                       #
#   Note:                                                               #
#   Hidden files and dirs (names starting with a .) are ignored         #
#                                                                       #
#   Examples:                                                           #
#   - 'my file_name.txt' -> 'myFileName.txt'                            #
#   - 'File name withCAPS.MP4' -> 'fileNameWithCAPS.MP4'                #
#   - 'my_foldername' -> 'MyFoldername'                                 #
#                                                                       #
#   Simple Usage:                                                       #
#   - formatNames.py [directory]                                        #
#   - If no directory is provided, the current directory is used        #
#                                                                       #
#   Options:                                                            #
#     -h, --help: Show help message                                     #
#     -f, --files_only: Format only files                               #
#     -d, --dirs_only: Format only directories                          #
#     -t, --target: Target specific files/directories to format         #
#     -x, --regex: Format only files/directories that follow a regex    #
#     -y, --yes: Automatically answer yes to all prompts                #
#     -r, --recursive: Format files in subdirectories recursively       #
#     -q, --quiet: Suppress output                                      #
#     -o, --output: Output to a log file                                #
#                                                                       #
#   Planned features:                                                   #
#   - Add the ability to have different formats                         #
#                                                                       #
#   Author: IQBE                                                        #
#                                                                       #
#########################################################################

import os
import sys
import argparse
import time
import re
from datetime import datetime

characters_to_remove = [' ', '_']
args = None

def argparser() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        prog='formatNames',
        description='Format files to my preferred format',
        epilog='Author: IQBE'
    )

    parser.add_argument(
        'directory',
        nargs='?',
        default='.',
        help='Directory to format files in'
    )
    parser.add_argument(
        '-f',
        '--files_only',
        action='store_true',
        help='Format only files'
    )
    parser.add_argument(
        '-d',
        '--dirs_only',
        action='store_true',
        help='Format only directories'
    )
    parser.add_argument(
        '-t',
        '--target',
        nargs='+',
        help='Target specific files/directories to format'
    )
    parser.add_argument(
        '-x',
        '--regex',
        help='Format only files/directories that follow a regex'
    )
    parser.add_argument(
        '-y',
        '--yes',
        action='store_true',
        help='Automatically answer yes to all prompts'
    )
    parser.add_argument(
        '-r',
        '--recursive',
        action='store_true',
        help='Format files in subdirectories recursively'
    )
    parser.add_argument(
        '-q',
        '--quiet',
        action='store_true',
        help='Suppress output'
    )
    parser.add_argument(
        '-o',
        '--output',
        help='Output to a file instead of stdout'
    )

    args = parser.parse_args()
    return args

def init_logger() -> None:
    if args.output:
        with open(args.output, 'w') as f:
            f.write(f'LOG FOR formatNames.py\n[DIRECTORY]: {os.path.abspath(args.directory)}\n[DATETIME]: {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}\n\n')

def logger(msg: str, also_print: bool = False) -> None:
    if not args.quiet:
        if not args.output or also_print:
            print(msg)
        if args.output:
            with open(args.output, 'a') as f:
                f.write(msg + '\n')

def format_string(s: str, type: str = 'file') -> str:
    if s.startswith('.'):
        logger(s +' is hidden and will not be formatted')
        return s

    new_sf_characters = []
    sf_char = []
    sp = ''
    sb = ''

    if type == 'file':
        if '.' in s:
            sf, sp, sb = s.rpartition('.')
        else:
            sf = s

        sf_char = list(sf)
        sf_char[0] = sf_char[0].lower()

        next_char_upper = False

    elif type == 'dir':
        sf_char = list(s)
        next_char_upper = True

    for character in sf_char:
        if character in characters_to_remove:
            next_char_upper = True
            continue
        elif next_char_upper:
            new_sf_characters.append(character.upper())
        else:
            new_sf_characters.append(character)
        next_char_upper = False

    new_string = ''.join(new_sf_characters)
    if type == 'file':
        new_string += sp + sb

    return new_string

def format_files(files: list) -> list:
    new_files = []
    for file in files:
        path, sep, file = file.rpartition(os.sep)
        new_files.append(path + sep + format_string(file))
    return new_files

def format_dirs(dirs: list) -> list:
    new_dirs = []
    for directory in dirs:
        path, sep, directory = directory.rpartition(os.sep)
        new_dirs.append(path + sep + format_string(directory, 'dir'))
    return new_dirs

def get_files_in_directory(directory: str) -> list:
    files = []
    for file in os.listdir(directory):
        if args.regex and not re.search(args.regex, file):
            logger(f'{file} does not match the regex and will not be formatted')
            continue
        file_location = os.path.join(directory, file)
        if os.path.isfile(file_location):
            files.append(file_location)
        elif args.recursive and os.path.isdir(file_location):
            if not file.startswith('.'):
                files += get_files_in_directory(file_location)
            else :
                logger(f'{file} is hidden and will not be formatted')
    return files

def get_dirs_in_direcotry(direcotry: str) -> list:
    dirs = []
    for folder in os.listdir(direcotry):
        if args.regex and not re.search(args.regex, folder):
            logger(f'{folder} does not match the regex and will not be formatted')
            continue
        folder_location = os.path.join(direcotry, folder)
        if os.path.isdir(folder_location) and not folder.startswith('.'):
            dirs.append(folder_location)
            if args.recursive:
                dirs += get_dirs_in_direcotry(folder_location)

    return dirs

def rename_file(file: str, new_file: str) -> None:
    logger(f'Renaming file: "{file}" -> "{new_file}"')
    try:
        os.rename(file, new_file)
    except FileExistsError:
        logger(f'Error renaming file "{file}": File "{new_file}" already exists', also_print=True)
    except FileNotFoundError:
        logger(f'Error renaming file "{file}": File "{file}" not found', also_print=True)
    except Exception as e:
        logger(f'Error renaming file "{file}": {e}', also_print=True)

def rename_dir(directory: str, new_directory: str) -> None:
    logger(f'Renaming directory: "{directory}" -> "{new_directory}"')
    os.rename(directory, new_directory)

def rename_files(files: list, new_files: list) -> None:
    for i in range(len(files)):
        rename_file(files[i], new_files[i])

def rename_dirs(dirs: list, new_dirs: list) -> None:
    for i in range(len(dirs)):
        rename_dir(dirs[i], new_dirs[i])

def format_directory(directory: str) -> None:
    if not args.dirs_only:
        files = get_files_in_directory(directory)
        new_files = format_files(files)
        rename_files(files, new_files)

    if not args.files_only:
        dirs = get_dirs_in_direcotry(directory)[::-1] # Reverse the list so that the path is not changed before renaming
        new_dirs = format_dirs(dirs)
        rename_dirs(dirs, new_dirs)

def format_targets(targets: list) -> None:
    if not args.target:
        format_directory(targets[0])
    else:
        for target in targets:
            format_target(target)

def format_target(target: str) -> None:
    path, sep, file = target.rpartition(os.sep)

    if file.startswith('.'):
        logger(f'{file} is hidden and will not be formatted')
        return

    if os.path.isfile(target) and not args.dirs_only:
        new_file_name = format_string(file)
        new_file = path + sep + new_file_name
        rename_file(target, new_file)
    elif os.path.isdir(target) and not args.files_only:
        new_dir_name = format_string(file)
        new_dir = path + sep + new_dir_name
        rename_dir(target, new_dir)

def form_question(targets: list) -> str:
    if args.target:
        return 'Are you sure you want to format the specified files/directories? [y/N] '

    question = 'Are you sure you want to format the '
    if args.files_only:
        question += 'files'
    elif args.dirs_only:
        question += 'directories'
    else:
        question += 'files and directories'
    question += f' in {targets[0]}{ " recursively" if args.recursive else "" }? [y/N] '

    return question

def check_and_transform(value: str) -> None:
    if os.path.exists(value):
        return os.path.abspath(value)
    else:
        logger(f'{value} does not exist', also_print=True)
        sys.exit(1)

def check_inputs() -> list:
    targets = []

    if args.recursive and args.target:
        logger('Cannot use --recursive and --target together', also_print=True)
        sys.exit(1)

    if args.regex and args.target:
        logger('Cannot use --regex and --target together', also_print=True)
        sys.exit(1)

    if args.target:
        for target in args.target:
            targets.append(check_and_transform(target))
    else:
        targets.append(check_and_transform(args.directory))

    return targets

if __name__ == '__main__':
    args = argparser()

    init_logger()
    targets = check_inputs()

    if not args.yes:
        answer = input(form_question(targets))
    if args.yes or answer.lower() == 'y':
        tic = time.perf_counter()
        format_targets(targets)
        toc = time.perf_counter()
        logger(f'Name formatting completed ({toc - tic:0.3f}s)', also_print=True)
