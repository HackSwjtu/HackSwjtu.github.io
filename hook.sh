#!/bin/bash

cd .git/hooks

if [ $? -ne 0 ]; then
    echo 'I need git proj!(╯‵□′)╯︵┻━┻'
    exit 1
fi

wget https://gist.githubusercontent.com/Desgard/f2c34e4586eb92d50a6a10d0cac7dc0a/raw/61e51756b5fdc8ddae617d01d684ff3f2a4cc331/commit-msg.py -O post-commit >/dev/null 2>&1
sudo chmod 755 post-commit

echo '     _/                            _/'
echo '    _/_/_/      _/_/_/    _/_/_/  _/  _/'
echo '   _/    _/  _/    _/  _/        _/_/'
echo '  _/    _/  _/    _/  _/        _/  _/'
echo ' _/    _/    _/_/_/    _/_/_/  _/    _/'
echo ''

echo -e '\033[44;37;5m The deployment for githook is completed ! \033[0m  😎 '
