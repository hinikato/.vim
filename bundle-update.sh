#!/bin/bash
# Allows iterate over directories.
vim_dir_path=~/.vim
input_dir_path=$vim_dir_path/bundle
find $input_dir_path -maxdepth 1 -type d -name "*" | while read submodule_dir_path ; do
  if [ -d "$submodule_dir_path/.git" ]; then
    cd $submodule_dir_path
    git checkout master
    git pull
  fi
done
cd $vim_dir_path
echo "Please revise the changes and do: git add . && git commit -am \"Updated submodules.\""
git status
