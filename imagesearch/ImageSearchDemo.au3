#AutoIt3Wrapper_UseX64=n
#include <ImageSearch.au3>

$searchResult = findImage(0, 0, @DesktopWidth, @DesktopHeight, "D:\System\autoit\imagesearch\chrome.png", 10)
ConsoleWrite("moo =" & $searchResult[0] & ", "& $searchResult[1] & @CRLF)