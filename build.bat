echo y | rd /s dist
del release.zip

set QTDIR32=-DQTDIR="C:/QtDep/5.15.2/msvc2019"
set QTDIR64=-DQTDIR="C:/QtDep/5.15.2/msvc2019_64"

cmake %QTDIR32% -G "Visual Studio 16 2019" -A Win32 -B build_x86 -S . -DCMAKE_INSTALL_PREFIX=dist
cmake --build build_x86 --config Release
cmake --install build_x86 --config Release

cmake %QTDIR64% -G "Visual Studio 16 2019" -A x64 -B build_x64 -S . -DCMAKE_INSTALL_PREFIX=dist
cmake --build build_x64 --config Release
cmake --install build_x64 --config Release

if not exist dist\nul exit /b
cd dist
cmake -E tar cf ..\release.zip --format=zip .
copy ..\installer_script\installer.nsi .
mkdir plugins\obs-multi-rtmp\bin\32bit
copy obs-plugins\32bit\obs-multi-rtmp.dll plugins\obs-multi-rtmp\bin\32bit\
mkdir plugins\obs-multi-rtmp\bin\64bit
copy obs-plugins\64bit\obs-multi-rtmp.dll plugins\obs-multi-rtmp\bin\64bit\
mkdir plugins\obs-multi-rtmp\data\locale
copy data\obs-plugins\obs-multi-rtmp\locale\*.ini plugins\obs-multi-rtmp\data\locale\
"C:\Program Files (x86)\NSIS\makensis" installer.nsi

copy obs-multi-rtmp-setup.exe ..\installer
cd ..
