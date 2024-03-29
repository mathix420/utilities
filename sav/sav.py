#!/usr/bin/env python3

import os
import yaml
import subprocess

from datetime import datetime
from os.path import expanduser, exists, join

DEFAULT_CONFIG_PATH = '~/.config/sav.yml'
DEFAULT_DESTINATION_PATH = '/tmp/sav'
EMAIL = 'agissing@student.42.fr'
NAME = 'Arnaud Gissinger'

CLEAN_ARGS = ['/usr/bin/env', 'clean']


def get_config(path):
    """
    This function will return the config tree,
    or raise an error if the config path is not accessible.
    """
    path = expanduser(path)

    if not exists(path):
        raise Exception('No such file or directory.')

    with open(path) as fp:
        return yaml.safe_load(fp)


def build_backup(dest, targets):
    """
    This function will put all targets in the backup destination.

    Params:
        - dest : string : destination path of the backup
        - targets : list : list all targeted files
    """
    for target in targets:
        if isinstance(target, dict):
            target, out = target.popitem()
            out = out[0]
        else:
            out = target.strip('/').split('/')[-1]
        out = join(dest, expanduser(out))
        target = expanduser(target)

        args = ['-r'] if os.path.isdir(target) else []

        # Creating parent folders if needed
        parent_folders = '/'.join(out.split('/')[:-1])
        subprocess.call(['mkdir', '-p', parent_folders])

        if os.path.isdir(target):
            subprocess.call(['rm', '-rf', out])

        subprocess.call(['cp', *args, target, out])


def main(config, dest, clean=False):
    conf_dict = get_config(config)
    subprocess.call(['mkdir', '-p', dest])

    for remote, targets in conf_dict.items():
        name = remote.split('/')[-1].replace('.git', '')
        sub_dest = os.path.join(dest, name)

        subprocess.call(['git', 'clone', remote, sub_dest])
        build_backup(sub_dest, targets)
        subprocess.call(['git', 'config', '--local', 'user.email', EMAIL], cwd=sub_dest)
        subprocess.call(['git', 'config', '--local', 'user.name', NAME], cwd=sub_dest)

        if clean:
            subprocess.call(CLEAN_ARGS, cwd=sub_dest)

        subprocess.call(['git', 'add', '.'], cwd=sub_dest)
        subprocess.call(['git', 'commit', '-m', f'[AUTO-COMMIT] {datetime.now()}'], cwd=sub_dest)
        subprocess.call(['git', 'push', 'origin', 'master'], cwd=sub_dest)

    subprocess.call(['rm', '-rf', dest])


def reverse(config, dest):
    print('TODO!')


if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument('-c', '--config-file',
                        default=DEFAULT_CONFIG_PATH, help='path of the yaml config file.')
    parser.add_argument('-d', '--dest-path',
                       default=DEFAULT_DESTINATION_PATH, help='temp destination path.')
    parser.add_argument('-x', '--clean', action='store_true',
                        help='execute the clean command before pushing files.')
    parser.add_argument('-r', '--reverse', action='store_true')
    options = parser.parse_args()

    if options.reverse:
        reverse(options.config_file, options.dest_path)
    else:
        main(options.config_file, options.dest_path, options.clean)
