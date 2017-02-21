# sfml conanfile - modified by cpbotha from original by TyRoXx
# * use tarball instead of zip to work-around symlink bug
#   https://github.com/conan-io/conan/issues/336
from conans import ConanFile
import os
from conans.tools import download, unzip, check_sha256
from conans import CMake, ConfigureEnvironment
import platform


class SFMLConanFile(ConanFile):
    name = "sfml"
    version = "2.4.1"
    branch = "stable"
    settings = "os", "arch", "compiler", "build_type"
    options = {"shared": [True, False]}
    default_options = "shared=True"
    generators = "cmake"
    exports = ["CMakeLists.txt", "FindSFML.cmake"]
    ARCHIVE_FOLDER_NAME = "SFML-%s" % version
    so_version = '2.4'
    url = "http://github.com/gatorque/conan-sfml"
    license = "zlib/png"
    description="SFML is a simple, fast, cross-platform and object-oriented multimedia API. It provides access to windowing, graphics, audio and network."
    
    def source(self):
        tgz_name = "%s.tar.gz" % self.version
        download("https://github.com/SFML/SFML/archive/%s" % tgz_name, tgz_name)
        check_sha256(tgz_name, "f9d1191b02e2df1cbe296601eee20bdf56d98fb69d49fde27c6ca789eb57398e")
        unzip(tgz_name)
        os.unlink(tgz_name)

    def build(self):
        """ Define your project building. You decide the way of building it
            to reuse it later in any other project.
        """
        cmake = CMake(self.settings)
        self.run("mkdir build")
        # put frameworks in ~/Library/Frameworks, else we get permission denied
        # for SFML to work, you'll probably have to copy the sfml extlibs
        # frameworks manually into /Library/Frameworks
        self.run('cd build && cmake ../%s -DBUILD_SHARED_LIBS=%s -DCMAKE_INSTALL_PREFIX=../install -DCMAKE_INSTALL_FRAMEWORK_PREFIX=../install/Frameworks %s' % (self.ARCHIVE_FOLDER_NAME, "ON" if self.options.shared else "OFF", cmake.command_line))
        if self.settings.os == "Windows":
            self.run("cd build && cmake --build . %s --target install --config %s" % (cmake.build_config, self.settings.build_type))
        else:
            self.run("cd build && cmake --build . %s -- -j2 install" % (cmake.build_config))

    def package(self):
        """ Define your conan structure: headers, libs, bins and data. After building your
            project, this method is called to create a defined structure:
        """
        self.copy("FindSFML.cmake", ".", self.ARCHIVE_FOLDER_NAME + "/cmake/Modules", keep_path=False)
        self.copy("*.*", "include", "install/include", keep_path=True)
        self.copy("*.*", "Frameworks", "install/Frameworks", keep_path=True)

        # actually just copy everything in the lib directory
        # it's a shame that conan does not preserve symbolic links in this case
        # https://github.com/conan-io/conan/issues/204
        # but I guess we'll live.
        self.copy(pattern="*.*", dst="lib", src="install/lib", keep_path=False)
        if self.settings.os == "Windows":
            if self.options.shared:
                self.copy(pattern="*.dll", dst="bin", src="install/lib", keep_path=False)

    def package_info(self):
        if not self.settings.os == "Windows" and self.options.shared:
            # on Macos, we do e.g. -lsfml-audio.2.4 to link to libsfml-audio.2.4.dylib
            # on Linux, it's just -lsfml-audio to link to libsfml-audio.so which is a symlink
            # using platform.system() instead of self.settings.os here to work around
            # https://github.com/conan-io/conan/issues/338
            if platform.system() == "Linux":
                so_version = ''
            else:
                so_version = '.' + self.so_version

            self.cpp_info.libs = list(map(
                lambda name: name +
                ('-d' if self.settings.build_type == "Debug" else '') + so_version,
                ['sfml-audio', 'sfml-graphics', 'sfml-network', 'sfml-window', 'sfml-system']
            ))
        else:
            self.cpp_info.libs = list(map(
                lambda name: name +
                ('-d' if self.settings.build_type == "Debug" else ''),
                map(
                    lambda name: name + ('' if self.options.shared else '-s'),
                    ['sfml-audio', 'sfml-graphics', 'sfml-network', 'sfml-window', 'sfml-system']
                )
            ))

        if not self.settings.os == "Windows":
            self.cpp_info.libs.append("pthread")
            self.cpp_info.libs.append("dl")
