#!/bin/bash

set -e
set -x

if [[ "$(uname -s)" == 'Linux' ]]; then
    sudo apt-get install cmake git libx11-dev freeglut3-dev libjpeg-dev libfreetype6-dev libxrandr-dev libglew-dev libsndfile1-dev libopenal-dev libudev-dev
fi

if [[ "$(uname -s)" == 'Darwin' ]]; then
    brew update || brew update
    brew outdated pyenv || brew upgrade pyenv
    brew install pyenv-virtualenv
    brew install cmake || true

    if which pyenv > /dev/null; then
        eval "$(pyenv init -)"
    fi

    pyenv install 2.7.10
    pyenv virtualenv 2.7.10 conan
    pyenv rehash
    pyenv activate conan
fi

pip install conan_package_tools # It install conan too
conan user
