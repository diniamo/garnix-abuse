{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  glfw,
  SDL2,
  platform ? "Web", # Note that "Web" and "Android" do not currently work
  sharedLib ? true,
  includeEverything ? true,
}:
let
  inherit (lib) optional;

  pname = "raylib";
in

lib.checkListOfEnum "${pname}: platform"
  [
    "Desktop"
    "Web"
    "Android"
    "Raspberry Pi"
    "SDL"
  ]
  [ platform ]

  (
    stdenv.mkDerivation (finalAttrs: {
      inherit pname;
      version = "5.5";

      src = fetchFromGitHub {
        owner = "raysan5";
        repo = pname;
        rev = finalAttrs.version;
        hash = "sha256-J99i4z4JF7d6mJNuJIB0rHNDhXJ5AEkG0eBvvuBLHrY=";
      };

      nativeBuildInputs = [ cmake ];
      buildInputs = optional (platform == "Desktop") glfw ++ optional (platform == "SDL") SDL2;

      # https://github.com/raysan5/raylib/wiki/CMake-Build-Options
      cmakeFlags =
        [
          "-DCUSTOMIZE_BUILD=ON"
          "-DBUILD_EXAMPLES=OFF"
        ]
        ++ optional (platform == "Desktop") "-DUSE_EXTERNAL_GLFW=ON"
        ++ optional includeEverything "-DINCLUDE_EVERYTHING=ON"
        ++ optional sharedLib "-DBUILD_SHARED_LIBS=ON";

      preConfigure = ''
        cmakeFlagsArray+=("-DPLATFORM=${platform}")
      '';

      meta = {
        description = "Simple and easy-to-use library to enjoy videogames programming";
        homepage = "https://www.raylib.com/";
        license = lib.licenses.zlib;
        maintainers = [ ];
        platforms = lib.platforms.all;
        changelog = "https://github.com/raysan5/raylib/blob/${finalAttrs.version}/CHANGELOG";
      };
    })
  )
