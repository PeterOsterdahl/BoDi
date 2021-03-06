@pushd %~dp0

set VERSION=%1
set PKGVER=%1%2
set CONFIG="/p:Configuration=Release"

@echo local NuGet publish folder: %NUGET_LOCAL_FEED%
@echo publishing version %VERSION%, pkg version %PKGVER%, %CONFIG%, OK?
@pause

cd ..
cd BoDi

copy /Y BoDi.csproj BoDi.csproj.bak
powershell -Command "(gc 'BoDi.csproj') -replace '1.0.0.0', '%VERSION%.0' | Out-File 'BoDi.csproj'"
powershell -Command "(gc 'BoDi.csproj') -replace '1.0.0', '%PKGVER%' | Out-File 'BoDi.csproj'"


cd ..

msbuild BoDi.sln %CONFIG%

cd BoDi.NuGetPackages

msbuild BoDi.NuGetPackages.csproj "/p:NuGetVersion=%PKGVER%" /p:NugetPublishToLocalNugetFeed=true /t:Publish /p:NugetPublishLocalNugetFeedFolder=%NUGET_LOCAL_FEED%  %CONFIG%

cd ..
move /Y BoDi\BoDi.csproj.bak BoDi\BoDi.csproj

@popd