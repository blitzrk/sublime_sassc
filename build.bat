@ECHO OFF
set VSN=%1

:: Try to guarantee git and msbuild are in path
IF EXIST "%ProgramFiles(x86)%\Git\bin\git" SET PATH=%PATH%;"%ProgramFiles(x86)%\Git\bin"
IF EXIST "%ProgramFiles%\Git\bin\git" SET PATH=%PATH%;"%ProgramFiles%\Git\bin"
IF EXIST "%ProgramFiles(x86)%\MSBuild\14.0\Bin\MSBuild" SET PATH=%PATH%;"%ProgramFiles(x86)%\MSBuild\14.0\Bin"
IF EXIST "%ProgramFiles(x86)%\MSBuild\12.0\Bin\MSBuild" SET PATH=%PATH%;"%ProgramFiles(x86)%\MSBuild\12.0\Bin"

set cfg=/m /p:Configuration=Release
if "%2"=="-m32" (
	set cfg=%cfg% /p:Platform=Win32
) else if "%2"=="-m64" (
	set cfg=%cfg% /p:Platform=Win64
)
set cfg=%cfg% /p:ForceImportBeforeCppTargets=%~dp0%static.props

git submodule -q deinit -f "."
git submodule -q init
git submodule -q update
git submodule -q foreach "git checkout -q tags/%VSN%"

move sassc.git libsass\sassc
cmd /c (
	pushd libsass\sassc
	msbuild win\sassc.sln %cfg% /t:Clean;Build
	popd
	copy libsass\sassc\bin\sassc.exe sassc.exe
)

echo "Built sassc.exe. Copy to appropriate directories."
