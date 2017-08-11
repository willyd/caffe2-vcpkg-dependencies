@echo off

if NOT DEFINED ROOT_DIR ( set ROOT_DIR=C:\Projects )
if NOT DEFINED VCPKG_DIR ( set VCPKG_DIR=C:\Projects\vcpkg )

if EXIST "%VCPKG_DIR%\vcpkg.exe" ( goto install_dependencies )

REM install vcpkg and dependencies
if NOT EXIST "%ROOT_DIR%" (mkdir "%ROOT_DIR%")
pushd "%ROOT_DIR%"

git clone https://github.com/willyd/vcpkg.git

pushd "%VCPKG_DIR%%

git checkout opencv-static

REM vcpkg prompts to download those so we download them manually
powershell -NoProfile -Exec ByPass -Command ".\scripts\fetchDependency.ps1 -Dependency cmake -downloadPromptOverride '1'"
powershell -NoProfile -Exec ByPass -Command ".\scripts\fetchDependency.ps1 -Dependency nuget -downloadPromptOverride '1'"
powershell -NoProfile -Exec ByPass -Command ".\scripts\fetchDependency.ps1 -Dependency git -downloadPromptOverride '1'"

REM build vcpkg if it does not exist
if NOT EXIST "%VCPKG_DIR%\vcpkg.exe" ( call bootstrap-vcpkg.bat )

popd
popd

:install_dependencies
pushd  "%VCPKG_DIR%"
REM install some of the dependencies
.\vcpkg.exe install glog gflags eigen3 protobuf lmdb --triplet x64-windows-static
.\vcpkg list
popd