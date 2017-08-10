@echo off

set ROOT_DIR=C:\Projects
set VCPKG_DIR=C:\Projects\vcpkg

if EXIST "%VCPKG_DIR%" (goto build_project)

REM install vcpkg and dependencies
if NOT EXIST "%ROOT_DIR%" (mkdir "%ROOT_DIR%")
pushd "%ROOT_DIR%"
git clone https://github.com/willyd/vcpkg.git
pushd vcpkg
git checkout opencv-static

powershell -NoProfile -Exec ByPass -Command ".\scripts\fetchDependency.ps1 -Dependency cmake -downloadPromptOverride '1'"
powershell -NoProfile -Exec ByPass -Command ".\scripts\fetchDependency.ps1 -Dependency nuget -downloadPromptOverride '1'"
powershell -NoProfile -Exec ByPass -Command ".\scripts\fetchDependency.ps1 -Dependency git -downloadPromptOverride '1'"

call bootstrap-vcpkg.bat
.\vcpkg.exe install glog gflags eigen3 protobuf lmdb --triplet x64-windows-static
popd
popd

:build_project
REM list installed packages
pushd "%VCPKG_DIR%"
vcpkg list
popd

REM build project
mkdir build
pushd build
cmake -G"Visual Studio 15 2017 Win64" ^
      -DCMAKE_TOOLCHAIN_FILE:FILEPATH="%VCPKG_DIR%\scripts\buildsystems\vcpkg.cmake" ^
      ..
popd