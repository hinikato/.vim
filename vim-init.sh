#!/bin/bash
dir_path="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ln -s $dir_path/.vimrc ~/.vimrc
ln -s $dir_path/.gvimrc ~/.gvimrc
git submodule update --init
