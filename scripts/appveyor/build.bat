@echo off

if NOT DEFINED ROOT_DIR set ROOT_DIR=C:\Projects
if NOT DEFINED VCPKG_DIR set VCPKG_DIR=C:\Projects\vcpkg

call "%~dp0\install_dependencies.bat"

REM when saving the cached vcpkg packages
REM skip the build
if "%APPVEYOR_CACHE_SKIP_SAVE%" == "false" (goto :EOF)

REM build project
mkdir build
pushd build
cmake -G"Visual Studio 15 2017 Win64" ^
      -DBUILD_SHARED_LIBS=OFF ^
      -DVCPKG_TARGET_TRIPLET=x64-windows-static ^
      -DCMAKE_TOOLCHAIN_FILE:FILEPATH="%VCPKG_DIR%\scripts\buildsystems\vcpkg.cmake" ^
      ..
popd
