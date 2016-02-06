@ECHO OFF
set LIBSASS="3.3.3"
set SASSC="3.3.2"

:: set git="%ProgramFiles(x86)%\Git\bin\git" :: for older git-bash installs
set git="%ProgramFiles%\Git\bin\git"

:: s/14/12/ for VS2013 (min req) instead of VS2015 
set msbuild="%ProgramFiles(x86)%\MSBuild\14.0\Bin\MSBuild"

set cfg=/m /p:Configuration=Release
if "%1"=="-m32" (
	set cfg=%cfg% /p:Platform=Win32
) else if "%1"=="-m64" (
	set cfg=%cfg% /p:Platform=Win64
)
set cfg=%cfg% /p:ForceImportBeforeCppTargets=%~dp0%static.props

%git% submodule -q deinit -f .
%git% submodule -q init
%git% pull -q --recurse-submodule
%git% submodule update

cmd /c "cd libsass && %git% checkout tags/%LIBSASS%" >nul
cmd /c "cd sassc.git && %git% checkout tags/%SASSC%" >nul

xcopy sassc.git\* libsass\sassc /s /i >nul
cmd /c (
	cd libsass\sassc
	%msbuild% win\sassc.sln %cfg% /t:Clean;Build
	copy bin\sassc.exe ..\..\sassc.exe
	cd ..\..
)

echo "Built sassc.exe. Copy to appropriate directories."
