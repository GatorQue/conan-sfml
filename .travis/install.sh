#!/bin/bash

set -e
set -x

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

pip install urllib3[secure]
pip install conan_package_tools # It install conan too
conan user

# Determine if X11 include files are available at the expected locations:
[ -d /usr/pkg/xorg/include ] && ls -R /usr/pkg/xorg/include
[ -d /usr/X11R6/include ] && ls -R /usr/X11R6/include
[ -d /usr/X11R7/include ] && ls -R /usr/X11R7/include
[ -d /usr/openwin/include ] && ls -R /usr/openwin/include
[ -d /usr/openwin/share/include ] && ls -R /usr/openwin/share/include
[ -d /usr/include/X11 ] && ls -R /usr/include/X11

# Determine if X11 include files are available at the expected locations:
[ -d /usr/xorg/lib ] && ls -R /usr/pkg/xorg/lib
[ -d /usr/X11R6/lib ] && ls -R /usr/X11R6/lib
[ -d /usr/X11R7/lib ] && ls -R /usr/X11R7/lib
[ -d /usr/openwin/lib ] && ls -R /usr/openwin/lib
[ -d /usr/lib ] && ls -R /usr/lib

