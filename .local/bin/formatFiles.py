#!/usr/bin/env python3

#########################################################################
#                   ╔═══════════════════════════════╗                   #
#                   ║ formatFiles.py - FORMAT FILES ║                   #
#                   ╚═══════════════════════════════╝                   #
#   This script is used to format files to my preferred format          #
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
#   Usage:                                                              #
#   - formatFiles.py <directory>                                        #
#   - If no directory is provided, the current directory is used        #
#                                                                       #
#   Planned features:                                                   #
#   - Add flags using argparse                                          #
#   - Add the ability to format files in subdirectories recursively     #
#   - Add the ability to format individual files                        #
#   - Add the ability to format individual directories                  #
#   - Add the ability to format only files/directories that follow      #
#     a regex expression                                                #
#                                                                       #
#   Author: IQBE                                                        #
#                                                                       #
#########################################################################

import os
import sys

characters_to_remove = [' ', '_']

# Function to change all the file names in a directory to the correct format
def format_string(s: str, type: str = 'file') -> str:
    if s.startswith('.'):
        return s


    new_sf_characters = []
    sf_char = []
    sb = ''

    if type == 'file':
        sf = s.rpartition('.')[0]
        sb = s.rpartition('.')[2]

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
        new_string += '.' + sb

    return new_string

def format_files(files: list) -> list:
    new_files = []
    for file in files:
        new_files.append(format_string(file))
    return new_files

def format_dirs(dirs: list) -> list:
    new_dirs = []
    for directory in dirs:
        new_dirs.append(format_string(directory, 'dir'))
    return new_dirs

def get_files_in_directory(directory: str) -> list:
    files = []
    for file in os.listdir(directory):
        if os.path.isfile(os.path.join(directory, file)):
            files.append(file)
    return files

def get_dirs_in_direcotry(direcotry: str) -> list:
    dirs = []
    for folder in os.listdir(direcotry):
        if os.path.isdir(os.path.join(direcotry, folder)):
            dirs.append(folder)
    return dirs

def rename_file(file: str, new_file: str) -> None:
    print(f'Renaming file: "{file}" -> "{new_file}"')
    os.rename(file, new_file)

def rename_dir(directory: str, new_directory: str) -> None:
    print(f'Renaming directory: "{directory}" -> "{new_directory}"')
    os.rename(directory, new_directory)

def rename_files(files: list, new_files: list) -> None:
    for i in range(len(files)):
        rename_file(files[i], new_files[i])

def rename_dirs(dirs: list, new_dirs: list) -> None:
    for i in range(len(dirs)):
        rename_dir(dirs[i], new_dirs[i])

def format_directory(directory: str) -> None:
    files = get_files_in_directory(directory)
    new_files = format_files(files)
    rename_files(files, new_files)

    dirs = get_dirs_in_direcotry(directory)
    new_dirs = format_dirs(dirs)
    rename_dirs(dirs, new_dirs)

if __name__ == '__main__':
    dir_to_format = sys.argv[1] if len(sys.argv) > 1 else '.'

    path_to_dir = os.path.abspath(dir_to_format)

    if not os.path.isdir(path_to_dir):
        print(f'{path_to_dir} is not a directory')
        sys.exit(1)

    answer = input(f'Are you sure you want to format the files and directories in {path_to_dir}? [y/N] ')
    if answer.lower() == 'y':
        format_directory(path_to_dir)
        print('Files formatted successfully')
