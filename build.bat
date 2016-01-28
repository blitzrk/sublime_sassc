@ECHO OFF
set LIBSASS="3.3.3"
set SASSC="3.3.2"

:: set git="%ProgramFiles(x86)%\Git\bin\git" :: for older git-bash installs
set git="%ProgramFiles%\Git\bin\git"

:: s/14/12/ for VS2013 (min req) instead of VS2015 
set msbuild="%ProgramFiles(x86)%\MSBuild\14.0\Bin\MSBuild"

%git% submodule init
%git% submodule update

cmd /c "cd libsass && %git% checkout tags/%LIBSASS%" >nul
cmd /c "cd sassc.git && %git% checkout tags/%SASSC%" >nul

xcopy sassc.git\* libsass\sassc /s /i >nul
cmd /c "cd libsass\sassc && %msbuild% win\sassc.sln /p:Configuration=Release" >nul

copy libsass\sassc\bin\sassc.exe sassc.exe >nul
echo "Built sassc.exe. Copy to appropriate directories."
