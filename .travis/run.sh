#!/bin/bash

set -e
set -x

if [[ "$(uname -s)" == 'Darwin' ]]; then
    if which pyenv > /dev/null; then
        eval "$(pyenv init -)"
    fi
    pyenv activate conan
fi

apt install freeglut3-dev libfreetype6-dev libgl1-mesa-dev libglew-dev libgpgme11-dev libjpeg8-dev libopenal-dev libpthread-stubs0-dev libsndfile1-dev libssl-dev libudev-dev libx11-dev libx11-xcb-dev libxcb-randr0-dev libxcb-image0-dev libxrandr-dev

python build.py
