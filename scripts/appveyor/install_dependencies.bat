@echo off

if NOT DEFINED VCPKG_DIR set VCPKG_DIR="%cd%\vcpkg"

REM Skip building dependencies
if EXIST "%VCPKG_DIR%" (
    echo Dependencies already installed.
    goto :EOF
)

echo Builing dependencies

REM using this fork since real vcpkg forbids the build of static opencv
git clone https://github.com/willyd/vcpkg.git

pushd "%VCPKG_DIR%"

git checkout opencv-static

REM vcpkg prompts to download those so we download them manually
powershell -NoProfile -Exec ByPass -Command ".\scripts\fetchDependency.ps1 -Dependency cmake -downloadPromptOverride '1'"
powershell -NoProfile -Exec ByPass -Command ".\scripts\fetchDependency.ps1 -Dependency nuget -downloadPromptOverride '1'"
powershell -NoProfile -Exec ByPass -Command ".\scripts\fetchDependency.ps1 -Dependency git -downloadPromptOverride '1'"

REM build vcpkg if it does not exist
if NOT EXIST "%VCPKG_DIR%\vcpkg.exe" ( call bootstrap-vcpkg.bat )

REM install some of the dependencies
REM .\vcpkg.exe install gflags glog eigen3 protobuf lmdb --triplet x64-windows-static
.\vcpkg.exe install gflags --triplet x64-windows-static

REM remove unncessary stuff
rmdir /S /Q .git
rmdir /S /Q buildtrees
rmdir /S /Q docs
rmdir /S /Q downloads
rmdir /S /Q packages
rmdir /S /Q ports
rmdir /S /Q toolsrc

popd
