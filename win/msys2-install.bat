cd %~dp0

:: -- config ---
set MSYS_DRV=C:
set MSYS_USR=admin
set Z7_URL=https://github.com/go-t/os/raw/master/win
set MSYS_SRC=https://mirrors.tuna.tsinghua.edu.cn/msys2

set MSYS_URL=%MSYS_SRC%/distrib/msys2-x86_64-latest.tar.xz
set MSYS_DIR=%MSYS_DRV%\msys64
set PATH=%MSYS_DIR%\usr\bin;%~dp0;%PATH%

call :download 7z.exe %Z7_URL%/7z.exe
call :download 7z.dll %Z7_URL%/7z.dll
call :download msys2-x86_64-latest.tar.xz %MSYS_URL%
call :install
call :mount-fs
call :upgrade
call :softwares
call :setup-msys
call :setup-sshkey
call :setup-on-my-zsh
call :setup-mintty
call :setup-vim
GOTO:eof

:backup
if not exist "%1.bak" copy /Y "%1" "%1.bak"
GOTO:eof

:: download tar.exe %GOW_URL%/tar.exe
:download
set PSH_EXE=C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
set TLS_CODE=[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
if not exist "%1" (
	%PSH_EXE% -noprofile -Command "&{ %TLS_CODE%; Invoke-WebRequest -Uri \"%2\" -OutFile \"%1\"; }"
)
GOTO:eof

:install
mkdir "%MSYS_DIR%"
rmdir /S /Q "%MSYS_DIR%"
if not exist msys2-x86_64-latest.tar .\7z.exe x msys2-x86_64-latest.tar.xz
if not exist %MSYS_DIR% .\7z.exe x -o%MSYS_DRV% msys2-x86_64-latest.tar
GOTO:eof

:mount-fs
mkdir %MSYS_DRV%\work
mkdir %MSYS_DRV%\opt
call :backup %MSYS_DIR%\etc\fstab
echo none / cygdrive binary,posix=0,noacl,user 0 0 >%MSYS_DIR%\etc\fstab
echo %MSYS_DRV%/work /work ntfs binary,posix=0,noacl,user >>%MSYS_DIR%\etc\fstab
echo %MSYS_DRV%/opt /opt ntfs binary,posix=0,noacl,user   >>%MSYS_DIR%\etc\fstab
GOTO:eof

:upgrade
call :setup-lang
bash %MSYS_DIR%\usr\bin\pacman-key --init
bash %MSYS_DIR%\usr\bin\pacman-key --populate msys2
bash %MSYS_DIR%\usr\bin\pacman-key --refresh-keys
FOR %%A IN (1 2 3 4) DO call :upgrade_once
GOTO:eof

:setup-lang
echo 'export LANG=en_US.UTF-8' > %MSYS_DIR%\etc\profile.d\lang.sh
echo 'export LC_ALL=en_US.UTF-8' >> %MSYS_DIR%\etc\profile.d\lang.sh

:upgrade_once
echo Server = %MSYS_SRC%/mingw/i686/  >%MSYS_DIR%\etc\pacman.d\mirrorlist.mingw32
echo Server = %MSYS_SRC%/mingw/x86_64/>%MSYS_DIR%\etc\pacman.d\mirrorlist.mingw64
echo Server = %MSYS_SRC%/msys/x86_64/ >%MSYS_DIR%\etc\pacman.d\mirrorlist.msys
%MSYS_DIR%\usr\bin\pacman.exe -Scc --noconfirm
%MSYS_DIR%\usr\bin\pacman.exe -Syy -u --noconfirm
GOTO:eof

:softwares
%MSYS_DIR%\usr\bin\pacman.exe -S --noconfirm --needed ^
	git vim tar zip unzip curl wget make rsync zsh openssh

%MSYS_DIR%\usr\bin\pacman.exe -S --noconfirm --needed ^
	mingw-w64-x86_64-gcc    ^
	mingw-w64-x86_64-make   ^
	mingw-w64-x86_64-pkg-config ^
	mingw-w64-x86_64-ntldd-git 
GOTO:eof

:setup-msys
call :backup %MSYS_DIR%\mingw64.ini
call :backup %MSYS_DIR%\etc\nsswitch.conf

echo MSYS=winsymlinks:nativestrict >%MSYS_DIR%\mingw64.ini
echo MSYS2_PATH_TYPE=inherit >>%MSYS_DIR%\mingw64.ini
echo MSYSTEM=MINGW64  >>%MSYS_DIR%\mingw64.ini
echo CHERE_INVOKING=1 >>%MSYS_DIR%\mingw64.ini

cat.exe %MSYS_DIR%\etc\nsswitch.conf.bak | grep -v db_home | grep -v db_shell >%MSYS_DIR%\etc\nsswitch.conf
echo db_home: /home/%MSYS_USR% >>%MSYS_DIR%\etc\nsswitch.conf
echo db_shell: /usr/bin/zsh >>%MSYS_DIR%\etc\nsswitch.conf
GOTO:eof

:setup-on-my-zsh
rm -rf %MSYS_DIR%\home\admin\.oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git %MSYS_DIR%\home\admin\.oh-my-zsh
echo export ZSH=$HOME/.oh-my-zsh  >zshrc
echo export SHELL=/usr/bin/zsh   >>zshrc
echo ZSH_THEME="robbyrussell"    >>zshrc
echo DISABLE_AUTO_UPDATE="true"  >>zshrc
echo plugins=(git npm)           >>zshrc
echo source $ZSH/oh-my-zsh.sh    >>zshrc
cat zshrc | sed "s/ *$//"         >%MSYS_DIR%\home\admin\.zshrc
GOTO:eof

:setup-mintty
echo BoldAsFont=-1            >minttyrc
echo Columns=120             >>minttyrc
echo Rows=40                 >>minttyrc
echo FontHeight=12           >>minttyrc
echo Font=Courier New        >>minttyrc
echo Transparency=medium     >>minttyrc
echo RightClickAction=paste  >>minttyrc
echo CursorType=block        >>minttyrc
echo Term=xterm-256color     >>minttyrc
cat minttyrc | sed "s/ *$//"  >%MSYS_DIR%\home\admin\.minttyrc
GOTO:eof

:setup-vim
echo syntax on                                                 >vimrc
echo colorscheme delek                                        >>vimrc
echo set nocompatible                                         >>vimrc
echo set mouse-=a                                             >>vimrc
echo set encoding=utf-8                                       >>vimrc
echo set fileencodings=utf-8,gb18030,gbk,ucs-bom,cp936,latin1 >>vimrc
echo set termencoding=utf-8                                   >>vimrc
echo set backspace=indent,eol,start                           >>vimrc
echo set number                                               >>vimrc
echo set ruler                                                >>vimrc
echo set showmatch                                            >>vimrc
echo set incsearch                                            >>vimrc
echo set hlsearch                                             >>vimrc
echo set autoindent                                           >>vimrc
echo set tabstop=4                                            >>vimrc
echo set shiftwidth=4                                         >>vimrc
echo set softtabstop=4                                        >>vimrc
echo set expandtab                                            >>vimrc
echo set ic                                                   >>vimrc
echo set autowrite                                            >>vimrc
echo set cursorline                                           >>vimrc
echo if ^&diff                                                >>vimrc
echo     highlight! link DiffText MatchParen                  >>vimrc
echo endif                                                    >>vimrc
echo let g:deoplete#enable_at_startup = 1                     >>vimrc
cat vimrc | sed "s/ *$//" >%MSYS_DIR%\home\admin\.vimrc
GOTO:eof

:setup-sshkey
zsh.exe --login -c "cd $HOME && if [ ! -e .ssh/id_rsa.pub ] ; then cat /dev/zero | ssh-keygen -b 2048 -t rsa -q -N '' ; fi && cat .ssh/id_rsa.pub"
GOTO:eof

:end
