! Copyright (C) 2006, 2008 Doug Coleman.
! See http://factorcode.org/license.txt for BSD license.
USING: alien alien.c-types alien.data alien.strings
alien.syntax classes.struct io.backend kernel
specialized-arrays
specialized-arrays.instances.alien.c-types.ushort windows
windows.com windows.com.syntax windows.kernel32 windows.ole32
windows.types ;
IN: windows.shell32

CONSTANT: CSIDL_DESKTOP 0x00
CONSTANT: CSIDL_INTERNET 0x01
CONSTANT: CSIDL_PROGRAMS 0x02
CONSTANT: CSIDL_CONTROLS 0x03
CONSTANT: CSIDL_PRINTERS 0x04
CONSTANT: CSIDL_PERSONAL 0x05
CONSTANT: CSIDL_FAVORITES 0x06
CONSTANT: CSIDL_STARTUP 0x07
CONSTANT: CSIDL_RECENT 0x08
CONSTANT: CSIDL_SENDTO 0x09
CONSTANT: CSIDL_BITBUCKET 0x0a
CONSTANT: CSIDL_STARTMENU 0x0b
CONSTANT: CSIDL_MYDOCUMENTS 0x0c
CONSTANT: CSIDL_MYMUSIC 0x0d
CONSTANT: CSIDL_MYVIDEO 0x0e
CONSTANT: CSIDL_DESKTOPDIRECTORY 0x10
CONSTANT: CSIDL_DRIVES 0x11
CONSTANT: CSIDL_NETWORK 0x12
CONSTANT: CSIDL_NETHOOD 0x13
CONSTANT: CSIDL_FONTS 0x14
CONSTANT: CSIDL_TEMPLATES 0x15
CONSTANT: CSIDL_COMMON_STARTMENU 0x16
CONSTANT: CSIDL_COMMON_PROGRAMS 0x17
CONSTANT: CSIDL_COMMON_STARTUP 0x18
CONSTANT: CSIDL_COMMON_DESKTOPDIRECTORY 0x19
CONSTANT: CSIDL_APPDATA 0x1a
CONSTANT: CSIDL_PRINTHOOD 0x1b
CONSTANT: CSIDL_LOCAL_APPDATA 0x1c
CONSTANT: CSIDL_ALTSTARTUP 0x1d
CONSTANT: CSIDL_COMMON_ALTSTARTUP 0x1e
CONSTANT: CSIDL_COMMON_FAVORITES 0x1f
CONSTANT: CSIDL_INTERNET_CACHE 0x20
CONSTANT: CSIDL_COOKIES 0x21
CONSTANT: CSIDL_HISTORY 0x22
CONSTANT: CSIDL_COMMON_APPDATA 0x23
CONSTANT: CSIDL_WINDOWS 0x24
CONSTANT: CSIDL_SYSTEM 0x25
CONSTANT: CSIDL_PROGRAM_FILES 0x26
CONSTANT: CSIDL_MYPICTURES 0x27
CONSTANT: CSIDL_PROFILE 0x28
CONSTANT: CSIDL_SYSTEMX86 0x29
CONSTANT: CSIDL_PROGRAM_FILESX86 0x2a
CONSTANT: CSIDL_PROGRAM_FILES_COMMON 0x2b
CONSTANT: CSIDL_PROGRAM_FILES_COMMONX86 0x2c
CONSTANT: CSIDL_COMMON_TEMPLATES 0x2d
CONSTANT: CSIDL_COMMON_DOCUMENTS 0x2e
CONSTANT: CSIDL_COMMON_ADMINTOOLS 0x2f
CONSTANT: CSIDL_ADMINTOOLS 0x30
CONSTANT: CSIDL_CONNECTIONS 0x31
CONSTANT: CSIDL_COMMON_MUSIC 0x35
CONSTANT: CSIDL_COMMON_PICTURES 0x36
CONSTANT: CSIDL_COMMON_VIDEO 0x37
CONSTANT: CSIDL_RESOURCES 0x38
CONSTANT: CSIDL_RESOURCES_LOCALIZED 0x39
CONSTANT: CSIDL_COMMON_OEM_LINKS 0x3a
CONSTANT: CSIDL_CDBURN_AREA 0x3b
CONSTANT: CSIDL_COMPUTERSNEARME 0x3d
CONSTANT: CSIDL_PROFILES 0x3e
CONSTANT: CSIDL_FOLDER_MASK 0xff
CONSTANT: CSIDL_FLAG_PER_USER_INIT 0x800
CONSTANT: CSIDL_FLAG_NO_ALIAS 0x1000
CONSTANT: CSIDL_FLAG_DONT_VERIFY 0x4000
CONSTANT: CSIDL_FLAG_CREATE 0x8000
CONSTANT: CSIDL_FLAG_MASK 0xff00

CONSTANT: SHGFP_TYPE_CURRENT 0
CONSTANT: SHGFP_TYPE_DEFAULT 1

LIBRARY: shell32

FUNCTION: HRESULT SHGetFolderPathW ( HWND hwndOwner,
                                     int nFolder,
                                     HANDLE hToken,
                                     DWORD dwReserved,
                                     LPTSTR pszPath )
ALIAS: SHGetFolderPath SHGetFolderPathW

FUNCTION: HINSTANCE ShellExecuteW ( HWND hwnd,
                                    LPCTSTR lpOperation,
                                    LPCTSTR lpFile,
                                    LPCTSTR lpParameters,
                                    LPCTSTR lpDirectory, INT nShowCmd )
ALIAS: ShellExecute ShellExecuteW

CONSTANT: SHGFI_ICON 0x000000100
CONSTANT: SHGFI_DISPLAYNAME 0x000000200
CONSTANT: SHGFI_TYPENAME 0x000000400
CONSTANT: SHGFI_ATTRIBUTES 0x000000800
CONSTANT: SHGFI_ICONLOCATION 0x000001000
CONSTANT: SHGFI_EXETYPE 0x000002000
CONSTANT: SHGFI_SYSICONINDEX 0x000004000
CONSTANT: SHGFI_LINKOVERLAY 0x000008000
CONSTANT: SHGFI_SELECTED 0x000010000
CONSTANT: SHGFI_ATTR_SPECIFIED 0x000020000
CONSTANT: SHGFI_LARGEICON 0x000000000
CONSTANT: SHGFI_SMALLICON 0x000000001
CONSTANT: SHGFI_OPENICON 0x000000002
CONSTANT: SHGFI_SHELLICONSIZE 0x000000004
CONSTANT: SHGFI_PIDL 0x000000008
CONSTANT: SHGFI_USEFILEATTRIBUTES 0x000000010
CONSTANT: SHGFI_ADDOVERLAYS 0x000000020
CONSTANT: SHGFI_OVERLAYINDEX 0x000000040

STRUCT: SHFILEINFO
    { hIcon HICON }
    { iIcon int }
    { dwAttributes DWORD }
    { szDisplayName TCHAR[MAX_PATH] }
    { szTypeName TCHAR[80] } ;

FUNCTION: DWORD_PTR SHGetFileInfoW ( LPCTSTR pszPath,
                                     DWORD dwFileAttributes,
                                     SHFILEINFO *psfi,
                                     UINT cbFileInfo,
                                     UINT uFlags )

: shell32-file-info ( path -- err struct )
    normalize-path
    0
    SHFILEINFO <struct>
    [ dup byte-length SHGFI_EXETYPE SHGetFileInfoW ] keep ;

SINGLETONS:
    +dos-executable+
    +win32-console-executable+
    +win32-vxd-executable+
    +win32-os2-executable+
    +win32-nt-executable+ ;

MIXIN: windows-executable
INSTANCE: +dos-executable+ windows-executable        ! mz
INSTANCE: +win32-console-executable+ windows-executable
INSTANCE: +win32-vxd-executable+ windows-executable  ! le
INSTANCE: +win32-os2-executable+ windows-executable  ! ne
INSTANCE: +win32-nt-executable+ windows-executable   ! pe

: shell32-directory ( n -- str )
    f swap f SHGFP_TYPE_DEFAULT
    MAX_UNICODE_PATH ushort <c-array>
    [ SHGetFolderPath drop ] keep alien>native-string ;

: desktop ( -- str )
    CSIDL_DESKTOPDIRECTORY shell32-directory ;

: my-documents ( -- str )
    CSIDL_PERSONAL shell32-directory ;

: application-data ( -- str )
    CSIDL_APPDATA shell32-directory ;

: windows-directory ( -- str )
    CSIDL_WINDOWS shell32-directory ;

: programs ( -- str )
    CSIDL_PROGRAMS shell32-directory ;

: program-files ( -- str )
    CSIDL_PROGRAM_FILES shell32-directory ;

: program-files-x86 ( -- str )
    CSIDL_PROGRAM_FILESX86 shell32-directory ;

: program-files-common ( -- str )
    CSIDL_PROGRAM_FILES_COMMON shell32-directory ;

: program-files-common-x86 ( -- str )
    CSIDL_PROGRAM_FILES_COMMONX86 shell32-directory ;


CONSTANT: SHCONTF_FOLDERS 32
CONSTANT: SHCONTF_NONFOLDERS 64
CONSTANT: SHCONTF_INCLUDEHIDDEN 128
CONSTANT: SHCONTF_INIT_ON_FIRST_NEXT 256
CONSTANT: SHCONTF_NETPRINTERSRCH 512
CONSTANT: SHCONTF_SHAREABLE 1024
CONSTANT: SHCONTF_STORAGE 2048

TYPEDEF: DWORD SHCONTF

CONSTANT: SHGDN_NORMAL 0
CONSTANT: SHGDN_INFOLDER 1
CONSTANT: SHGDN_FOREDITING 0x1000
CONSTANT: SHGDN_INCLUDE_NONFILESYS 0x2000
CONSTANT: SHGDN_FORADDRESSBAR 0x4000
CONSTANT: SHGDN_FORPARSING 0x8000

TYPEDEF: DWORD SHGDNF

ALIAS: SFGAO_CANCOPY           DROPEFFECT_COPY
ALIAS: SFGAO_CANMOVE           DROPEFFECT_MOVE
ALIAS: SFGAO_CANLINK           DROPEFFECT_LINK
CONSTANT: SFGAO_CANRENAME         0x00000010
CONSTANT: SFGAO_CANDELETE         0x00000020
CONSTANT: SFGAO_HASPROPSHEET      0x00000040
CONSTANT: SFGAO_DROPTARGET        0x00000100
CONSTANT: SFGAO_CAPABILITYMASK    0x00000177
CONSTANT: SFGAO_LINK              0x00010000
CONSTANT: SFGAO_SHARE             0x00020000
CONSTANT: SFGAO_READONLY          0x00040000
CONSTANT: SFGAO_GHOSTED           0x00080000
CONSTANT: SFGAO_HIDDEN            0x00080000
CONSTANT: SFGAO_DISPLAYATTRMASK   0x000F0000
CONSTANT: SFGAO_FILESYSANCESTOR   0x10000000
CONSTANT: SFGAO_FOLDER            0x20000000
CONSTANT: SFGAO_FILESYSTEM        0x40000000
CONSTANT: SFGAO_HASSUBFOLDER      0x80000000
CONSTANT: SFGAO_CONTENTSMASK      0x80000000
CONSTANT: SFGAO_VALIDATE          0x01000000
CONSTANT: SFGAO_REMOVABLE         0x02000000
CONSTANT: SFGAO_COMPRESSED        0x04000000
CONSTANT: SFGAO_BROWSABLE         0x08000000
CONSTANT: SFGAO_NONENUMERATED     0x00100000
CONSTANT: SFGAO_NEWCONTENT        0x00200000

TYPEDEF: ULONG SFGAOF

STRUCT: DROPFILES
    { pFiles DWORD }
    { pt POINT }
    { fNC BOOL }
    { fWide BOOL } ;
TYPEDEF: DROPFILES* LPDROPFILES
TYPEDEF: DROPFILES* LPCDROPFILES
TYPEDEF: HANDLE HDROP

STRUCT: SHITEMID
    { cb USHORT }
    { abID BYTE[1] } ;
TYPEDEF: SHITEMID* LPSHITEMID
TYPEDEF: SHITEMID* LPCSHITEMID

STRUCT: ITEMIDLIST
    { mkid SHITEMID } ;
TYPEDEF: ITEMIDLIST* LPITEMIDLIST
TYPEDEF: ITEMIDLIST* LPCITEMIDLIST
TYPEDEF: ITEMIDLIST ITEMID_CHILD
TYPEDEF: ITEMID_CHILD* PITEMID_CHILD
TYPEDEF: ITEMID_CHILD* PCUITEMID_CHILD

CONSTANT: STRRET_WSTR 0
CONSTANT: STRRET_OFFSET 1
CONSTANT: STRRET_CSTR 2

UNION-STRUCT: STRRET-union
    { pOleStr LPWSTR }
    { uOffset UINT }
    { cStr char[260] } ;
STRUCT: STRRET
    { uType int }
    { value STRRET-union } ;

COM-INTERFACE: IEnumIDList IUnknown {000214F2-0000-0000-C000-000000000046}
    HRESULT Next ( ULONG celt, LPITEMIDLIST* rgelt, ULONG* pceltFetched )
    HRESULT Skip ( ULONG celt )
    HRESULT Reset ( )
    HRESULT Clone ( IEnumIDList** ppenum ) ;

COM-INTERFACE: IShellFolder IUnknown {000214E6-0000-0000-C000-000000000046}
    HRESULT ParseDisplayName ( HWND hwndOwner,
                               void* pbcReserved,
                               LPOLESTR lpszDisplayName,
                               ULONG* pchEaten,
                               LPITEMIDLIST* ppidl,
                               ULONG* pdwAttributes )
    HRESULT EnumObjects ( HWND hwndOwner,
                          SHCONTF grfFlags,
                          IEnumIDList** ppenumIDList )
    HRESULT BindToObject ( LPCITEMIDLIST pidl,
                           void* pbcReserved,
                           REFGUID riid,
                           void** ppvOut )
    HRESULT BindToStorage ( LPCITEMIDLIST pidl,
                            void* pbcReserved,
                            REFGUID riid,
                            void** ppvObj )
    HRESULT CompareIDs ( LPARAM lParam,
                         LPCITEMIDLIST pidl1,
                         LPCITEMIDLIST pidl2 )
    HRESULT CreateViewObject ( HWND hwndOwner,
                               REFGUID riid,
                               void** ppvOut )
    HRESULT GetAttributesOf ( UINT cidl,
                              LPCITEMIDLIST* apidl,
                              SFGAOF* rgfInOut )
    HRESULT GetUIObjectOf ( HWND hwndOwner,
                            UINT cidl,
                            LPCITEMIDLIST* apidl,
                            REFGUID riid,
                            UINT* prgfInOut,
                            void** ppvOut )
    HRESULT GetDisplayNameOf ( LPCITEMIDLIST pidl,
                               SHGDNF uFlags,
                               STRRET* lpName )
    HRESULT SetNameOf ( HWND hwnd,
                        LPCITEMIDLIST pidl,
                        LPCOLESTR lpszName,
                        SHGDNF uFlags,
                        LPITEMIDLIST* ppidlOut ) ;

FUNCTION: HRESULT SHGetDesktopFolder ( IShellFolder** ppshf )

FUNCTION: UINT DragQueryFileW ( HDROP hDrop,
                                UINT iFile,
                                LPWSTR lpszFile,
                                UINT cch )
ALIAS: DragQueryFile DragQueryFileW

FUNCTION: BOOL IsUserAnAdmin ( )
