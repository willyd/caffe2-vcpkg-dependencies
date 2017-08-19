@echo off

if NOT DEFINED ROOT_DIR set ROOT_DIR=C:\Projects
if NOT DEFINED VCPKG_DIR set VCPKG_DIR=%ROOT_DIR%\vcpkg

if NOT EXIST "%ROOT_DIR%" (mkdir "%ROOT_DIR%")
pushd  "%ROOT_DIR%"

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
call bootstrap-vcpkg.bat

.\vcpkg.exe install msmpi --triplet x64-windows
set ERRORLEVEL=0
.\downloads\MSMpiSetup-8.1.exe -unattend

.\vcpkg.exe install msmpi --triplet x64-windows

REM install some of the dependencies
.\vcpkg.exe install openblas --triplet x64-windows
REM .\vcpkg.exe install gflags glog boost hdf5 openblas protobuf lmdb opencv --triplet x64-windows

REM move log files in case an error occurs
mkdir logs
robocopy buildtrees\ logs *x64-windows*.log /S

REM remove unncessary stuff
rmdir /S /Q .git
rmdir /S /Q buildtrees
rmdir /S /Q docs
rmdir /S /Q downloads
rmdir /S /Q packages
rmdir /S /Q ports
rmdir /S /Q toolsrc

popd
