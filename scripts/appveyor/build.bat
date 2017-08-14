@echo off

if NOT DEFINED ROOT_DIR set ROOT_DIR=C:\Projects
if NOT DEFINED VCPKG_DIR set VCPKG_DIR=%ROOT_DIR%\vcpkg

REM download prebuilt dependencies
if NOT EXIST "%ROOT_DIR%" (mkdir "%ROOT_DIR%")
pushd "%ROOT_DIR%"

powershell -NoProfile -Exec ByPass -Command "wget https://ci.appveyor.com/api/projects/willyd/caffe2-vcpkg-dependencies/artifacts/vcpkg.zip?branch=windows-dependencies -OutFile vcpkg.zip"
7z x vcpkg.zip -ovcpkg

popd

REM build project
mkdir build
pushd build
cmake -G"Visual Studio 15 2017 Win64" ^
      -DBUILD_SHARED_LIBS=OFF ^
      -DVCPKG_TARGET_TRIPLET=x64-windows-static ^
      -DCMAKE_TOOLCHAIN_FILE:FILEPATH="%VCPKG_DIR%\scripts\buildsystems\vcpkg.cmake" ^
      ..
popd

