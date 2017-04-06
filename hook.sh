#!/bin/bash

cd .git/hooks
wget https://gist.githubusercontent.com/Desgard/f2c34e4586eb92d50a6a10d0cac7dc0a/raw/61e51756b5fdc8ddae617d01d684ff3f2a4cc331/commit-msg.py -O post-commit >/dev/null 2>&1

echo -e '\033[44;37;5m The deployment for githook is completed ! \033[0m  😎 '
