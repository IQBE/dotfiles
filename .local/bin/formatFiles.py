#!/usr/bin/env python3

#########################################################################
#                   ╔═══════════════════════════════╗                   #
#                   ║ formatFiles.py - FORMAT FILES ║                   #
#                   ╚═══════════════════════════════╝                   #
#   This script is used to format files to my preferred format          #
#   The format is as follows:                                           #
#   - The first character of the file name is lowercase                 #
#   - The first character of every word in the file name is uppercase   #
#   - All spaces and underscores are removed                            #
#   - The file extension is left as is                                  #
#                                                                       #
#   Note:                                                               #
#   Hidden files (files starting with a .) are ignored                  #
#                                                                       #
#   Example:                                                            #
#   - Before: 'my file_name.txt'                                        #
#   - After: 'myFileName.txt'                                           #
#                                                                       #
#   Usage:                                                              #
#   - python3 test.py <directory>                                       #
#   - If no directory is provided, the current directory is used        #
#                                                                       #
#   Planned features:                                                   #
#   - Add the ability to format files in subdirectories recursively     #
#   - Add the ability to format individual files                        #
#                                                                       #
#   Author: IQBE                                                        #
#                                                                       #
#########################################################################


import os
import sys

characters_to_remove = [' ', '_']

# Function to change all the file names in a directory to the correct format
def format_string(s: str) -> str:
    if s.startswith('.'):
        return s

    sf = s.rpartition('.')[0]
    sb = s.rpartition('.')[2]

    sf_char = list(sf)
    sf_char[0] = sf_char[0].lower()

    new_sf_characters = []
    next_char_upper = False

    for character in sf_char:
        if character in characters_to_remove:
            next_char_upper = True
            continue
        elif next_char_upper:
            new_sf_characters.append(character.upper())
        else:
            new_sf_characters.append(character)
        next_char_upper = False

    return ''.join(new_sf_characters) + '.' + sb

def format_files(files: list) -> list:
    new_files = []
    for file in files:
        new_files.append(format_string(file))
    return new_files

def get_files_in_directory(directory: str) -> list:
    files = []
    for file in os.listdir(directory):
        if os.path.isfile(os.path.join(directory, file)):
            files.append(file)
    return files

def rename_file(file: str, new_file: str) -> None:
    print(f'Renaming {file} to {new_file}')
    os.rename(file, new_file)

def rename_files(files: list, new_files: list) -> None:
    for i in range(len(files)):
        rename_file(files[i], new_files[i])

def format_directory(directory: str) -> None:
    files = get_files_in_directory(directory)
    new_files = format_files(files)
    rename_files(files, new_files)

if __name__ == '__main__':
    dir_to_format = sys.argv[1] if len(sys.argv) > 1 else '.'

    path_to_dir = os.path.abspath(dir_to_format)

    if not os.path.isdir(path_to_dir):
        print(f'{path_to_dir} is not a directory')
        sys.exit(1)

    answer = input(f'Are you sure you want to format the files in {path_to_dir}? [y/N] ')
    if answer.lower() == 'y':
        format_directory(path_to_dir)
        print('Files formatted successfully')
