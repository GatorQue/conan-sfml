#=============================================================================
# Copyright 2001-2011 Kitware, Inc.
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)

find_path(SFML_INCLUDE_DIR NAMES SFML/Config.hpp PATHS ${CONAN_INCLUDE_DIRS_SFML})
find_library(SFML_LIBRARY NAMES ${CONAN_LIBS_SFML} PATHS ${CONAN_LIB_DIRS_SFML})

MESSAGE("** SFML ALREADY FOUND BY CONAN!")
SET(SFML_FOUND TRUE)
MESSAGE("** FOUND SFML:  ${SFML_LIBRARY}")
MESSAGE("** FOUND SFML INCLUDE:  ${SFML_INCLUDE_DIR}")

set(SFML_INCLUDE_DIRS ${SFML_INCLUDE_DIR})
set(SFML_LIBRARIES ${SFML_LIBRARY})

mark_as_advanced(SFML_LIBRARY SFML_INCLUDE_DIR)

if(SFML_INCLUDE_DIR)
    # extract the major and minor version numbers from SFML/Config.hpp
    # we have to handle framework a little bit differently:
    if("${SFML_INCLUDE_DIR}" MATCHES "SFML.framework")
        set(SFML_CONFIG_HPP_INPUT "${SFML_INCLUDE_DIR}/Headers/Config.hpp")
    else()
        set(SFML_CONFIG_HPP_INPUT "${SFML_INCLUDE_DIR}/SFML/Config.hpp")
    endif()
    FILE(READ "${SFML_CONFIG_HPP_INPUT}" SFML_CONFIG_HPP_CONTENTS)
    STRING(REGEX REPLACE ".*#define SFML_VERSION_MAJOR ([0-9]+).*" "\\1" SFML_VERSION_MAJOR "${SFML_CONFIG_HPP_CONTENTS}")
    STRING(REGEX REPLACE ".*#define SFML_VERSION_MINOR ([0-9]+).*" "\\1" SFML_VERSION_MINOR "${SFML_CONFIG_HPP_CONTENTS}")
    STRING(REGEX REPLACE ".*#define SFML_VERSION_PATCH ([0-9]+).*" "\\1" SFML_VERSION_PATCH "${SFML_CONFIG_HPP_CONTENTS}")
    if (NOT "${SFML_VERSION_PATCH}" MATCHES "^[0-9]+$")
        set(SFML_VERSION_PATCH 0)
    endif()
endif()
