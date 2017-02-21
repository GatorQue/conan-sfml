from conan.packager import ConanMultiPackager
import platform


if __name__ == "__main__":
    builder = ConanMultiPackager(username="GatorQue")
    builder.add_common_builds(shared_option_name="sfml:shared", pure_c=False)
    builder.run()
